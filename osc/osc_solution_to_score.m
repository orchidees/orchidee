function handles = osc_solution_to_score(osc_message, handles)

% OSC_SOLUTION_TO_SCORE - Convert an orchestration solution into a PDF
% score. LilyPond must be previoulsy installed in the /Applications/
% folder.
%
% Usage: handles = osc_solution_to_score(osc_message, handles)
%

% Check number of input arguments
if length(osc_message.data) < 4
    error('orchidee:osc:osc_solution_to_score:IncompleteOscMessage', ...
        'Too few arguemnts.')
end

% Check target name
targetname = osc_message.data{2};
if ~ischar(targetname)
    error('orchidee:osc:osc_solution_to_text:BadArgumentType', ...
        'Target name must be a string.')
end

% Check output file
outfile = osc_message.data{3};
if ~ischar(outfile)
    error('orchidee:osc:osc_solution_to_text:BadArgumentType', ...
        'Output file name must be a string.')
end

% Check staff size
staffsize = osc_message.data{4};
if ~ischar(staffsize)
    error('orchidee:osc:osc_solution_to_text:BadArgumentType', ...
        'Staff size must be a string.');
end
if staffsize(1) ~= 's'
    error('orchidee:osc:osc_solution_to_text:BadArgumentValue', ...
        'Incorrect staff size. Expecting format: s[dd].');
end
staffsize = str2double(staffsize(2:length(staffsize)));
if staffsize > 30
    error('orchidee:osc:osc_solution_to_text:BadArgumentValue', ...
        'Staff size cannot be greater than 30.');
end
if staffsize < 10
    error('orchidee:osc:osc_solution_to_text:BadArgumentValue', ...
        'Staff size cannot be lower than 10.');
end

% Get current solution's data
this_solution = osc_message.data(5:length(osc_message.data));

% Convert to Lilypond score
export_score(handles.instrument_knowledge, outfile, targetname, staffsize, this_solution, handles);