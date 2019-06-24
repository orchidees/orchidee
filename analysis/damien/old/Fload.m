% function [output] = Fload(FILENAME, quiet)
%
% load le fichier FILENAME.mat et met le resutat dans output
%

function [output] = Fload(FILENAME, quiet)


if nargin < 2
    quiet = 0;
end

s = load(FILENAME);
chaine 	= fieldnames(s);
if length(chaine) == 1
   output = getfield(s, chaine{1});
   a = dir(FILENAME);
   
   if ~quiet
       fprintf(1, 'Fload\t\tread %s from %s\n', chaine{1}, FILENAME);
       fprintf(1, '\tdate: %s\n', a.date);
       fprintf(1, '\tsize: %d\n', size(output)); 
   end
else
   error(['there is more than one variable in ' FILENAME])
end