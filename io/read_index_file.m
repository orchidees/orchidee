function idx = read_index_file(filename)

% READ_INDEX_FILE - Open a text file and read a vector of index.
% Once index (integer typed) is expected on each line. The output
% is a double precision vector.
%
% Usage: idx = read_index_file(filename)
% 

% Check filename type
if ~ischar(filename)
    error('orchidee:io:read_index_file:BadArgumentType', ...
        [ 'Input file name must be a string.' ]);
end

% Open file
fid = fopen(filename);
if fid == -1
    error('orchidee:io:read_index_file:CannotOpenFile', ...
        [ 'Cannot open ' filename '.' ]);
end

% Read data
idx = textscan(fid,'%f');
idx = idx{1};

% Close file
fclose(fid);