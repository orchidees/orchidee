function check_interruption(mode)

if nargin < 1
    mode = 'all';
end

switch mode

    case 'quit'
        
        orchideequit();

    case 'interrupt'
        
        orchideeinterrupt();

    case 'all'
        
        orchideequit();
        orchideeinterrupt();

    otherwise

        error('orchidee:errors:check_interruption:UnknownInterruption', ...
            [ '''' mode ''': Unknow interruption.'] );

end




function orchideequit()

if exist('/tmp/orchideequit','file')
    !rm /tmp/orchideequit
    error('orchidee:errors:ForcedToQuit', 'Orchidee has been externally forced to quit.');
end




function orchideeinterrupt()

if exist('/tmp/orchideeinterrupt','file')
    !rm /tmp/orchideeinterrupt
    error('orchidee:errors:InterruptedAction', 'Orchidee has been externally interrupted.');
end