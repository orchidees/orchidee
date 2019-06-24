function flat_structure = flatten_structure(tree_structure)

% FLATTEN_STRUCTURE - Flatten a tree structure
% (Redundency is subtrees is ignored)
%
% Usage: flat_structure = flatten_structure(tree_structure)
%

flat_structure = {};

if isstruct(tree_structure)

    % Iterate on nodes
    f = fieldnames(tree_structure);
    for k = 1:length(f)
        
        if isstruct(tree_structure.(f{k}))
            
            % Recursive call of flatten_structure if current node
            % is a tree
            flat_structure = merge_structures(flat_structure,flatten_structure(tree_structure.(f{k})));
            
        else
            
            flat_structure.(f{k}) = tree_structure.(f{k});
            
        end
        
    end

else
    
    flat_structure = tree_structure;

end