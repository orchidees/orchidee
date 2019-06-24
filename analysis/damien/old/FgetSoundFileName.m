function [soundFileName_asc] = FgetSoundFileName(database_s, index)
%function [soundFileName_asc] = FgetSoundFileName(database_s, index)
% 
% Retourne le nom du fichier son a la position index dans la structure database_s
%
%
% ===INPUTS
%
%
%
% ===OUTPUTS
%
%
%

if isfield(database_s.data_s, 'dir'),
    soundFileName_asc = [database_s.racine database_s.data_s(index).dir database_s.data_s(index).file];
else
    soundFileName_asc = [database_s.racine database_s.data_s(index).file];
end
%     filename = [database_s.analyse 'ADD' database_s.data_s(k).file(1:end-4) '/' ...
% 		database_s.data_s(k).file(1:end-4) '.part.sdif'];
