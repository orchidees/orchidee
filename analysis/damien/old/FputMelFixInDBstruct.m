function [db_s] = FputMelFixInDBstruct(db_s, pos_v, handles)

if nargin < 3
    handles = [];
end


LOGDIR = '/tmp/';
filename = [LOGDIR '/' 'log_' mfilename '_' inputname(1) '_' datestr(now, 'dd-mm-yyyy_HH-MM-SS') '.txt'];  

fid = fopen(filename, 'w');

if fid == -1
    error('Can''t open log file')
    
end

loudnessExp = .6;
dynLoudness_c = {'fff', 33; 'ff', 28; 'f', 23; 'mf', 18; 'mp', 15; ...
                 'p', 8; 'pp', 3; 'fp', 15};

server_says(handles,'Processing Mel envelope',0);

if nargin < 2
    pos_v = 1:length(db_s.data_s);
end
lastwarn('')
for k=pos_v
    %try
       
        mel_s = Fload(FgetMelFixFileName(db_s, k),1);
        
        targetLoudness =  dynLoudness_c{... 
            strmatch(db_s.data_s(k).dynamique,dynLoudness_c(:,1), ...
                     'exact'), 2};
        
        N6source  = FcalcN6(mel_s);
        N6cible =  dynLoudness_c{... 
            strmatch(db_s.data_s(k).dynamique,dynLoudness_c(:,1), ...
                     'exact'), 2};
        L6source = 2^(N6source/10);
        L6cible = 2^(N6cible/10);
        ld_v = sum(mel_s.value.^.6, 1);
        
        Lfacteur = L6cible^(1/loudnessExp) ./ ...
            L6source^(1/loudnessExp);
        

        mel_m = mel_s.value' .* Lfacteur;

	if size(mel_m, 1)>1
	    fs=1./median(diff(mel_s.time));
	    ld_v =  Fevalbp([mel_s.time; ld_v]', (0:size(mel_m, 1)-1)./fs);
	    [melMean_v, melStd_v, melStdN_v] = FpartialsMeanStd(mel_m,ld_v,fs);
	    clear fs;
	else
	    melMean_v = mel_m;
	    melStdN_v = 0;
	    melStd_v = 0;
	end

	melMeanNorm = norm(melMean_v);
        db_s.data_s(k).melfMean_v = melMean_v ./ melMeanNorm;
        db_s.data_s(k).melfMeanEner = melMeanNorm^2;
%         db_s.data_s(k).melfStd_v = melStd_v;
%         db_s.data_s(k).melfStdN_v = melStdN_v;
%         db_s.data_s(k).melfStdMean = mean(melStd_v);
%         db_s.data_s(k).melfStdNMean = mean(melStdN_v);
        
        lastMsg = lastwarn;
        if ~isempty(lastMsg)
            fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
                    lastMsg);
            lastwarn('');
        end
        server_says(handles,'Processing Mel envelope',k/length(db_s.data_s));
%     catch
%         erreur_s = lasterror;
%         fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
%                 lasterr);
%         warning(['An error occured: ', lasterr]);   
%         lastwarn('');
%         keyboard
%     end
end

fclose(fid);

