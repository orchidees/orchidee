function [y,Fs,Format]=aiffread(aiffile,start,stop,norm)
% aiffread  Load AIFF/AIFC format sound files. 
%                                Last change: <2007-05-29 16:45:17 roebel>
%
% [y,Fs,Format]=AIFFREAD(aiffile,start,stop,norm) 
%     loads an AIFF or AIFC format sound  file into matlab matrix.
%     For AIFC format only compression types NONE/FL32/FL64 are supported.
%
% Input Parameters:
%     aiffile : string specifying the file name of the sound to read.
%               a leading '~' is replaced by the
%               value of the environment variable $HOME
%               a leading = is replaced by the value of the
%               environment variable $SFDIR   
%     start   : (scalar int) first frame to read 
%               (first frame is denoted by start =1
%               which is the default)
%     stop    : (scalar int) last frame to read (default=file length)
%               special values are stop=-1 which means read the whole
%               file and stop = -2 which means  read
%               and return only file infos but do not read samples. 
%
%     norm    : (scalar int) if given and not equal to zero
%               the output is  normalized to range [-1,1]. 
%               otherwise the samples are read without rescaling
%               such that the values would use the range 
%               [-2^(bits-1),2^(bits-1)-1],
%               where bits = "number of bits per sample".
% 
% Output Parameters:
%   
%     y       : sound samples read having number of columns equal to the
%               number of channels and the different channels in the
%               columns of the matrix.
%     Fs      : sample rate of the sound file
%     Format  : vector with three entries holding
%
%        Format(1)       Number of channels
%        Format(2)       Bits per sample
%        Format(3)       number of frames 
%
%
% Author:      Axel Roebel
%
% Copyright:   This code is provided as is
%              without any guarantees. It is completely free. 
%              You can do with it what ever you like.
% 
% $Id: aiffread.m,v 1.2 2007/05/29 14:46:21 roebel Exp $

if nargin<1 | nargin> 4
  error(sprintf(['AIFFREAD takes up to four arguments, which are\n\tthe', ...
		 ' name of the AIFF file (required)\n\tthe first frame', ...
		' to read\n\tthe last frame to read or -1 for the last\n\t',...
		   'and a boolean specifying normalization']));
end

formstr='';
notend = 1;
comread = 0;
ssndread = 0;
aifc = 0;
if nargin==1
  start=1;
  stop=-1;
  norm = 0;
end

if nargin ==2 
  stop=-1;
  norm = 0;
end

if nargin == 3  
  norm = 0;
end

if( stop> 0 & stop < start & nargin ==1)
 error('aiffread: No samples selected\n');
 return;
end 

if aiffile(1) =='~'
  aiffile = [getenv('HOME'),aiffile(2:end)];
end

if aiffile(1) =='='
  aiffile = [getenv('SFDIR'),'/',aiffile(2:end)];
end

fid=fopen(aiffile,'rb','b');
if fid ~= -1 
	% read aiff chunk
	header=fscanf(fid,'%4s',1);
	if  ~strcmp(header, 'FORM')
	  error('No AIFF File!')
	end
	fsize=fread(fid,1,'int32');
        
	header=fscanf(fid,'%4s',1);
	if ~strcmp(header, 'AIFF')
	  aifc=1;
	  if ~strcmp(header, 'AIFC')
	    %disp(['FORM =', header])	    
	    error('No AIFF File!')
	  end
	end

	% read format sub-chunk
	while  notend == 1
	  header=fscanf(fid,'%4c',1);
	  len=fread(fid,1,'int32');
	  % correct chunksize which is always even
	  len = len + mod(len,2);
	  
	  if strcmp(header,'COMM')
	    if comread == 1
               error('Error reading AIFF chunks: 2 COMM-Chunks detected!')
            end
	    comread = 1;
            Format(1)=fread(fid,1,'short');           % Channel
	    %disp(sprintf('Channels   : %d',Format(1)))
	    frames = fread(fid,1,'ulong');            % Frames
	    Format(2)=fread(fid,1,'short');            % bits per sample
            Format(3)=frames;
            %disp(sprintf('Bits/Sample: %d', Format(2)))
	    expon=fread(fid,1,'short');
	    tt   = fread (fid,8,'uchar');

	    himant=((((tt(1)*256+tt(2))*256)+tt(3))*256+tt(4));
	    himant=(((((himant *256 +tt(5))*256+tt(6))*256)+tt(7))*256+tt(8))/2^63;
	    if( expon == 0  & himant == 0)
	      Fs = 0;
	    else
	      Fs=(himant) * 2^ (abs(expon) -16383);
	    end
            %disp(sprintf('Rate       : %.0f', Fs))
	    if aifc==1
	      compty=fscanf(fid,'%4c',1);
              if strcmp(compty, 'fl32') || strcmp(compty, 'FL32')
                fprintf('compression: Float 32\n');
                formstr='float32';
              elseif strcmp(compty, 'fl64') || strcmp(compty, 'FL64')
                formstr='float64';                
                fprintf('compression: Float 64\n');
	      elseif ~strcmp(compty, 'NONE')
		error('Only AIFC compression type NONE/FL32/FL64 supported!')
	      end
	      % Skip over the name string
	      fseek(fid,len+mod(len,2)-18-4,0);	    
	    end
		
	  elseif strcmp(header, 'SSND')
	    if ssndread == 1
               error('Error reading AIFF chunks: 2 SSND-Chunks detected!')
            end
	    ssndread = 1;
	  
	    offset=fread(fid,1,'ulong');
            dummy=fread(fid,1,'ulong');
	    if dummy ~= 0 
	      %disp('AIFF-SSND Chunk specify non zero blocksize ??')
            end
	    fseek(fid,offset,0);

            if length(formstr)==0
              if     Format(2) == 8
                formstr = 'schar';
              elseif Format(2) == 16
                formstr = 'short';
              elseif Format(2) == 32
                formstr = 'long';
              else 
                formstr = ['bit',num2str(Format(2))];
              end
            end

	    if start>1
	      fread(fid,Format(1)*(start-1),formstr);
	    end	      
            if stop >start & stop < frames
	      frames =stop;
	    end	    

            if stop > -2
              y=fread(fid,Format(1)*(frames-start+1),formstr);

              if norm 
                y = y/(2^(Format(2)-1));
              end
            else
              y =[];
            end
            notend = 0;
          else
	    %disp(sprintf(' Skip over %s',header));
	    fseek(fid,len,0);
          end
       end
       fclose(fid);
       if ~isempty(y)
         y =  reshape(y,Format(1),length(y)/Format(1))';       
       end
end     


if fid == -1
	error(['Can''t open AIFF file >',aiffile,'< for input!']);
end;

% $Log: aiffread.m,v $
% Revision 1.2  2007/05/29 14:46:21  roebel
% Fixed for matlab 7.4
%
% Revision 1.1.1.1  2007/02/12 17:07:39  roebel
%
%
%
%

%% Local Variables: 
%% time-stamp-start: "Last change:[ \t]+\\\\?[\"<]+"
%% End: 

