function target_instance = target()

% TARGET - Target instance constructor. Return an empty instance
% with default sound analysis parameters.
%
% Usage: target_instance = target()
%

% Target slots
target_instance.soundfile = '';
target_instance.filetype = '';
target_instance.parameters = default_analysis_params();
target_instance.features = [];

% Assign fieldnames
target_instance.fieldnames = fieldnames(target_instance);

% Build class
target_instance = class(target_instance,'target');