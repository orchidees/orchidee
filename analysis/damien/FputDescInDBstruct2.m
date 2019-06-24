function [db_s] = FputDescInDBstruct2(db_s, pos_v, handles)

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
% dynLoudness_c = {'fff', 33; 'ff', 28; 'f', 23; 'mf', 18; 'm', 16; 'mp', 15; ...
%     'p', 8; 'pp', 3; 'fp', 15; 'ppff', 18; 'ffpp', 16; ...
%     'ppmfpp', 8 };

check_interruption();
server_says(handles,'Processing ircamdescriptors',0);

if nargin < 2
    pos_v = 1:length(db_s.data_s);
end
lastwarn('')
for k=pos_v
 %   try
       
        
        D = Fload(FgetDescFileName(db_s, k),1);
        
        db_s.data_s(k).scPOW = D.DS.i_sc_v.mean(2);
        db_s.data_s(k).ssPOW = D.DS.i_ss_v.mean(2);
        db_s.data_s(k).LogAttackTime = D.DE.g_lat.value;
        
        lastMsg = lastwarn;
        if ~isempty(lastMsg)
            fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
                    lastMsg);
            lastwarn('');
        end
        
        check_interruption();
        server_says(handles,'Processing ircamdescriptors',k/length(db_s.data_s));
 
%     catch
%         keyboard
%         erreur_s = lasterror;
%         fprintf(fid, '%s   %s\n', db_s.data_s(k).file, ...
%                 lasterr);
%         warning(['An error occured: ', lasterr]);   
%         lastwarn('');
%     end
end

fclose(fid);

