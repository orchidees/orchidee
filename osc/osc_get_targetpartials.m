function handles = osc_get_targetpartials(osc_message,handles)

% OSC_GET_TARGET_PARTIALS - Return target's main resolved partials as a
% list of frequencies and linear amplitudes.
%
% Usage: osc_get_targetpartials(osc_message,handles)
%

% Check that a target is defined
if isempty(handles.session)
    error('orchidee:osc:osc_get_targetpartials:MissingData', ...
        'No target defined.');
end

% Extract target descriptors if needed
[domain, handles.session] = get_attribute_domain(handles.session, handles.instrument_knowledge, 'note', handles);

% Get target features
target_features = get_target_features(handles.session);

% Get target partials
freqs = target_features.partialsMeanFrequency;
amps = target_features.partialsMeanAmplitude;

% Get orchestra's microtonic resolution
[instList, resolution] = get_orchestra(handles.session);

% Quantify target partials according to current resolution
midifreqs = hz2midi(freqs);
midifreqs = round(midifreqs*resolution)/resolution;
quantifiedfreqs = midi2hz(midifreqs);

% Build OSC messgae
message.path = '/targetpartials';
message.tt = 'i';
message.data{1} = osc_message.data{1};

% Add quantified freqs to message
for k = 1:length(quantifiedfreqs)
    message.tt = [ message.tt 'i' ];
    message.data{2*k} = quantifiedfreqs(k);
    message.tt = [ message.tt 'f' ];
    message.data{2*k+1} = amps(k);
end

% Add message to OSC buffer
flux{1} = message;

% Send message
osc_send(handles.osc.address,flux);