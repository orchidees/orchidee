function oscserver(handles)

% OSCSERVER - Launch the Orchidee OSC server.
%
% Usage: [] = oscserver(handles);
%

% Read OSC settings in preferences file
osc_settings = read_osc_settings();

try
    % Set the OSC address (for sending messages)
    osc_address = osc_new_address(osc_settings.ip,osc_settings.sendport);
    % Lauch the OSC server (for receiving messages)
    osc_server = osc_new_server(osc_settings.receiveport);
catch
    % Output and open log file if OSC connection fail
    log_file = log_file_name;
    print_last_error(log_file,'ORCHIDEE CRASH REPORT');
    unix(['open ' log_file]);
    beep;
    return;
end

% Include OSC info in handles struct
handles.osc.settings = osc_settings;
handles.osc.address = osc_address;
handles.osc.server = osc_server;

% Load instrument knowledge database
try
    send_busy_message(handles,0,'Loading instrument knowledge ...');
    % If a user-defined default knowledge exists ...
    if exist('~/Library/Preferences/IRCAM/Orchidee/user_knowledge.mat')
        % ... load it!
        user_knowledge = load('~/Library/Preferences/IRCAM/Orchidee/user_knowledge.mat');
        handles.instrument_knowledge = user_knowledge.instrument_knowledge;
        clear user_knowledge;
    else
        % Else, load default knowledge.
        default_knowledge = load('default_knowledge.mat');
        handles.instrument_knowledge = default_knowledge.instrument_knowledge;
        clear default_knowledge;
    end
    handles.session = [];
    send_busy_message(handles,1,'Loading instrument knowledge ...');
    % Export DB map if necessary
    if ~exist('~/Library/Preferences/IRCAM/Orchidee/dbmap')
        export_map(handles.instrument_knowledge,'~/Library/Preferences/IRCAM/Orchidee/dbmap',handles);
    end
    send_ready_message(handles);
catch
    % Output and open log file if OSC connection fail
    log_file = log_file_name;
    print_last_error(log_file,'ORCHIDEE CRASH REPORT');
    unix(['open ' log_file]);
    beep;
    return;
end

% OSC listen loop
while 1
    % Normal execution bracnh
    try
        % Non-OSC interruption check
        check_interruption('quit');
        % Get first OSC messgae
        M = osc_recv(osc_server,1);
        % Process message if non empty
        if ~isempty(M)
            % Always process first packet of the bundle
            message = M{1};
            % Fix the appropriate action
            switch message.path
                % Quit server message
                case '/quit'
                    send_quit_message(handles);
                    break;
                    % Handshake message
                case '/isready'
                    send_ready_message(handles);
                    % Version query message
                case '/version'
                    send_version_message(handles);
                    % Debug mode message (non-compiled Matlab only)
                case '/debug'
                    keyboard;
                    % Otherwise, parse more complex instruction
                otherwise
                    handles = parse_osc_message(message,handles);
            end
        end
    % Exception branch
    catch
        last_error = lasterror;
        % Non-OSC QUIT message check
        if strfind(last_error.identifier, 'ForcedToQuit')
            % Send error and quit message
            send_error_message(handles);
            send_quit_message(handles);
            % Print log file
            log_file = log_file_name;
            print_last_error(log_file,'Orchidee Error Report');
            % Quit
            break;
        else
            % Catch last error and send an OSC '/error' message
            send_error_message(handles);
            send_ready_message(handles);
            % Print log file
            log_file = log_file_name;
            print_last_error(log_file,'Orchidee Error Report');
        end
    end
end

% Free OSC address and server
osc_free_server(osc_server);
osc_free_address(osc_address);