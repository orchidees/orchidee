function [db_s] = FputAmpMeanInDBstruct(db_s, pos_v, handles)

if nargin < 3
    handles = [];
end


fid = -1;

loudnessExp = .6;
%dynLoudness_c = {'fff', 33; 'ff', 28; 'f', 23; 'mf', 18; 'm', 16; 'mp', 15; ...
%    'p', 8; 'pp', 3; 'fp', 15; 'ppff', 18; 'ffpp', 16; ...
%    'ppmfpp', 8 };

check_interruption();
server_says(handles,'Processing mean partial amplitudes',0);

if nargin < 2
    pos_v = 1:length(db_s.data_s);
end
lastwarn('')
for k=pos_v
    %
    %try
    
    if exist(FgetPartFileName(db_s, k))
    
        sdiffid = Fsdifopen(FgetPartFileName(db_s, k));
        trc_s = Fsdifread(sdiffid, []);
        part_s = [trc_s.data];
        Fsdifclose(sdiffid);
        amp_m = FtrcToMat(part_s, 100);
    
    end

    mel_s = Fload(FgetMelFileName(db_s, k),1);

    %targetLoudness =  dynLoudness_c{...
    %    strmatch(db_s.data_s(k).dynamique,dynLoudness_c(:,1), ...
    %    'exact'), 2};
    targetLoudness = Fdyn2loudnessLevel(db_s.data_s(k).dynamique);
    
    N6source  = FcalcN6(mel_s);
    %N6cible =  dynLoudness_c{...
    %    strmatch(db_s.data_s(k).dynamique,dynLoudness_c(:,1), ...
    %    'exact'), 2};
    N6cible = Fdyn2loudnessLevel(db_s.data_s(k).dynamique);
    
    L6source = 2^(N6source/10);
    L6cible = 2^(N6cible/10);
    ld_v = sum(mel_s.value.^.6, 1);

    Lfacteur = L6cible^(1/loudnessExp) ./ ...
        L6source^(1/loudnessExp);
    
    if exist('sdiffid')
    
        amp_m = amp_m .* Lfacteur;
        
        fs=1./median(diff([trc_s.time]));
        [ampMean_v, ampStd_v, ampStdN_v] = FpartialsMeanStd(amp_m,ld_v,fs);
        ampMeanNorm = norm(ampMean_v);

        fs=100;
        clear fs;
        db_s.data_s(k).ampMean_v = ampMean_v ./ ampMeanNorm;
        db_s.data_s(k).ampMeanEner = ampMeanNorm^2;
    
    else
        
        db_s.data_s(k).ampMean_v = ones(100,1)*NaN;
        db_s.data_s(k).ampMeanEner = NaN;
        
    end
        
    db_s.data_s(k).Lfacteur = Lfacteur;

    lastMsg = lastwarn;
%     if ~isempty(lastMsg)
%         keyboard;
%         fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
%             lastMsg);
%         lastwarn('');
%     end
    check_interruption();
    server_says(handles,'Processing mean partial amplitudes',k/length(db_s.data_s));

    %     catch
    %         %cd(current_dir);
    %         if fid == -1
    %             [fid] = FOopenLogFile;
    %         end
    %         logMessage = [lasterr];
    %         FOwriteLog(fid, logMessage);
    %     end
end

FOcloseLogFile(fid);

