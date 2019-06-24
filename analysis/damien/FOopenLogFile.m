function [fid] = FOopenLogFile
    
LOGDIR = '~/Library/Logs/IRCAM/Orchidee/';
stack_s = dbstack;
filename = [LOGDIR '/' stack_s(2).name '_' datestr(now, 'dd-mm-yyyy_HH-MM-SS') '.log'];  

if ~exist(LOGDIR)
    mkdir(LOGDIR);
end
fid = fopen(filename, 'w');
if fid == -1
    error(['Can''t open log file', filename]) 
end
