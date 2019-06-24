%  [p,contflag]=initialize(oldp)
%========================================================================
% - Description ---------------------------------------------------------
% compute parameters after parsing command line
% - In ------------------------------------------------------------------
% oldp      structure of parameters
% - Out -----------------------------------------------------------------
% p         structure of parameters
% - Revision ------------------------------------------------------------
% 2001-04-07.01
% $Revision: 1.1 $
% $Date: 2006/09/14 13:10:58 $
%========================================================================
function [p,contflag]=initialize(optin)

    p=setdefaultvalues;

    [p,contflag]=parsecommandline(p,optin); if (~contflag); return; end

    contflag=1;
    
    % check minimum and maximum signal frequency
    if (p.f0.min >= p.f0.max)
	contflag=0;
	disp('Error initializing parameters: F0 min is bigger than F0 max!');
	return;
    end
    % set the maximum signal frequency, default: half of sampling frequency
    if (p.signal.fmax == 0)
	p.signal.fmax = p.signal.fsample/2;
    end
    
    if (p.f0.max*3>p.signal.fmax)
	p.signal.fmax = min(p.signal.fsample/2,p.f0.max*3.5);
    end
    % check maximum signal frequency and sampling rate
    if (p.signal.fmax > (p.signal.fsample/2))
	contflag=0;
	disp('Error initializing parameters: f max is bigger than half of sampling rate!');
	return;
    end
    % check maximum signal frequency and max F0 frequency
    if (p.f0.max > p.signal.fmax)
	contflag=0;
	disp('Error initializing parameters: F0 max is bigger than f max!');
	return;
    end
    % check if both size and bandwidth of FFT is entered
    if ( (p.fft.df ~= 0) & (p.fft.size ~= 0))
	contflag=0;
	disp('Error initializing parameters: FFT points and bandwidth are set, set only one of both!');
	return;
    end
    % check threshold
    if (p.fft.threshold > 0)
	contflag=0;
	disp('Error initializing parameters: threshold has to be positiv!');
	return;
    end
    % compute the window size as 3.5 times of the F0min period
    if (p.signal.blocksize == 0)
	t0=1/p.f0.min;
	p.signal.blocksize = round(3.5*t0*p.signal.fsample);
    end
    % set the size and the bandwidth of FFT
    if ( (p.fft.df == 0) & (p.fft.size == 0))
	% compute a fft size with a factor to the power of 2
	p.fft.size = 2^(floor(log2(p.signal.blocksize))+1);
	p.fft.df = (p.signal.fsample/2)/p.fft.size;
    end
    % compute the size of FFT if bandwith is given
    if (p.fft.size == 0)
	p.fft.size = round((p.signal.fsample/2)/p.fft.df);
    end
    % compute the bandwidth of FFT if size is given
    if (p.fft.df == 0)
	p.fft.df = (p.signal.fsample/2)/p.fft.size;
    end
    % check window size and points of FFT
    if (p.signal.blocksize > p.fft.size*2)
	contflag=0;
	disp('Error initializing parameters: window size is bigger than points of FFT!');
	return;
    end
    % check window size and feed
    if (p.signal.feed >= p.signal.blocksize)
	contflag=0;
	disp('Error initializing parameters: feed is bigger or equal than window size!');
	return;
    end
    if (p.histo.width > 0)
	p.histo.type = 2;
    end
    
    [pathstr,name,ext,versn]=fileparts(p.out.filename);
    % set the name for output file as the input file
    if (strcmp(name,''))
	p.out.filename = p.in.filename;
    end 
    
    if (p.signal.blocksize/p.signal.fsample<0.093);
	p.signal.thresh = [0.114;0.2;0.25;0.5];
    end
    
    p.fft.lobe = p.signal.fsample*6/p.signal.blocksize;
    
    % otherwise the complete string filename will be used:
    current=p.out.filename;
    % set the names of output debug files
    %p.out.filesignal = sprintf('%s.signal.mat',current);
    %p.out.fileproba = sprintf('%s.proba.mat',current);
    %p.out.filemodel = sprintf('%s.model.mat',current);
    %p.out.fileparam = sprintf('%s.param.mat',current);
    %p.out.filef0 = sprintf('%s.f0',current);
    %p.out.filef0max = sprintf('%s.max.f0',current);
    %p.out.filedebug = sprintf('%s.debug',current);
    %if (p.cmd.bDebug); p.cmd.file=fopen(p.out.filedebug,'wt'); end
