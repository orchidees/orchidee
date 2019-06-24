function occ = countAllValues(mtx,maxValue)

% COUNTALLVALUES - Count the occurences of all values between 1 and
% 'maxValue' in each line of a matrix. If A is the input
% NxP matrix, countAllValues(A,M) returns a NxM matrix B where
% B(k,l) is the number of occurences of l in A(k,:). 
%
% Usage: N = countAllValues(mtx,maxValue)
%

% Call Mex file
occ = (countAllValuesMex(mtx',maxValue))';

