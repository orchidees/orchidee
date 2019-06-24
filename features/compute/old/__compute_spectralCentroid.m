function spectralCentroid = compute_spectralCentroid(search_structure,soundsets)


idx_sc = find(strcmp(search_structure.names,'spectralCentroid'));
idx_ener = find(strcmp(search_structure.names,'melMeanEnergy'));


sc_matrix = search_structure.matrix(:,(search_structure.positions==idx_sc));
ener_matrix = search_structure.matrix(:,(search_structure.positions==idx_ener));

sc_matrix = sc_matrix(soundsets);
ener_matrix = ener_matrix(soundsets);

sc_matrix = reshape(sc_matrix,size(soundsets,1),size(soundsets,2));
ener_matrix = reshape(ener_matrix,size(soundsets,1),size(soundsets,2));

spectralCentroid = sum(sc_matrix.*ener_matrix,2)./sum(ener_matrix,2);