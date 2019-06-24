function handles = osc_set_filter(osc_message,handles)

% OSC_SET_FILTER - Set a filter on a database queryable field, in
% order to restrict/extend the search space
%
% Usage: handles = osc_set_filter(osc_message,handles)
%

% Check that a session is opened
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% Check input arguments
if length(osc_message.data) < 3
    error('orchidee:osc:osc_set_filter:BadArgumentNumber', ...
        [ 'Two few arguments for /setfilter.' ]);
end
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_set_filter:BadArgumentType', ...
        [ 'Attribute must be a string.' ]);
end
if ~ischar(osc_message.data{3})
    error('orchidee:osc:osc_set_filter:BadArgumentType', ...
        [ 'Filter mode must be a string.' ]);
end

% Set filter
if length(osc_message.data) >= 4
    % 'include', 'exclude' or 'force' mode
    if ischar(osc_message.data{4})
        handles.session = set_filter(handles.session,osc_message.data{2}, ...
                          osc_message.data{3},osc_message.data(4:length(osc_message.data)));
    elseif isnumeric(osc_message.data{4})
        
        handles.session = set_filter(handles.session,osc_message.data{2}, ...
                          osc_message.data{3},cell2mat(osc_message.data(4:length(osc_message.data))));
    end
else
    % 'auto' or 'free' mode
    handles.session = set_filter(handles.session,osc_message.data{2},osc_message.data{3},{});
end