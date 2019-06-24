function pm2_pathes = find_pm2_pathes()

% FIND_PM2_PATHES - Returns all locations of the pm2
% executable from the follwing folders:
% - /Appllication/Orchidee*
% - /Applications/AudioSculpt*
%
% Usage: pm2_pathes = find_pm2_pathes()
%


pm2_pathes = {};

cmd = 'find /Applications/Orchidee* -name "pm2"';
[s,w] = unix(cmd);
w = strrep(w,' ','\ ');
w = w(1:length(w)-1);
pm2_pathes = [ pm2_pathes ; w ];

app_contents_s = dir('/Applications/');

audioscuplt_dirs = {};

pat = '[Aa][Uu][Dd][Ii][Oo][Ss][Cc][Uu][Ll][Pp][Tt]';

for i = 1:length(app_contents_s)
    if regexp(app_contents_s(i).name,pat)
        audioscuplt_dirs = [ audioscuplt_dirs ; ['/Applications/' app_contents_s(i).name ''] ];
    end
end

pat = [ pat ' ' ];

for i = 1:length(audioscuplt_dirs)
    
    cmd = [ 'find ''' audioscuplt_dirs{i} ''' -name ''pm2'' -type f' ];
    [s,w] = unix(cmd);
    idx = max(strfind(w,'pm2'));
    w = w(1:idx+2);
    idx = regexp(w,pat,'once');
    if ~isempty(idx)
        oldpat = w(idx:idx+11);
        newpat = strrep(oldpat,' ','\ ');
        w = strrep(w,oldpat,newpat);
    end
    pm2_pathes = [ pm2_pathes ; w ];
    
end
