function note_list = get_possible_notes(knowledge_instance,resolution)

% GET_POSSIBLE_NOTES - Return the set of pitches (without redundancy)
% contained in a knowledge instance. If provided, the microtonic resolution
% of the orchestra is considered. That is, get_possible_notes(K,N)
% returns N more notes than get_possible_notes(K).
%
% Usage: note_list = get_possible_notes(knowledge_instance,<resolution>)
%

if nargin < 2
    resolution = 1;
end

note_list = get_field_value_list(knowledge_instance,'note');
midinotes = reshape(note2midi(note_list),[],1);
allnotes = [];
for r = 0:resolution-1
    allnotes = [ allnotes ; midinotes+r/resolution ];
end
note_list = midi2mtnotes(sort(allnotes));