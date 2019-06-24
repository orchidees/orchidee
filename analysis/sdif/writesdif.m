% writesdif -- Create and write data to an SDIF file.
%
% This mex-function has three ways of calling it to perform the three
% sub-tasks of opening, writing, and closing an SDIF file.  All functions
% can only work on one file at a time.
% 
% - To open the SDIF file for writing, use one of:
%
%	writesdif(filename)
%	writesdif(filename, SDIF types definition file)
%	writesdif(filename, SDIF types definition file,localtypesstring)
%
%   The optional types definition file can only be given at the very first
%   call of writesdif and stays valid from then on, until restarting
%   Matlab. To have a local type definition stored in the sdif file
%   you provide a string that contains the type declaration as third 
%   parameter. For using writesdif on multiple files you may have
%   give an empty string for the types definition file 
%
%   writing a type definition could be done as follows:
%   typ=sprintf(['1MTD 1EHR '...
%	   '{ Index, Frequency, Amplitude, Phase, FreqSlope }\n',...
%	    '1FTD 1EHR {1EHR ExtendedHarmonicPartials;}\n'])
%   writesdif(file,'',typ);
%
% - To write a data frame containing any number of matrices to the SDIF file, 
%   use:
%
%	writesdif(Time, StreamID, FrameSignature, 
%                 MatrixSignature1, MatrixData1,
%                 MatrixSignature2, MatrixData2, ...)
%
%   Time and StreamID are double values, FrameSignature and MatrixSignature
%   are strings, MatrixData is for the moment restricted to be double 
%   or char.  (Later, the Matlab matrix data type will determine the 
%   SDIF matrix data type, so that you can write integer matrices as well.)
%
%   Special case are 1NVT matrices which need to be cell arrays of 
%   strings with size Nx2 (N rows and 2 columns). The first column gives 
%   the name the second column gives the value.
%
%  - To close the SDIF file, use:
%
%	writesdif('close')
%


% REMOVED FROM PUBLIC DOC:
%       writesdif(filename, SDIF types definition file, number of parameters)
%
% The number of parameters is need for use with jmax sdifplayer. It is
%        written in Information Value Table


% $Id: writesdif.m,v 1.7 2003/04/22 16:10:22 roebel Exp $
%
% writesdif.m	12. May 2000	Patrice Tisserand
%
% Matlab mex extension and support functions to write SDIF files.

% $Log: writesdif.m,v $
% Revision 1.7  2003/04/22 16:10:22  roebel
% Improved help for writing type definitions.
%
% Revision 1.6  2003/04/22 16:08:59  roebel
% Added possibility for writing local type declaration to
% sdif file.
%
% Revision 1.5  2001/05/14 17:31:48  roebel
% Upgraded documentation for char matrix data and 1NVT matrix support.
%
% Revision 1.4  2001/05/14 11:20:15  schwarz
% Updated and corrected help.
%
% Revision 1.3  2000/05/15  13:11:59  tisseran
% Corrected comments style
%
% Revision 1.2  2000/05/15  13:07:49  tisseran
% Added test for input arguments:
%    Is Matrix Signature a char?
% Removed debugging message (mexPrintf("Matrix Loop") ...)
% Removed unused variable
% Change comment style for writesdif.m
%
% Revision 1.1  2000/05/12  16:14:15  tisseran
% Mexfile to write sdif files in matlab.
% TODO: add possibility to use several file at same time.
%       add test on arguments
%
