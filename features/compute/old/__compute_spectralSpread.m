function spectralSpread = spectralSpread(search_structure,soundsets)


idx_sc = find(strcmp(search_structure.names,'spectralCentroid'));
idx_ss = find(strcmp(search_structure.names,'spectralSpread'));
idx_ener = find(strcmp(search_structure.names,'melMeanEnergy'));


sc_matrix = search_structure.matrix(:,(search_structure.positions==idx_sc));
ss_matrix = search_structure.matrix(:,(search_structure.positions==idx_ss));
ener_matrix = search_structure.matrix(:,(search_structure.positions==idx_ener));

ss_matrix = ss_matrix(soundsets);
sc_matrix = sc_matrix(soundsets);
ener_matrix = ener_matrix(soundsets);

sc_matrix = reshape(sc_matrix,size(soundsets,1),size(soundsets,2));
ss_matrix = reshape(ss_matrix,size(soundsets,1),size(soundsets,2));
ener_matrix = reshape(ener_matrix,size(soundsets,1),size(soundsets,2));


spectralCentroid = sum(sc_matrix.*ener_matrix,2)./sum(ener_matrix,2);

moment2_matrix = ss_matrix.^2+sc_matrix.^2;

spectralSpread = sqrt(sum(moment2_matrix.*ener_matrix,2)./sum(ener_matrix,2)-spectralCentroid.^2);