return

% p=setdefaultvalues()
%========================================================================
% - Description ---------------------------------------------------------
% set the parameters to the default values
% - In ------------------------------------------------------------------
%
% - Out -----------------------------------------------------------------
% p         structure of parameters
% - Revision ------------------------------------------------------------
% 2001-04-08.01
% $Revision: 1.1 $
% $Date: 2006/09/14 13:10:58 $
%========================================================================
function p=setdefaultvalues()
 p=[];
 p.cmd.bDebug=0;			 % switch debug output on/off; OLD:flag.debug
 p.cmd.bGraphic=0;		         % switch graphical output on/off
 p.cmd.file=0;				 % debugfile
 p.cmd.pause=0;				 % get control after each frame analysus
 p.cmd.mode = 1;                         % initial mode -> fixed F0 number
 p.cmd.verbose = 0;
 p.cmd.avi=0;
 
 p.in.fileformat=1;			% Fileformat of input, 0=RAW,1=AIF, 2=WAV
 p.in.filename='cc.aiff';	        % Filename of input
 p.in.trkfile = [];
 p.out.filename='';			 % Filename of output, will be added with extension
% p.out.bwritefft = 0;			 % switch writing of FFT to a file on/off
 p.out.bwritef0 = 0;                     % switch writing of f0 file on/off
% p.out.bdebug=0;			 % switch output to a file on/off; OLD:flag.result_long=QUI
 p.out.writepartial=1;                   % write partial frequencies 
 
 p.signal.fsample = 48000;		        % Sample frequency of input signal; OLD:freq_ech
 p.signal.fmax=5000;			% Maximum frequency of input signal; OLD:freq_maximum
 p.signal.start=1;			% Start of signal to process; OLD:debut
 p.signal.end=0;				% End of signal to process; OLD:fin
 p.signal.blocksize=4096;		        % Length of block to cut from signal
 p.signal.feed=1024;			% count of points to feed between blocks; OLD:intervalle_fft
 p.signal.soff=0;                        % search range for optimal win pos in terms of minimal blocksize
 p.signal.thresh = [0.114;0.17;0.1987;0.5]; % thresholds for sinusoidal detection (dur1, dur2, bw)
 
 p.fft.size=16384;		         % count of points of FFTsize/2, 
 p.fft.df=0;				 % bandwidth of spectrum; OLD:pas_freq
 p.fft.window=2;			 % Shape of cutting window; 0=Box,1=Hamming,2=Blackman
 p.fft.threshold=-50;			 % Threshold of logarithmical amplitude to cut off; OLD:seuil_normalisation
 
 p.f0.min=50;				% min F0 in search; OLD:f0_mimimum
 p.f0.max=2000;				% max F0 in search; OLD:f0_maximum
 p.f0.default=0;			% Default F0 frequency if no spectrum found; OLD:f0_defaut
 p.f0.select=[];                         % Pre-select F0s as candidates
 p.f0.assign=[];                         % Pre-assigned F0s as final outputs

 %p.histo.type=1;		  	 % 1=shaped F0,2=shaped F0+signal
 p.histo.df=1;				 % F0 candidate frequency grid in Hz
 p.histo.snr=0;				 % snr
 p.histo.width=0;	                 % if nonzero width of Gaussian probability in Hz (sigma width/8) 
 p.histo.env=0;		                 % type of spectral env: 0=const,1=1/sqrt(f),2=1/f
 p.histo.distexp1=0.5;                   % set the numerator exponent for the distance
 p.histo.distexp2=2;                     % set the denominator exponent for the distance
 p.histo.alpha=0.035;                    % set maximum distance of model and data peaks
 p.histo.numparts=3;                     % set number of peaks to emphasize
 %p.histo.dist=5;                         % run the current version
 p.histo.extpic=0;                       % extract hidden peaks
 p.histo.distcoeff=[3 5 5 5 20 11 11 11 0]; % distance coefficient
 p.histo.npct = 0.9410;                       % noise percentage
 p.histo.dpct = 5.5677;%6;      
 p.histo.delta = sqrt(-4*log(1-p.histo.npct)/pi);
 p.histo.offset = (log(2)+psi(1))/2;
 %%%% mbw threshold %%%%

 p.poly.numnote=1;                       % the number of F0s to be evaluated
 p.poly.ranknb=5;                        % the number of ranking combinations
 p.poly.maxnum=5;                        % max number of concurrent F0s
 p.poly.f0sel = [];

 p.save.distance=1;                      %save the distance structure for further tracking

 %p.trace.enable=0;                        % switch tracking on/off
 %p.trace.nframes=30;                      % set the number of blocks to track at once
 %p.trace.ncandidates=10;                  % set the number of most likely F0s to compare in one block
 %p.trace.sigma=0.1;                       % set sigma
 %p.trace.freqval=4;                       % set the estimation value of frequency derivation
 %p.trace.costloss=1;                      % set the estimation value of former costs
