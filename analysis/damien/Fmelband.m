% function [amplbank_s, FILTRE_s] = Fmelband(ampl_s, N, sr_hz, FILTRE_s, nb_filtre)
%
% DESCRIPTION:
% ============
% calcul des filtres MEL
% filtrage du spectre d'amplitude par les fitlres MEL
%
% INPUTS:
% =======
% - ampl_s.value, .unit (N, nb_frame) [lin]: spectre d'amplitude
% - N                                      : taille de la FFT
% - sr_hz              [Hz]                : fr?quence d'?chantillonnage
% - FILTRE_s	.value 	(N/2+1, nb_filtre) : filtre de MEL
%		.unit   [lin]
%		.axe
%		.center
% - nb_filtre                              : nombre de filtre (bank)
%
% OUTPUTS:
% ========
% - amplbank_s.value, .unit  (nb_filtre, nb_frame) [lin]: spectre d'amplitude en MEL
% - FILTRE_s	.value (N/2+1, nb_filtre)    [lin]: filtre MEL
%		.unit  [lin]
%		.axe
%		.center
%
% (Gfp 23/10/2001)
% LAST EDIT GFP 2005/05/09
%

function [amplbank_s, FILTRE_s] = Fmelband(ampl_s, N, sr_hz, FILTRE_s, nb_filtre)

do.affiche      = 0;
do.normalisation= 0;

% =====================
if  ~nargin
    N           = 4*1024;
    ampl_s.unit = 'lin';
    ampl_s.value= ones(N,1);
    sr_hz       = 11025;
    Fmelband(ampl_s, N, sr_hz, [], 40);
    return
end
% =====================

if nargin < 5, nb_filtre = 40;, end



% ====================
if nargin < 4 | length(FILTRE_s) == 0

    % === filtre triangulaire
    %FILTRE_s.value	= melbankm(nb_filtre, N, sr_hz);
    % === filtre hanning
    FILTRE_s.value	= melbankm(nb_filtre, N, sr_hz, 0, 0.5, 't');
    FILTRE_s.value	= FILTRE_s.value.';

    FILTRE_s.axe	= ([1:N/2+1]'-1)/N*sr_hz;
    [x,pos]         = max(FILTRE_s.value);
    FILTRE_s.center	= FILTRE_s.axe(pos);
    FILTRE_s.unit  	= 'lin';

    % === NEW for spectral contrast
    nb_filtre = size(FILTRE_s.value,2);
    for num_filtre=1:nb_filtre
        pos_v = find(FILTRE_s.value(:,num_filtre));
        FILTRE_s.range(:,num_filtre)=[pos_v(1) pos_v(end)];
    end

    % === FILTRE_s.value (N/2+1, nb_filtre)

    % =========================[ampbank_s, filtre_s] = Fmelband(amp_s, fftsize_k, sr_hz, [], nbChannel);
    % === normalisation
    if do.normalisation,
        %fprintf(1, 'warning (%s): normalizing MEL bands\n', mfilename);
        FILTRE_s.value = FILTRE_s.value ./ repmat(sum(FILTRE_s.value, 1), size(FILTRE_s.value,1), 1);
    end


    % ++++++++++++++++++++++++++++
    if ~nargout
        subplot(111)
        axe_f_v = FLmatlabversf([1:N], sr_hz, N)';
        plot(axe_f_v(1:N/2+1), FILTRE_s.value), grid on
        xlabel('Frequency [Hz]');
        title(['Number of mel bands: ' num2str(nb_filtre)])
        fprintf(1, 'in pause (%s)\n', mfilename);, pause
    end
    % ++++++++++++++++++++++++++++
end
% ====================




if ~strcmp(ampl_s.unit, FILTRE_s.unit), error('wrong unit'), end

% === cas: une seule frame
if (size(ampl_s.value, 1) == 1) | (size(ampl_s.value, 2) == 1)
    % === ampl_s.value(N, 1)
    ampl_s.value     = ampl_s.value(:);
end


% === ampl_s.value 	(N/2, nb_frame)
% === FILTRE_s		(N, nb_filtre)
nb_frame  = size(ampl_s.value, 2);
nb_filtre = size(FILTRE_s.value, 2);

amplbank_s.value = zeros(nb_filtre, nb_frame);
for num_frame = 1:nb_frame
    % === (nb_filtre, N/2+1) * (N/2+1, 1)
    amplbank_s.value(:, num_frame) = FILTRE_s.value.' * ampl_s.value(1:N/2+1, num_frame);

    pos_v = find(isnan(amplbank_s.value(:, num_frame)));
    if length(pos_v), warning('isnan');, end %amplbank_s.value(pos_v, num_frame) = 0;, end
    pos_v = find(isinf(amplbank_s.value(:, num_frame)));
    if length(pos_v), warning('isinf');, end %amplbank_s.value(pos_v, num_frame) = 0;, end

end
amplbank_s.unit = ampl_s.unit;




% ++++++++++++++++++++++++++++
if ~nargout | do.affiche
    axe_f_v = FLmatlabversf([1:N/2+1], sr_hz, N);
    for frame = 1:nb_frame

        subplot(311)
        plot(axe_f_v, FILTRE_s.value),
        xlabel('Frequency [Hz]'), ylabel('Amplitude [dB20]')
        grid on
        title(['numframe: ' num2str(frame)])

        subplot(312)
        plot(axe_f_v, 20*log10( ampl_s.value(1:N/2+1,frame) +eps))
        xlabel('Frequency [Hz]'), ylabel('Amplitude [dB20]')
        grid on

        subplot(313)
        plot(FILTRE_s.center, 20*log10(amplbank_s.value(:,frame) +eps), 'v-')
        xlabel('Mel coefficient'), ylabel('Amplitude [dB20]')
        grid on

        if nb_frame>1, pause, end
    end
end
% ++++++++++++++++++++++++++++








% function[f] = FLmatlabversf(k,Fe,tailleFFT)
%
% convertit un indice de vecteur matlab k (1<=k<=tailleFFT) en frequence f (0<=f<=Fe) en
%

function[f] = FLmatlabversf(k,Fe,tailleFFT)
f = (k-1)/tailleFFT*Fe;


