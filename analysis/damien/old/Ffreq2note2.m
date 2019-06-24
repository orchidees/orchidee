function [note, octave] = Ffreq2note2(f_v)
%function [note, octave, cents, thirdOct] = Ffreq2note2(f)
%
% Converti une frequence en note, la 440 = A4
% avec les 1/4 de tons
%
    
    
chromalist = {'C'; 'C+'; 'C#'; 'C#+'; ... 
	      'D'; 'D+'; 'D#'; 'D#+'; 'E'; 'E+'; 'F'; 'F+'; 'F#'; 'F#+'; ...
	      'G'; 'G+'; 'G#'; 'G#+';'A'; 'A+'; 'A#'; 'A#+'; 'B'; 'B+'};
    

C1 = 55/2^(9/12);

for k=1:length(f_v)
    o = log2(f_v(k)/C1)+1/48;
    n = floor(o);
    chroma=ceil((o-n)*24);
    
    %cents = sprintf('%+.0f',cents);
    
    oct = floor(o)+1;
    note = [char(chromalist(chroma)),num2str(oct)];
    
    qt = strfind(note, '+');
    if ~isempty(qt),
	note = [note(1:qt-1), note(qt+1:end), '+'];
    end
    
    note_c{k} = note;
    octave_v(k) = oct;
end

if length(f_v)==1
    note = note_c{1};
else
    note = note_c;
end