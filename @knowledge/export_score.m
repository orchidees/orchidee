function [] = export_score(knowledge_instance, outfile, targetname, staffsize, solution, handles)

% EXPORT_SCORE - Build a PDF score from a given input solution. This
% function require LilyPond (http://lilypond.org/) to be installed in
% your /Applications/ dir.
%
% Usage: [] = export_score(knowledge_instance, outfile, targetname,
% staffsize, solution, handles)
%

% Check if in server mode
if nargin < 6
    handles = [];
end

% Get LilyPond executable's complete path
lilycommand = find_lily_command();

% Get instrument list
if ~isempty(handles) && ~isempty(handles.session)
    instlist = get_orchestra(handles.session);
else
    instlist = [];
end

% Get current solution
n_inst = length(solution)/2;
items_idx = ((1:1:n_inst)*2)-1;
transpo_idx = items_idx+1;
items = solution(items_idx);
transpo = solution(transpo_idx);

% Remove useless empty items at the end
for i = 1:length(items)
    if items{i}
        lastitem = i;
    end
end
if ~isempty(instlist)
    lastitem = max(lastitem, length(instlist));
end

% Format PDF out file and tmp Lily file
l = length(outfile);
if strcmp(outfile(l-3:l), '.pdf')
    outfile = outfile(1:l-4);
end
lilyfile = [ outfile '.ly' ];

% Open Lily file
fid = fopen(lilyfile, 'w');

% Write header
fprintf(fid, '\\version "2.12.3"\n');
fprintf(fid, '#(set-global-staff-size %d)\n', staffsize);
fprintf(fid, '\\header {\n');
fprintf(fid, '  title = " %s "\n', targetname);
fprintf(fid, '  composer = "Score in C" }\n\n');

% Iterate on solution's items
for k = 1:lastitem

    % Assign new voici for item k
    fprintf(fid, 'inst%s = \\new Voice {\n', numbers2letters(k));

    % Get current item's index in DB
    item = items{k};
    
    % If index is null
    if ~item
        
        % Print instrument name
        if k <= length(instlist)
            this_inst = instlist{k};
            if iscell(this_inst), this_inst = this_inst{1}; end
        else
            this_inst = [ 'Inst_' num2str(k) ];
        end
        fprintf(fid, '\\set Staff.instrumentName = #"%s"\n', this_inst);
            
        % Print a rest
        fprintf(fid, 'r1\n');        
    
    % Otherwise...
    else
        
        % Print instrument name
        inst = get_field_values(knowledge_instance, 'instrument', item); inst = inst{1};
        fprintf(fid, '\\set Staff.instrumentName = #"%s"\n', inst);
        
        % Get current item's symbolic attributes
        note = get_field_values(knowledge_instance, 'note', item); note = lilynote(note{1}, transpo{k});
        dyn = get_field_values(knowledge_instance, 'dynamics', item); dyn = dyn{1};
        ps = get_field_values(knowledge_instance, 'playingStyle', item); ps = ps{1};
        smute = get_field_values(knowledge_instance, 'stringMute', item); smute = smute{1};
        bmute = get_field_values(knowledge_instance, 'brassMute', item); bmute = bmute{1};
        oct = get_field_values(knowledge_instance, 'octave', item);
        str = get_field_values(knowledge_instance, 'string', item);
        
        % Swith to bass clef if pitch is below middle C
        if oct < 4
            fprintf(fid, '\\clef bass\n');
        end
        
        % Print note
        fprintf(fid, '%s1', note);
        
        % Print staccato notation if needed
        if strcmp(ps, 'stacc'), fprintf(fid, '\\staccato'); end
        
        % Print tremolo notation if needed
        if strcmp(ps, 'trem'), fprintf(fid, ':32'); ps = ''; end
        if strfind(ps, '-trem'), fprintf(fid, ':32'); ps = strrep(ps, '-trem', ''); end
        
        % Compute above-note information
        upmarkup = '^\markup{';
        % Print mute if needed
        if ~strcmp(smute, 'NA') && ~strcmp(smute, 'N')
            upmarkup = [ upmarkup smute '\hspace #0.5 ' ];
        elseif ~strcmp(bmute, 'NA') && ~strcmp(bmute, 'N')
            upmarkup = [ upmarkup bmute '\hspace #0.5 ' ];
        end
        % Print playing style if needed
        if strcmp(ps, 'ord') || strcmp(ps, 'stacc'), ps = ''; end
        upmarkup = [ upmarkup '\italic\small{' ps ];
        % Print string number if needed    
        if str
            upmarkup = [ upmarkup ' (' num2str(str) 'c) }}' ];
        else
            upmarkup = [ upmarkup ' }}' ];
        end
        fprintf(fid, '%s', upmarkup);  
        
        % Compute below-note information
        downmarkup = '_\markup{';
        % print dynamics
        downmarkup = [ downmarkup '\dynamic ' dyn ];
        % Print microtonic transposition if needed
        if ismember(transpo{k}, {'+1.16' '+1.8' '+3.16' '+3.8' '+5.16' '+3.8' '+5.16' })
            transpo{k} = strrep(transpo{k}, '.', '/');
            downmarkup = [ downmarkup ' \hspace #0.5 \small{(' transpo{k} ')}}' ];
        else
            downmarkup = [ downmarkup ' }' ];
        end
        fprintf(fid, '%s\n', downmarkup);
        
    end
    
    fprintf(fid, '}\n\n');

end

% Print score
fprintf(fid, '\\score {\n');
fprintf(fid, '\\new StaffGroup <<\n');
fprintf(fid, '\\set Score.proportionalNotationDuration = #(ly:make-moment 1 8)\n');

% Add staves
for k = 1:lastitem
    fprintf(fid, '\\new Staff << \\inst%s >>\n', numbers2letters(k));
end

fprintf(fid, '>>\n');
fprintf(fid, '\\layout { }\n');
fprintf(fid, '}\n');

% Close Lily file
fclose(fid);

if strfind(outfile, ' ')
    outfile =  [ '"' outfile '"' ];
end
if strfind(lilyfile, ' ')
    lilyfile =  [ '"' lilyfile '"' ];
end

% Convert to score
cmd = [ lilycommand ' -fpdf -o ' outfile ' ' lilyfile ];
unix(cmd);

% Remove PS file, open PDF
cmd = [ 'rm ' outfile '.ps; open ' outfile '.pdf' ];
unix(cmd);

% Remove Lily file
cmd = [ 'rm ' lilyfile ];
unix(cmd);




function L = numbers2letters(N)

% NUMBERTOLETTERS - Convert any number to a sequence of letters.
% (LilyPond cannot handles numbers in voice definitions)

L = num2str(N);
L = strrep(L, '1', 'a');
L = strrep(L, '2', 'b');
L = strrep(L, '3', 'c');
L = strrep(L, '4', 'd');
L = strrep(L, '5', 'e');
L = strrep(L, '6', 'f');
L = strrep(L, '7', 'g');
L = strrep(L, '8', 'i');
L = strrep(L, '9', 'j');
L = strrep(L, '0', 'k');




function o = lilynote(i, transpo)

% LILYNOTE - Output a LilyPond-complient pitch from an Orchidee pitch and a
% given microtonic transposition.

% Process natural pitch
o = lower(i);
o = strrep(o, '7', '''''''');
o = strrep(o, '6', '''''');
o = strrep(o, '5', '''''');
o = strrep(o, '4', '''');
o = strrep(o, '3', '');
o = strrep(o, '2', ',');
o = strrep(o, '1', ',,');
o = strrep(o, '0', ',,,');

% Process sharps, semitones and quartertones
if strfind(o, '#')
    if strcmp(transpo, '+1.4')
        o = strrep(o, '#', 'isih');
    else
        o = strrep(o, '#', 'is');
    end
else
    if strcmp(transpo, '+1.4')
        o = [ o(1) 'ih' o(2:length(o)) ];
    end
end