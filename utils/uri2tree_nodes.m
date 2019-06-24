function tree_nodes = uri2tree_nodes(uri)

% URI2TREE_NODES - Converts a soudfile URI into
% a URI tree node structure.
%
% Usage: tree_nodes = uri2tree_nodes(uri)
%

try
    
    p = FextractParamFromName(uri,'sol2.0');
    p.note = strrep(p.note,'#','s');
    p.modeDeJeu = strrep(p.modeDeJeu,'-','_');
    p.modeDeJeu = strrep(p.modeDeJeu,'+','_');

catch

    error('orchidee:utils:uri2tree_nodes:UnconsistentUri', ...
            [ 'Cannot get attributes from URI ''' uri '''.' ]);

end

tree_nodes.instrument = p.instrument;
tree_nodes.mute = p.sourdine;
tree_nodes.playingStyle = p.modeDeJeu;
tree_nodes.note = p.note;
tree_nodes.dynamics = p.dynamique;