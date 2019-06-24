function notes_mid = note2midi(notes_str)

% NOTE2MIDI - Convert a cell array f strings into a MIDI note
% vector.
%
% Usage: notes_mid = note2midi(notes_str)
%

% Allocate output vector
notes_mid = zeros(length(notes_str),1);

% Get possible notes as a cell array of stings
all_notes_str = midi2note();

% The conversion is here
[T,notes_mid] = ismember(notes_str,all_notes_str);
notes_mid = notes_mid-1;