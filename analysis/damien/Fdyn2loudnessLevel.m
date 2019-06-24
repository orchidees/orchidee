function [ldl_v] = Fdyn2loudnessLevel(dyn_c)
    
%dynref_c = {'fff'; 'ff'; 'f'; 'mf'; 'mp';'p'; 'pp'; 'fp'};
%ldlref_v = [33,28,23,18,15,8,3,15];

dynref_c = {'fff'; 'ff'; 'f'; 'mf'; 'mp';'p'; 'pp'; 'fp'; 'ppff'; 'ffpp'; 'ppmfpp'};
ldlref_v = [33,28,23,18,15,8,3,15,18,16,8];

if ~iscell(dyn_c)
    dyn_c = {dyn_c};
end
ldl_v = zeros(size(dyn_c));
for k = 1:length(dyn_c)
    ldl_v(k) = ldlref_v(find(strcmp(dyn_c{k},dynref_c)));
end