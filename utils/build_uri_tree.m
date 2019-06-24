function tree = build_uri_tree(uris,tree,offset)

% BUILD_URI_TREE - Build a five-level tree structure from a sample URI array.
% The output tree is organized according to the following hierarchy:
% Instrument / mute / playing style / note / dynamics /
% The output tree allows to efficiently check whether a given input URI
% is a URI list or not. See URI_TREE_FIND.
%
% Usage: tree = build_uri_tree(uris,<tree>,<offset>)
% 
% If 'tree' and 'offset' arguments are provided, concatenate the
% new tree with the existing tree.
%

% Assign default values for optional args
if nargin < 2
    tree = [];
    offset = 0;
end

% Iterate on uris cell array
for i = 1:length(uris)
    
    % Converts the URI into tree nodes
    tree_nodes = uri2tree_nodes(uris{i});
    
    % Add a new instrument if needed
    if ~isfield(tree,tree_nodes.instrument)
        tree.(tree_nodes.instrument) = [];
    end
    
    % Add a new mute if needed
    if ~isfield(tree.(tree_nodes.instrument),tree_nodes.mute)
        tree.(tree_nodes.instrument).(tree_nodes.mute) = [];
    end
    
    % Add a new playing style if needed
    if ~isfield(tree.(tree_nodes.instrument).(tree_nodes.mute),tree_nodes.playingStyle)
        tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle) = [];
    end
    
    % Add a new note if needed
    if ~isfield(tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle),tree_nodes.note)
        tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note) = [];
    end
    
    % Add a new dynamic if needed
    if ~isfield(tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note),tree_nodes.dynamics)
        tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note).(tree_nodes.dynamics) = [];
    end
    
    % Get slot name
    slot = tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note).(tree_nodes.dynamics);
    
    if length(slot)==0
        % If slot is empty, fill with current URI 
        slot.uris = uris(i);
        slot.idx = offset+i;
        tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note).(tree_nodes.dynamics) = slot;
        
    else
        % Raise an exception if current URI already in slot
        if ismember(uris{i},slot.uris)
            error('orchidee:utils:build_uri_tree:UriRedundancy', ...
                [ 'URI ''' uris{i} ''' at least twice in the database.'] );
        end
        % Append current URI to slot
        slot.uris = [ slot.uris uris{i} ];
        % Append current index to slot
        slot.idx = [ slot.idx offset+i ];
        tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note).(tree_nodes.dynamics) = slot;
        
    end
    
end