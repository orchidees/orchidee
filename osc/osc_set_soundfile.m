function handles = osc_set_soundfile(osc_message,handles)

% OSC_SETSOUNDFILE - Define a sound file as the new sound target
%
% Usage: handles = osc_set_soundfile(osc_message,handles)
%

% Open a new session if necessary
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_set_soundfile:MissingOutput', ...
        [ 'Input soundfile is missing.' ]);
end
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_set_soundfile:BadArgumentType', ...
        [ 'Input soundfile must be a string.' ]);
end

% Set sound file as the new sound target 
handles.session = set_sound_file(handles.session,osc_message.data{2});
