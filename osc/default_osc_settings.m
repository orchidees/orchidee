function osc_s = default_osc_settings()

% DEFAULT_OSC_SETTINGS - Default OSC settings for the Orchidee OSC
% server.
%
% Usage: osc_s = default_osc_settings()
%

osc_s.ip = '127.0.0.1';
osc_s.sendport = 9999;
osc_s.receiveport = 9998;