function log_file = log_file_name()

% LOG_FILE_NAME - Ouput log file name
% (located in the ~/Preferences/Logs/IRCAM/Orchidee/ directory)
%
% Usage: log_file = log_file_name()
% 

if ~exist('~/Library/Logs/IRCAM/')
    mkdir('~/Library/Logs/IRCAM/');
end
if ~exist('~/Library/Logs/IRCAM/Orchidee/')
    mkdir('~/Library/Logs/IRCAM/Orchidee/');
end

log_file = [ '~/Library/Logs/IRCAM/Orchidee/orchidee.' datestr(now,'yyyy.mm.dd.HH.MM.SS') '.log' ];