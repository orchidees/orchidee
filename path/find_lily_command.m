function lilycommand = find_lily_command()

% FIND_LILY_COMMAND - Returns the complete path of the lipyond executable.
% Lilypond must be previously installed. The searched path is:
% /Applications/LilyPond[*].app/Contents/Resources/bin/lilypond
%
% Usage: lilycommand = find_lily_command()
%

% Locate LilyPond's folder
cmd = 'find /Applications -name "LilyPond*" -maxdepth 1';
[r, s] = unix(cmd);

% Raise exception if LilyPond is not installed
if isempty(s)
    error('orchidee:path:find_lily_command:MissingComponent', ...
        'Cannot find LilyPond in Applications folder.');
end

% Convert path to string, remove carriage return at end
if iscell(s), s = s{1}; end
s = s(1:length(s)-1);

% Build complete path to executable
lilycommand = [ s '/Contents/Resources/bin/lilypond' ];

% Check that executable exists
if ~exist(lilycommand)
    error('orchidee:path:find_lily_command:MissingComponent', ...
        [ 'Cannot find lilypond executable. Expecting: ' lilycommand '.' ]);
end