function [data_v, sr_hz, nbits, format] = FreadSoundFile(FILENAME, stop);
%function[data_v, sr_hz, nbits] = FreadSoundFile(FILENAME, stop)
%
% Read aiff or wav file depending on extension
%
%
% ===INPUTS
% FILENAME : complete name of the sound file (path/name.ext)
%
%
% ===OUTPUTS
% 
%
%
    
if nargin < 2
    stop = -1;
end

    
[root, SNDDIR, suffix] = Ffiletodirroot(FILENAME);
if strcmp(suffix, '.aiff') || strcmp(suffix, '.aif')
    [data_v, sr_hz, format] = aiffread(FILENAME, 1, stop, 1);
    nbits = format(2);
    format = 'AIFF';
elseif strcmp(lower(suffix), '.wav')
    if stop == -1
        [data_v, sr_hz, nbits] = wavread(FILENAME);
    else
        [data_v, sr_hz, nbits] = wavread(FILENAME, stop);
    end
    format = 'WAV';
else
    error('error : Unknown file format');
end