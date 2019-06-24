function [database_s] = FscanFiles(ROOTDIR, filetype, DATABASEROOT)
%function [database_s] = FscanFiles(ROOTDIR, filetype, DATABASEROOT)
%
% Scanne le fichier ROOTDIR a la recherche de fichier sons et stocke le résultat dans une structure de
% la forme suivante :
% database_s.racine = ROOTDIR
% 
% Pour le n-ième fichier :   
% database_s.data_s(n).file = nom du fichier
% database_s.data_s(n).dir  = chemin depuis la racine jusqu'au fichier
%    
%    
% ===INPUTS
%
% ROOTDIR : Racine de l'ensemble de fichier
%
% ===OUTPUTS
% 
% database_s : structure de donnée contenant les résultats
%


if nargin < 3,
    DATABASEROOT = ROOTDIR;
end

if nargin < 2
    filetype = 0;
end

database_s.racine = DATABASEROOT;


database_s.data_s = [];
database_s = FLRscanFiles(database_s, ROOTDIR, filetype);

function [database_s] = FLRscanFiles(database_s, currentdir, filetype)
files_s = dir(currentdir);

%% Cette ligne pour retirer les fichier cacher de file_s (dir les met)
pos_v = find(~cellfun('isempty', regexp(cellstr(strvcat(files_s.name)),  '^\w')));

files_s = files_s(pos_v);
clear pos_v

if length(files_s) > 0
    for k = 1:length(files_s)
	if files_s(k).isdir
	    database_s = FLRscanFiles(database_s, [currentdir files_s(k).name '/'], filetype);
	else
	    if filetype == 0
		database_s.data_s(end + 1).file = files_s(k).name;
		database_s.data_s(end).dir = currentdir(length(database_s.racine):end);
	    else
		[a,b,ext] = Ffiletodirroot(files_s(k).name);
		if strcmp(ext(2:end), filetype),
		    database_s.data_s(end + 1).file = files_s(k).name;
		    database_s.data_s(end).dir = currentdir(length(database_s.racine):end);
		end
	    end
	end
    end
end
