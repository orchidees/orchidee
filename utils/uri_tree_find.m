function idx = uri_tree_find(tree,uri)

% URI_TREE_FIND - Efficient ISMEMBER for soundfile URI array
% (previously represented as a uri tree structure).
%
% Usage: idx = uri_tree_find(tree,uri)
%

% Check args
if ~ischar(uri)
    error('orchidee:knowledge:ismember:BadArgumentType', ...
        'uri needs to be a char.');
end

% Default output if zero
idx = 0;

% Convert URI into tree structure
tree_nodes = uri2tree_nodes(uri);

% Check instrument
if isfield(tree,tree_nodes.instrument)
    % Check mute
    if isfield(tree.(tree_nodes.instrument),tree_nodes.mute)
        % Check playing style
        if isfield(tree.(tree_nodes.instrument).(tree_nodes.mute),tree_nodes.playingStyle)
             % Check note
            if isfield(tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle),tree_nodes.note)
                % Check dynamics
                if isfield(tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note),tree_nodes.dynamics)
                    % Check URI
                    slot = tree.(tree_nodes.instrument).(tree_nodes.mute).(tree_nodes.playingStyle).(tree_nodes.note).(tree_nodes.dynamics);
                    [T,I] = ismember(uri,slot.uris);
                    if T, idx = slot.idx(I); end       
                end
            end
        end
    end
end