return

% [p,contflag]=parsecommandline(oldp,optin)
%========================================================================
% - Description ---------------------------------------------------------
% parse the command line and set parameter values
% - In ------------------------------------------------------------------
% oldp      structure of parameters
% optin     commandline options
% - Out -----------------------------------------------------------------
% p         structure of parameters
% - Revision ------------------------------------------------------------
% 2001-04-07.01
% $Revision: 1.1 $
% $Date: 2006/09/14 13:10:58 $
%========================================================================
function [p,contflag]=parsecommandline(p,optin)
    
    %p=oldp;
    contflag=1;				% flag if parent program should contflag
    if (isempty(optin)); return;  end
    options=splitcmdline(optin);	% split to option with argument as string and value
    if (isempty(options))		% problem in parsing command line
	disp(sprintf('\n'));
	disp('===================================================================')
	disp(sprintf('Error parsing command line argument: >%s<',optin))
	usage;
	contflag=0;
	return;
    end
    
    for (argNr=1:length(options))	% treat each argument
	isnumeric=1;			% flag if value is numeric
	option = options(argNr);	% get option	
	opt = option.opt;
	str=option.sarg;
	value=option.narg;

	switch opt
	    % general
	 case {'-h'}
	  contflag=0;
	 case {'-d'}
	  p.cmd.bDebug=1;
	  isnumeric=0;
	 case {'-g'}
	  p.cmd.bGraphic=1;
	  isnumeric=0;
	 case {'-p'}
	  p.cmd.pause=1;
	  isnumeric=0;
	 case {'-v'}  %%%% verbose flag, added by JOSEPH...
	  p.cmd.verbose=1;
	  isnumeric=0;
	 case {'-n'}  %%%% noise level estimation
	  p.cmd.mode = 0;
	  isnumeric=0;
	 case {'-f'}  %%%% fix F0 number
	  p.cmd.mode = 1;
	  isnumeric=0;
	 case {'-a'}  %%%% automatic detection of F0 number
	  %p.cmd.auto=1;
	  p.cmd.mode = 2;
	  isnumeric=0;
	 case {'-t'}  %%%% tracking given notes
	  %p.cmd.auto=1;
	  p.cmd.mode = 3;
	  isnumeric=0;
	  
	  % input file 
	 case {'-in'}
	  % AXEL support for ~/ 
	  if str(1) =='~'
	      str = [getenv('HOME'),str(2:end)];
	  end
	  p.in.filename=str;
	  isnumeric=0;
          
          %% Damien
	  [data_v, sr_hz, nbits, format] = FreadSoundFile(str, 2);
	  p.in.fileformat=format;
	  p.signal.fsample=sr_hz;
          %% Fin Damien

