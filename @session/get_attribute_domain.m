function [domain,session_instance] = get_attribute_domain(session_instance,knowledge_instance,domain_name,handles)

% GET_ATTRIBUTE_DOMAIN - Filter field domain accessor. Return the
% list of values allowed in search for a databse field associated
% with a filter. If no field is specified, return all domains as a
% strcture.
%
% Usage: [domain,session_instance] = get_attribute_domain(session_instance,knowledge_instance,<domain_name>,<handles>)
%

% Check if in server mode
if nargin < 4
    handles = [];
end

% Eventually update search structure
session_instance = update_search_structure(session_instance,knowledge_instance,'attributes',handles);

% Convert search structure object into structure
ss = struct(session_instance.search_structure);

% Default behavior: return all attribute domains as a structure
if nargin < 3
    domain_name = 'all';
end

switch domain_name

    case 'all'
        
        % Return all attribute domains as a structure
        % If all values are allowed for a given attribute, the
        % corresponding field has the value 'all' instead of the
        % whole value list
        domain = ss.attribute_domains;

    otherwise

        % Check validity of input field
        if ~ismember(domain_name,fieldnames(ss.attribute_domains))
            error('orchidee:session:get_domain:BadArgumentValue', ...
                [ '''' domain_name ''' : unknown filter field.' ] );
        end
        
        % Get allowed field values
        domain = ss.attribute_domains.(domain_name);

        if ischar(domain) && strcmp(domain,'all')
            
            % If all values are allowed, replace the keyword 'all'
            % by the entire value set
            domain = get_field_value_list(knowledge_instance,domain_name);
            
            % Special exception for field 'note': Account for
            % icrotonic resolution of the orchestra.
            if strcmp(domain_name,'note')
                domain = sort(mtnotes2midi(domain));
                domain = reshape(domain,[],1);
                [instlist,res] = get_orchestra(session_instance);
                domain = repmat(domain,1,res);
                domain = domain+repmat((0:1:res-1)/res,size(domain,1),1);
                domain = sort(reshape(domain,[],1));
                domain = midi2mtnotes(domain);
            end

        end

end