function orchidee()

% ORCHIDEE - Orchidee server main function.
%
% Usage: [] = orchidee();
%

% Assign empty handle struct
handles = [];

% Clear previous log files
if exist('~/Library/Logs/IRCAM/Orchidee/','dir')
    !rm ~/Library/Logs/IRCAM/Orchidee/*.log
end

% Clear previous non-OSC instruction files
!rm /tmp/orchideequit
!rm /tmp/orchideeinterrupt

% Lauch OSC server
oscserver(handles);