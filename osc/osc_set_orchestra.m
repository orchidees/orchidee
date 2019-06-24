function handles = osc_set_orchestra(osc_message,handles)

% OSC_SET_ORCHESTRA - Set new orchestra in current session
%
% Usage: handles = osc_set_orchestra(osc_message,handles)
%

% Open a new session if necessary
if isempty(handles.session)
    handles.session = session(handles.instrument_knowledge);
    handles = osc_get_targetparameters(osc_message,handles);
end

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_set_orchestra:BadArgumentNumber', ...
        [ 'Two few arguments for /setorchestra.' ]);
end

% Get instrument list from OSC message
true_message = osc_message.data(2:length(osc_message.data));

instlist = {};

for k = 1:length(true_message)
    
    this_group = {};
    
    % Check type of list elements
    if ~ischar(true_message{k})
        error('orchidee:osc:osc_set_orchestra:BadArgumentType', ...
            [ 'At least one instrument or group is not a string.' ]);
    end
    
    % Remove double-slashes in subgroups
    inst_str = [ true_message{k} '/' ];
    inst_str = strrep(inst_str,'//','/');
    inst_str = strrep(inst_str,'//','/');
    
    % Convert OSC string into cell array
    instlist{k} = parse_inst_str(inst_str);
    
end

% Set orchestra in current session
handles.session = set_orchestra(handles.session,handles.instrument_knowledge,instlist,[]);




function out_str = parse_inst_str(in_str)

% Convert OSC string into cell array of instrument symbols

if isempty(in_str)
    out_str = {};
else
    if in_str(1)=='/';
        in_str = in_str(2:length(in_str));
    end
    i_slash = min(find(in_str=='/'));
    if isempty(i_slash)
        out_str = {};
    else
        out_str = [ in_str(1:i_slash-1) parse_inst_str(in_str(i_slash+1:length(in_str))) ];
    end
end