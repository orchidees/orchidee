function handles = osc_dbgetfieldvaluelist(osc_message,handles)

% OSC_GETFIELDVALUELIST - Return all the possible values that a
% database field may take. If the field is queryable, values are sorted
% and duplicates are removed. Else, the function is equivalent to
% osc_dbgetfiledvalues. The input field may eventually be filtered by an
% additional input index file.
%
% Usage: handles = osc_dbgetfieldvaluelist(osc_message,handles)
%

% Check that output is specified
if length(osc_message.data) < 2
    error('orchidee:osc:osc_dbgetfieldvaluelist:MissingOutput', ...
        [ 'Output (''message'' or filename) is missing.' ]);
end

% Check output type
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_dbgetfieldvaluelist:BadArgumentType', ...
        [ 'Output (''message'' or filename) must be a string.' ]);
end

% Check database field is specified
if length(osc_message.data) < 3
    error('orchidee:osc:osc_dbgetfieldvaluelist:IncompleteOscMessage', ...
        'Field name missing.')
end

% Get DB queryable fields
dbfields = get_fields_info(handles.instrument_knowledge,'list');
queryable = get_fields_info(handles.instrument_knowledge,'query');
queryfields = dbfields(find(queryable));

% Get values in database
if ismember(osc_message.data{3},queryfields)
    % If a 4th argument is specified, take it as an input index file
    % and read it
    if length(osc_message.data) == 4
        idx = read_index_file(osc_message.data{4});
        values = get_field_value_list(handles.instrument_knowledge,osc_message.data{3},idx);
    else
        values = get_field_value_list(handles.instrument_knowledge,osc_message.data{3});
    end
else
    % If a 4th argument is specified, take it as an input index file
    % and read it
    if length(osc_message.data) == 4
        idx = read_index_file(osc_message.data{4});
        values = get_field_values(handles.instrument_knowledge,osc_message.data{3},idx);
    else
        values = get_field_values(handles.instrument_knowledge,osc_message.data{3});
    end
end

if ~ismember(osc_message.data{3},queryfields)
  
    % Raise excpetion if input fields is not queryable and output is
    % 'message'
    if strcmp(osc_message.data{2},'message')
        error('orchidee:osc:osc_dbgetfieldvalues:BadArgumentValue', ...
            '/dbgetfieldvaluelist does not work with non-queryable fields.');
    else
        % Write DB fields in output file
        write_data_file(osc_message.data{2},values,handles);

        % Send back the OSC message
        message.path = '/dbfieldvaluelist';
        message.tt = 'is';
        message.data{1} = osc_message.data{1};
        message.data{2} = osc_message.data{2};
        
        % Add to OSC buffer
        flux{1} = message;

        % Send message
        osc_send(handles.osc.address,flux);
    end
        

else

    % If output is the 'message' keyword, send back the field list in
    % the OSC message
    if strcmp(osc_message.data{2},'message')

        % Build OSC message
        message.path = '/dbfieldvaluelist';
        message.tt = 'is';
        message.data{1} = osc_message.data{1};
        message.data{2} = osc_message.data{3};
        
        % Append filed values to OSC message
        for i = 1:length(values)
            if isnumeric(values)
                message.data{i+2} = values(i);
                message.tt = [ message.tt 'f' ];
            else
                message.data{i+2} = values{i};
                message.tt = [ message.tt 's' ];
            end
        end

        % Add to OSC buffer
        flux{1} = message;

        % Send message
        osc_send(handles.osc.address,flux);

    else
        
        % Write DB fields in output file
        write_data_file(osc_message.data{2},values,handles);

        % Send back the OSC message
        message.path = '/dbfieldvaluelist';
        message.tt = 'is';
        message.data{1} = osc_message.data{1};
        message.data{2} = osc_message.data{2};
        
        % Add to OSC buffer
        flux{1} = message;

        % Send message
        osc_send(handles.osc.address,flux);

    end

end