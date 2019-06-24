function midinotes = mtnotes2midi(mtnotes)

% MTNOTES2MIDI - Convert a cell array of microtonic notes (up to
% 1/16 tone) into a MIDI note vector.
%
% Usage: midinotes = mtnotes2midi(mtnotes)
%

% Get the list of microtonic pitches
all_mt_notes = midi2mtnotes();

% And the conversion is here
[T,I] = ismember(mtnotes,all_mt_notes);

% Scale to microtones
midinotes = (I-1)/8;