function tmp_file = tmp_file_name()

% TMP_FILE_NAME - Ouput a tempoary file name
% (located in the /tmp/ directory)
%
% Usage: tmp_file = tmp_file_name()
% 

tmp_file = [ '/tmp/orchidee_' sprintf('%d',round(10000000*rand)) ];