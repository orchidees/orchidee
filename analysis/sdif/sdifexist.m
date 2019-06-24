% Test if SDIF file exists.  Takes care of SDIF selection.
%
%          sdifexist(name)	Exits with error if file's not there.
% result = sdifexist(name)	Returns flag.

% $Id: sdifexist.m,v 1.3 2003/09/15 17:06:58 schwarz Exp $
%
% sdifexist.m	4. May 2000	Diemo Schwarz
%
% $Log: sdifexist.m,v $
% Revision 1.3  2003/09/15 17:06:58  schwarz
% handle ::: correctly
%
% Revision 1.2  2000/05/12  14:03:52  schwarz
% Oops-style errors.
%
% Revision 1.1  2000/05/04  13:24:08  schwarz
% Matlab mex extension and support functions to load SDIF files.

function result = sdifexist (name)
    result = 1;
    
    % remove selection from filename
    colon  = findstr(name, '::');
    
    switch length(colon),
     case 0,
      testname = name;

     case 1,
      testname = name(1:colon-1);
	
     otherwise,
      if colon(end-1) == colon(end)-1,
	  testname = name(1:colon(end-1)-1);	% three consecutive :
      else
	  testname = name(1:colon(end)-1);	% separate groups of ::
      end
    end
    
    % are you there?
    if ~exist(testname),  
	if nargout == 0,
	    error (['SDIF file ' testname ' does not exist']);
	end
	result = 0;
    end
return
