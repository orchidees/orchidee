function [b,t]=frames(a,fsize,hopsize)
%b=frames(a,fsize,hopsize) - make matrix of signal frames
%
%  a: signal vector
%  fsize: samples - frame size
%  hopsize: samples - interval between frames
%  b: matrix of frames (columns)
%
%  hopsize may be fractional

if nargin < 3; help frames; return ; end
[m,n]=size(a);
if m>1; a=a'; if n > 1; error('signal should be 1D'); end; n=m; end

nframes = max(ceil((n-fsize)/hopsize)+1, 1);
b = ones(fsize, nframes);			% index matrix
t=1+ceil(hopsize*(0:nframes-1));	% frame start indices
b(1,:)=t;  
b=cumsum(b);
a=[a, zeros(1,fsize)]'; % allow last slice to extend a bit beyond end of a
b=a(b);

