function session_instance = analyze_sound_file(session_instance,knowledge_instance,handles)

% ANALYZE_SOUND_FILE - Extract signal features from target sound.
%
% Usage: session_instance = analyze_sound_file(session_instance,knowledge_instance,handles)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Extract sound target features (perceptual descriptors)
session_instance.target = analyze_sound_file(session_instance.target,knowledge_instance,handles);

% Update delta parameter
delta = update_delta(session_instance.target,session_instance);
    
% Set new value of delta parameter in target
session_instance = set_target_parameter(session_instance,'delta',delta);