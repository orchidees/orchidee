function [f0FileName_asc] = FgetF0FileName(database_s, index)
%function [partFileName_asc] = FgetPartFileName(database_s, index)
% 
% Retourne le nom du fichier .part.sdif a la position index dans la structure database_s
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


    
pos_v = strfind(database_s.data_s(index).file, '.wav');
if isempty(pos_v),
    pos_v = strfind(database_s.data_s(index).file, '.aif');
    if isempty(pos_v)
	tmpname = database_s.data_s(index).file;
    else
	tmpname = database_s.data_s(index).file(1:pos_v(end)-1);
    end
else
    tmpname = database_s.data_s(index).file(1:pos_v(end)-1);
end

f0FileName_asc = [database_s.analyse '/additive/ADD' tmpname '/' tmpname '.f0.sdif'];
