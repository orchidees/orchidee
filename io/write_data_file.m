function write_data_file(filename,data,handles)

% WRITE_DATA_FILE - Write data in a text file. Data may be either a
% double precision matrix or a 1D cell array of strings. On each
% line of the file is written a line of the matrix or an item of
% the cell array.
%
% Usage: write_data_file(filename,data,<handles>)
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

% Output must be a file
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
if isnumeric(data)
    [n,p] = size(data);
    for i = 1:n
        check_interruption();
        if ~mod(i,100), server_says(handles,'Querying ...',i/n); end;
        for j = 1:p
            fprintf(fid,'%10.8f ',data(i,j));
        end
        fprintf(fid,'\n');
    end
    server_says(handles,'Querying ...',1);
else    
    n = length(data);
    for i = 1:length(data) 
        check_interruption();
        if ~mod(i,100), server_says(handles,'Querying ...',i/n); end;
        fprintf(fid,'%s\n',data{i});
    end
    server_says(handles,'Querying ...',1);
end

% Close file
fclose(fid);