% 	  fileinfo = mysf_info(str);
% 	  p.in.fileformat=fileinfo.format;
% 	  p.signal.fsample=fileinfo.sr;
	  disp(sprintf('sampling frequency:  %2.2f kHz \n',p.signal.fsample/1000));
	  
	 case {'-trk'}
	  if str(1) =='~'
	      str = [getenv('HOME'),str(2:end)];
	  end
	  p.in.trkfile=str;
	  isnumeric=0;
	  
	 case {'-td'}
	  if str(1) =='~'
	      str = [getenv('HOME'),str(2:end)];
	  end
	  load(str)
	  p.td.onset = onset;
	  isnumeric=0;
	  
	 case {'-if'}
	  p.in.fileformat=value;
	  % output file
	 case {'-on'}
	  % AXEL support for ~/ 
	  if str(1) =='~'
	      str = [getenv('HOME'),str(2:end)];
	  end
	  p.out.filename=str;
	  isnumeric=0;
	 %case {'-offt'}
	  %p.out.bwritefft=1;
	  %isnumeric=0;
	 case {'-of0'}
	  p.out.bwritef0=1;
	  isnumeric=0;
	 %case {'-od'}
	  %p.out.bdebug=1;
	  %isnumeric=0;
	 case {'-opn'}
	  p.out.writepartial=0;
	  isnumeric=0;
	  % signal
	 case {'-ssf'}
	  p.signal.fsample=value;
	 case {'-smf'}
	  p.signal.fmax=value;
	 case {'-ss'}
	  p.signal.start=max(p.signal.fsample*value,1);
	 case {'-se'}
	  p.signal.end=p.signal.fsample*value;
	 case {'-ssize'}
	  p.signal.blocksize=value;
	 case {'-sfeed'}
	  p.signal.feed=value;
	 case {'-ssoff'}
	  p.signal.soff=value;
	  % FFT
	 case {'-fsize'}
	  p.fft.size=value;
	 case {'-fdf'}
	  p.fft.df=value;
	 case {'-fw'}
	  p.fft.window=value;
	 case {'-ft'}
	  p.fft.threshold=-value;
	  % f0
	 case {'-f0min'}
	  p.f0.min=value;
	 case {'-f0max'}
	  p.f0.max=value;
	 case {'-f0def'}
	  p.f0.default=value;
	  % histo
	 case {'-hdf'}
	  p.histo.df=value;
	 case {'-hsnr'}
	  p.histo.snr=value;
	 case {'-hwidth'}
	  p.histo.width=value;
	 case {'-hquant'}
	  p.histo.quant=value;
	 case {'-henv'}
	  p.histo.env=value;
	 case {'-hdist'}
	  p.histo.dist=value;
	 case {'-hextpic'}
	  p.histo.extpic=value;
	 case {'-hdstcf'}
	  p.histo.distcoeff=value;
	 case {'-distexp1'}
	  p.histo.distexp1=value; 
	 case {'-distexp2'}
	  p.histo.distexp2=value; 
	 case {'-alpha'}
	  p.histo.alpha=value;
	 case {'-numparts'}
	  p.histo.numparts=value;
	 case {'-npct'}
	  p.histo.npct=value;
	 case {'-dpct'}
	  p.histo.dpct=value;
	  %number of sources
	 case {'-numnote'}
	  p.poly.numnote=value;
	  p.poly.maxnum=value;
	 case {'-f0sel'}
	  p.poly.f0sel=value;
	 case {'-f0assign'}
	  p.poly.assign=value;
	 case {'-ranknb'}
	  p.poly.ranknb=value;

	  %save distances
	 case {'-sdist'}
	  p.save.distance=value;
	  isnumeric=0;
 	  % track
	 %case {'-t'}
	  %p.trace.enable=1;
	  %isnumeric=0;
	 case {'-tframes'}
	  p.trace.nframes=value;
	 case {'-tcand'}
	  p.trace.ncandidates=value;
	 case {'-tsigma'}
	  p.trace.sigma=value;
	 case {'-tfacfreq'}
	  p.trace.freqval=value;
	 case {'-tfaccost'}
	  p.trace.costloss=value;
  	  %otherwise
	 otherwise
	  contflag=0;
	end
	p.histo.npct = 1-exp(-(pi/4)*10.^(p.histo.dpct/10));
	p.histo.delta = sqrt(-4*log(1-p.histo.npct)/pi);
	p.f0.max = ceil(p.f0.max*(1+p.histo.alpha));
	
	minWinSize = 3.5*p.signal.fsample/p.f0.min;
	if (p.signal.blocksize<minWinSize)
	    p.signal.blocksize = minWinSize;
	end
	    
	% check for error during command line parsing
	if ( (isnumeric & isempty(value)) | ~contflag)
	    if (isempty(opt) | ~strcmp(opt, '-h') )
		disp(sprintf('\n'));
		disp('===================================================================')
		disp(sprintf('Error during parsing command line option: >%s<',option.cmd))
	    end
	    usage;
	    return;
	end
    end
    return;

