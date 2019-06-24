function osc_s = read_osc_settings()

% READ_OSC_SETTINGS - Read OSC settings from a preference file
% (eventually created with default values if it does not exist).
%
% Usage: osc_s = read_osc_settings() 
%

osc_s = [];

% Preferences file name:
settings_file = '~/Library/Preferences/IRCAM/Orchidee/oscprefs';

% If preferences file exist, read it
if exist(settings_file)
    
    % Open preferences file
    fid = fopen(settings_file,'r');
    settings_str = fscanf(fid,'%s');
    fclose(fid);

    % Read IP address
    ip_begin = strfind(settings_str,'/ip')+3;
    ip_end = strfind(settings_str,'/sp')-1;

    % Read send port
    sp_begin = strfind(settings_str,'/sp')+3;
    sp_end = strfind(settings_str,'/rp')-1;

    % Read receive port
    rp_begin = strfind(settings_str,'/rp')+3;
    rp_end = strfind(settings_str,'/eof')-1;

    % Compute output structure
    osc_s.ip = settings_str(ip_begin:ip_end);
    osc_s.receiveport = str2num(settings_str(rp_begin:rp_end));
    osc_s.sendport = str2num(settings_str(sp_begin:sp_end));

else
    
    % Create a prefences file if no former file exist
    % -- Create the preferences dir
    DIR = '~/Library/Preferences/IRCAM/Orchidee/';
    if ~exist(DIR)
        mkdir(DIR);
    end
    % -- Read default OSC settings
    osc_s = default_osc_settings();
    % -- Write preferences file
    write_osc_settings(osc_s);
    
end