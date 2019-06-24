function write_osc_settings(osc_s)

% WRITE_OSC_SETTINGS - Write a preferences file with OSC settings.
%
% Usage: write_osc_settings(osc_s)
%

% Get OSC current settings
settings_str = [ '/ip' osc_s.ip ...
    '/sp' num2str(osc_s.sendport) ...
    '/rp' num2str(osc_s.receiveport) '/eof' ];

% Write preferences file
settings_file = '~/Library/Preferences/IRCAM/Orchidee/oscprefs';
fid = fopen(settings_file,'w');
fprintf(fid,'%s',settings_str);
fclose(fid);