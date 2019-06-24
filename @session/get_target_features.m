function target_features = get_target_features(session_instance)

% GET_TARGET_FEATURES - Target sound features accessor.
%
% Usage: target_features = get_target_features(session_instance)
%

target_features = get_features(session_instance.target);
