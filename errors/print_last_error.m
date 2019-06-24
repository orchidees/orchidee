function print_last_error(log_file, title)

fid = fopen(log_file, 'w');

fprintf(fid, '%s\n\n', title);
fprintf(fid, 'Log File: %s\n\n', log_file);

err = lasterror;

fprintf(fid, 'Message: %s\n\n', err.message);
fprintf(fid, 'ErrorID: %s\n\n', err.identifier);

for k = 1:length(err.stack)
    fprintf(fid, 'Function Call Depth: %d\n', length(err.stack)-k);
    fprintf(fid, 'File: %s\n', err.stack(k).file);
    fprintf(fid, 'Line: %d\n\n', err.stack(k).line);
end

fclose(fid);