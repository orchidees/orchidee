function write_index_file(filename,idx,handles)

% WRITE_INDEX_FILE - Write an index vector in a text file (one
% integer per line).
%
% Usage: index_file(filename,idx,<handles>)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Check ouput type
if ~ischar(filename)
    error('orchidee:io:write_data_file:BadArgumentType', ...
        [ 'Output file name must be a string.' ]);
end

% Ouput must be a file
if strcmp(filename,'message')
    error('orchidee:io:write_data_file:BadArgumentValue', ...
        [ 'Message ouput is not supported.' ]);
end

% Open file
fid = fopen(filename,'w');
if fid == -1
    error('orchidee:io:write_data_file:CannotOpenFile', ...
        [ 'Cannot open ' filename '.' ]);
end

% Write data
n = length(idx);
for i = 1:length(idx)
    check_interruption();
    if ~mod(i,100), server_says(handles,'Querying ...',i/n); end;
    fprintf(fid,'%d\n',idx(i));
end
server_says(handles,'Querying ...',1);

% Close file
fclose(fid);