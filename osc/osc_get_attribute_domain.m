function handles = osc_get_attribute_domain(osc_message,handles)

% OSC_GET_ATTRIBUTE_DOMAIN - For a given attribute (or a queryable
% field of the database), return the list of allowed values in the
% search for orchestrations.
%
% Usage: handles = osc_get_attribute_domain(osc_message,handles)
%


server_says(handles,'Get attribute domain ...',0);

% Check that a session is opened
if isempty(handles.session)
    error('orchidee:osc:osc_get_attribute_domain:UexpectedMessage', ...
        [ 'First open a session.' ]);
end

% Check input arguments
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbgetfieldvaluelist:MissingOutput', ...
        [ 'Output (''message'' or filename) is missing.' ]);
end
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_dbgetfieldvaluelist:BadArgumentType', ...
        [ 'Output (''message'' or filename) must be a string.' ]);
end
if length(osc_message.data) < 3
    error('orchidee:osc:osc_get_attribute_domain:BadArgumentNumber', ...
        [ 'Missing Attribute.' ]);
end
if ~ischar(osc_message.data{3})
    error('orchidee:osc:osc_get_attribute_domain:BadArgumentType', ...
        [ 'Attribute must be a string.' ]);
end

% Get attibute domain
[domain,handles.session] = get_attribute_domain(handles.session, ...
    handles.instrument_knowledge,osc_message.data{3},handles);

% If the output is the 'message' keyword, return the list in an OSC
% message
if strcmp(osc_message.data{2},'message')

    % Build message
    message.path = '/attributedomain';
    message.tt = 'is';
    message.data{1} = osc_message.data{1};
    message.data{2} = osc_message.data{3};

    % Add values to message data
    for i = 1:length(domain)
        if iscell(domain)
            message.tt = [ message.tt 's' ];
            message.data{2+i} = domain{i};
        else
            message.tt = [ message.tt 'f' ];
            message.data{2+i} = domain(i);
        end
    end

    % Add to OSC buffer
    flux{1} = message;

    % Send message
    osc_send(handles.osc.address,flux);

else
    % Write value list in a text file
    write_data_file(osc_message.data{2},domain,handles);

    % Build a simple OSC response message
    message.path = '/attributedomain';
    message.tt = 'is';
    message.data{1} = osc_message.data{1};
    message.data{2} = osc_message.data{2};

    % Add to OSC buffer
    flux{1} = message;

    % Send message
    osc_send(handles.osc.address,flux);

end

server_says(handles,'Get attribute domain ...',1);