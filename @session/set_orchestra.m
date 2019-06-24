function session_instance = set_orchestra(session_instance,knowedge_instance,instlist,resolution)

% SET_ORCHESTRA - Change the instrument list and/or the
% microtonic resolution of the orchestra.
%
% Usage: session_instance = set_orchestra(session_instance,knowedge_instance,instlist,resolution)
%

% Check argument number
if nargin < 4
    error('orchidee:session:set_orchestra:BadArgumentNumber', ...
        'Knowledge, instrument list and resolution required (even empty).');
end

% Attribute and variable domains will need to be recomputed
session_instance.need_update.dom_attributes = 1;
session_instance.need_update.dom_variables = 1;

% If microtonic resolution is modified, the feature matrices will
% need to be recomputed
if ~isempty(resolution)
    session_instance.need_update.mat_features = 1;
end

% get old instrument list and resolution
[instlist_old,resolution_old] = get_orchestra(session_instance);

% Update only new data
if isempty(instlist)
   instlist = instlist_old;
end

if isempty(resolution)
   resolution = resolution_old;
end

% Create new orchestra
session_instance.orchestra = orchestra(knowedge_instance,instlist,resolution);

% Eventually update the filter on the 'note' attribute
[t,idx] = ismember('note',session_instance.filter_names);
if t
    session_instance.filters(idx) = update_value_list(session_instance.filters(idx), ...
        get_possible_notes(knowedge_instance,resolution));
end

% If autodelta = true, recompute delta
if get_target_parameter(session_instance,'autodelta')
    session_instance = set_target_parameter(session_instance,'autodelta',1);
end