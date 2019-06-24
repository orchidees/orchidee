function [partFileName_asc] = FgetMelNoiseFileName(database_s, index)
%function [partFileName_asc] = FgetPartFileName(database_s, index)
% 
% Retourne le nom du fichier .mel.mat a la position index dans la structure database_s
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

partFileName_asc = [database_s.analyse '/melnoise/' tmpname '.meln.mat'];
