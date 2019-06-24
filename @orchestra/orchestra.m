function orchestra_instance = orchestra(knowledge_instance,instrument_list,microtonic_resolution)

% ORCHESTRA - Constructor of class 'orchestra'. Required argument
% is a knowledge instance. Optional arguments are instrument list
% (cellstr) and microtonic resolution (double). Instrument list may
% be a cell array of strings or a cell array of cell arrays of
% strings.
%
% Ex: { 'Vn' 'Vn' 'Va 'Vc 'Cb' } defines a string quintet.
% Ex: { { 'BTbn' 'TTbn' } { 'ClBb' 'BClBb'} { 'Vn' } } is a trio
% with a trombonist who can play either bass or tenor trombone, a
% clarinetist who can play either standart Bb or bass clarinet, and
% a violinist.
%
% Usage: orchestra_instance = orchestra(knowledge_instance,<instrument_list>,<microtonic_resolution>)
%
% Default value for instrument list: One of each instrument in the knowledge instance (sorted in orchestral order).
% Default value for microtonic resolution: 2 (1/4 tone)
%

% Allowed values for microtonic resolution (divisions of semitone)
% 1 <=> 1/2 tone
% 2 <=> 1/4 tone
% 4 <=> 1/8 tone
% 8 <=> 1/16 tone
allowed_resolutions = [ 1 2 4 8 ];


if nargin < 3
    % Assign default resolution if needed
    microtonic_resolution = 2;
end

if nargin < 2
    % Get orchestral order
    scoreorder = get_score_order(knowledge_instance);
    % Assign default instrument list if needed
    instrument_list = regexp(scoreorder, '\w*', 'match');
    
else

    if isnumeric(instrument_list)
        
        % If instrument_list is a number, take it as the size of
        % the orchestra and allocate a cell array
        instrument_list = cell(1,round(instrument_list));
        
    else
        
        % Get allowed instruments from database
        allowed_instruments = get_field_value_list(knowledge_instance,'instrument');
        [flat_inst_list,max_depth] = flatcell(instrument_list);
        
        % Check validity of instrument list
        if max_depth > 2
            error('orchidee:orchestra:orchestra:BadArgumentValue', ...
                [ 'Recursion level in instrument list is too high.' ]);
        end

        % Check validity of instrument values
        T = ~ismember(flat_inst_list,allowed_instruments);
        if sum(T)
            idx = find(T,1,'first');
            error('orchidee:orchestra:orchestra:BadArgumentValue', ...
                [ '''' flat_inst_list{idx} ''': no such instrument in database.' ]);
        end

    end
end

% Check validity of input resolution value
if ~ismember(microtonic_resolution,allowed_resolutions)
    error('orchidee:orchestra:orchestra:BadArgumentValue', ...
        [ 'Allowed values for microtonic resolution: ' mat2str(allowed_resolutions) ' (fractions of semitones).']);
end

% Assign orchestra slots
orchestra_instance.instrument_list = instrument_list;
orchestra_instance.allowed_resolutions = allowed_resolutions;
orchestra_instance.microtonic_resolution = microtonic_resolution;

% Assign object field names
orchestra_instance.fieldnames = fieldnames(orchestra_instance);

% Build class instance
orchestra_instance = class(orchestra_instance,'orchestra');
