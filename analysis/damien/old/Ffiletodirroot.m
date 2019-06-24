% function [FILEROOT, PATH, SUFFIX] = Ffiletodirroot(FILENAME)
%
% DESCRIPTION:
% ============
% convertit un nom de fichier complet (path + fileroot + suffix)
% en fileroot, path et suffix
%
% (Gfp 2001)
%

function [FILEROOT, PATH, SUFFIX] = Ffiletodirroot(FILENAME)


FILENAME = strrep(FILENAME ,'/', filesep);

pos_v    = findstr(FILENAME, filesep);
if length(pos_v)
   PATH  = FILENAME(1:pos_v(end));
   a     = pos_v(end);
else 
   PATH 	= [];
   a    	= 0;
end

poss_v   = findstr(FILENAME, '.');
if length(poss_v)
   FILEROOT = FILENAME(a+1:poss_v(end)-1);
   SUFFIX   = FILENAME(poss_v(end):end);
else
   FILEROOT = FILENAME(a+1:end);
   SUFFIX = [];
end