% options=splitcmdline(optin)
%========================================================================
% - Description ---------------------------------------------------------
% split the command line in options, argument string and argument value
% - In ------------------------------------------------------------------
% optin           cmd line of options
% - Out -----------------------------------------------------------------
% options.cmd     option with argument
% options.opt     option
% options.sarg    argument as string
% options.narg    argument as number or empty if no number
% - Revision ------------------------------------------------------------
% 2001-02-09.01
% $Revision: 1.1 $
% $Date: 2006/09/14 13:10:58 $
%========================================================================
function options=splitcmdline(optin)
options = [];
optin=[' ' optin];
pos=findstr(optin, ' -i');		% find all positions of options
pos=[pos, findstr(optin, ' -o')];	% 
pos=[pos, findstr(optin, ' -d')];	% to be able to use negative 
pos=[pos, findstr(optin, ' -g')];	% values we search explicitly
pos=[pos, findstr(optin, ' -p')];	% values we search explicitly
pos=[pos, findstr(optin, ' -h')];	% for the possible opt chars
pos=[pos, findstr(optin, ' -f')];	% 
pos=[pos, findstr(optin, ' -s')];	% 
pos=[pos, findstr(optin, ' -t')];	% 
pos=[pos, findstr(optin, ' -a')];	% 
pos=[pos, findstr(optin, ' -n')];	% 
pos=[pos, findstr(optin, ' -v')];	% for verbose flag, added by JOSEPH

if (length(pos) == 0); return; end;

% put indizes back in ascending order
pos=sort(pos);

% save each option with argument
count = 0;
for (i=1:length(pos)-1)
   count = count + 1;
   options(count).cmd=deblank( optin( pos(i)+1 : pos(i+1)-1 ) );
end   
count = count + 1;
options(count).cmd=deblank( optin( pos(length(pos))+1 : length(optin) ) );

% ... and split it into option, string and possibbly numeric value
for(i=1:count)
  cmd = options(i).cmd;
  options(i).opt='';
  options(i).sarg='';
  options(i).narg=[];
  if(cmd(1) == '-')
    pos=findstr(cmd,' ');
    if(isempty(pos))
      options(i).opt=cmd;
    else
      options(i).opt=cmd(1:pos(1)-1);
      options(i).sarg=cmd(pos(1)+1:length(cmd));
      options(i).narg=str2num(options(i).sarg);
    
    end
  end
end   
return;


