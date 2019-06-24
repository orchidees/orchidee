function delta = update_delta(target_instance,session_instance)

% UPDATE_DELTA - Compute the value of the delta parameter on the
% basis of the target partials and the microtonic resolution of the orchestra
%
% Usage: delta = update_delta(target_instance,session_instance)
%

% Method is relevant iif there is a 'partialsMeanFrequency'
% descriptor in target features anf autodelta = true
if isfield(target_instance.features,'partialsMeanFrequency') && target_instance.parameters.autodelta
    
    % Get current microtonic resolution
    [instlist,resolution] = get_orchestra(session_instance);
    
    % Quantify target partials to the closest pitch (eventually
    % microtonic)
    freqs = reshape(target_instance.features.partialsMeanFrequency,[],1);
    midi = hz2midi(freqs);
    midi_quantized = round(midi*resolution)/resolution;
    freqs_quantized = midi2hz(midi_quantized);
    
    % Compute minimum delta for which each quantified pitch maps at
    % least their original partial frequency
    ratios = sort([freqs freqs_quantized],2);
    ratios = ratios(:,2)./ratios(:,1);
    delta = max(ratios-1)*1.01;
    
else
    
    delta = target_instance.parameters.delta;
    
end