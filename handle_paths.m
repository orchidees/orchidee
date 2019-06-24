function handle_paths(mode)

% HANDLE_PATHS - Add or remove Orchidee source directories to the
% Matlab path.
%
% Usage: handle_paths('load')   -> Add directories to path
%        handle_paths('unload') -> Remove directories from path
%

pathes = { ...
    'path/' ...
    'xml/' ...
    'xml/toolbox/' ...
    'osc/' ...
    'osc/mex/' ...
    'utils/' ...
    'io/' ...
    'analysis' ...
    'analysis/ircamdescriptor/' ...
    'analysis/sdif/' ...
    'analysis/damien/' ...
    'features/' ...
    'features/compare/' ...
    'features/compute/' ...
    'features/neutral/' ...
    'features/transpo/' ...
    'genetic/' ...
    'multiobjective/' ...
    'errors/' ...
    };

root_dir = which('orchidee.m');
root_dir = strrep(root_dir,'orchidee.m','');

switch mode
    case 'load'
        cmd = 'addpath';
    case 'unload'
        cmd = 'rmpath';
    otherwise
        error([ mode ' : unknown path handling mode.']);
end

disp([cmd ' ' root_dir ]);
eval([cmd ' ' root_dir ])
for k = 1:length(pathes)
    disp([cmd ' ' root_dir pathes{k}]);
    eval([cmd ' ' root_dir pathes{k}])
end