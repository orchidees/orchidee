function [f0_v] = Fnote2freq2(note_m)

if iscell(note_m)
    note_m = char(note_m);
end
chromalist = {'C'; 'C+'; 'C#'; 'C#+'; ... 
	      'D'; 'D+'; 'D#'; 'D#+'; 'E'; 'E+'; 'F'; 'F+'; 'F#'; 'F#+'; ...
	      'G'; 'G+'; 'G#'; 'G#+';'A'; 'A+'; 'A#'; 'A#+'; 'B'; 'B+'};
    
f0_v = [];
C1 = 55/2^(9/12);

for k = 1:size(note_m,1)
    isNegOctave = ~isempty(regexp(note_m(k,:), '-'));
    octavePos = regexp(note_m(k,:), '\d');
    octave = (note_m(k,octavePos)-48)*(-1)^isNegOctave -1;
    note = regexp(note_m(k,:), '\w\#?', 'match');
    note = note{1};
    if findstr(note_m(k,:),'+'),
	note = [note '+'];
    end
    p=find(strcmp(chromalist, note))-1;
    
    f0 = 2^(octave) * C1 * 2^(p/24);
    f0_v = [f0_v; f0];
end