% usage()
%========================================================================
% - Description ---------------------------------------------------------
% Show the usage of the command line parameters
% - In ------------------------------------------------------------------
% 
% - Out -----------------------------------------------------------------
% 
% - Revision ------------------------------------------------------------
% 2001-04-07.01
% $Revision: 1.1 $
% $Date: 2006/09/14 13:10:58 $
%========================================================================
function usage()
global VERSION;
disp(sprintf('\n'));
disp('===================================================================')
disp(sprintf('multif0 (%s). Written by Chunghsin YEH, etc.',VERSION))
disp('')
disp('Usage: Include the command line options always in hyphens('') and')
disp('divide them with a blank( ).')
disp('Write the argument after the option and divide it with a space( ).')
disp('===================================================================')
disp('Example: multif0('' -in /data/test/input.wav -on /data/test/output'')')
disp('-> Set input file and output file with the exact path''.')
disp('===================================================================')
disp('******* General options *******************************************')
disp('-h                     show this Help dialog')
%disp('-d                     set Debug mode')
disp('-g                     set Graphical debug mode')
disp('-p                     set frame pause mode')
disp('-v                     verbose mode')
disp('-n                     noise level estimation mode')
disp('-f                     F0 estimation fixed number mode')
disp('-a                     F0 estimation auto number mode')
disp('-v                     verbose mode')
disp('******* Input file options ****************************************')
%disp('-if      1             set fileFormat; 0=RAW,1=AIF')
disp('-in      input.aif     set input file')
disp('******* Output file options ***************************************')
disp('-on      output         set outfile basename')
%disp('-offt                  enable writing of FFT to a file')
%disp('-od                    set debug mode to write peaks, histo and property to files')
disp('******* Signal options ********************************************')
disp('-ssf     44100         set Sample Frequency')
disp('-smf     5000          set the maximum analysis frequency')
disp('-ss      1             set the Start time in sec of signal to process')
disp('-se      end           set the End time in sec of signal to process')
disp('-ssize   4096          set size of block to process')
disp('-sfeed   1024          set Feed between each blocks to process')
disp('-ssoff   0             set search loc. for opt. win pos (sample offset)')
disp('******* FFT options ***********************************************')
disp('-fsize   16384         set FFT size')
%disp('-fdf     1.3458        set the bandwidth between each point of FFT')
disp('-fw      2             set the shape of FFT Window; 0=Box,1=Hamming,2=Blackman')
%disp('-ft      50            set the Threshold [dB] of logarithmical amplitude to cut off')
disp('******* f0 options ************************************************')
disp('-f0min   50            set the Minimum frequency to find a f0')
disp('-f0max   2000          set the Maximum frequency to find a f0')
disp('-f0def   0             set the default f0 frequency, if no one is detected')
disp('-f0sel                 select target f0s for tracking')
%disp('-f0assign []           set the others f0s in the signal but not analyzed')
disp('******* Histogram options ***************************************** ')
%disp('-hdf     1             set the stepsize between each model');
%disp('-hsnr    0.01          set the SNR');
%disp('-hwidth  20            set the width of shape (def=0 no synth shape)');
%disp('-hquant  1             set sum of normalized  spectrum (def=1)');
%disp('-henv    1             set the spectr env: 0=const,1=1/sqrt(f),2=1/f');
%disp('-hdist    5            set the current distance function to calculate f0');
%disp('-hextpic  0            extract the hidden peaks');
disp('-harmcomb 0            use harmonic=1 or inharmonic=0 comb matching');
disp('******* Number of sources mixed ************************************** ')
disp('-numnote  1             set the maximal number of multiple F0s');
%disp('-polyexp1 0.5          set the exponential coefficient in polyphonic cases');
%disp('-polyexp2 2            set the exponential coefficient in polyphonic cases');
%disp('******* Matrix of distances ************************************** ')
disp('-sdist 1                save the calculated distance structure for further tracking')
%disp('******* Tracking options ***************************************** ')
%disp('-t       0             switch tracking on/off')
%disp('-tframes 30            set the number of blocks to track at once')
%disp('-tcand   10            set the number of most likely F0s to compare in one block')
%disp('-tsigma  0.1           set sigma')
%disp('-tfacfreq 2            set the estimation value of frequency derivation')
%disp('-tfaccost 1            set the estimation value of former costs')
 return;
 
