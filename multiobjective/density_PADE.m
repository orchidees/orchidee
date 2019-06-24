function [density,cell_indices] = density_PADE(C)

% DENSITY_PADE - Population-Adaptive Density Estimation.
% Given a input population C (as a set of vectors in the criteria space),
% output a 1xN density vector where N is the number of cells in the
% adaptive grid and each element is the number of individuals in the
% associated cell. Also ouput a cell_indices vector which map each
% individual to a cell index. Given a vector of criteria C(i), the local
% density at that point of the criteria space is density(cell_indices(i)).
%
% Usage: [density,cell_indices] = density_PADE(C)
%

% Get number of criteria
nC = size(C,2);

% Get umber of individuals in population
nK = size(C,1);

% Compute ideal point
ideal = min(C,[],1);

% Translate ideal point at origin
C = C-repmat(ideal,nK,1);

% Compute nadir point
nadir = max(C,[],1);

% Compute (float) number of cells on each dimension
nCells = nK^(1/nC);

% Compute cell width on each dimension
cell_width = nadir/nCells;

% Shift population (avoid individuals on the axes)
shift = nadir-floor(nCells)*cell_width;
C = C+repmat(shift,nK,1);

% Compute new nadir
nadir = max(C,[],1);

% Compute (integer) number of cells on each dimension
nCells = ceil(nCells);

% Rescale population to fit in grid
C = C./repmat(nadir,nK,1)*nCells;

% Quantize population (project each individuals on the
% closest grid node)
grid = ceil(C)-1;
grid = max(grid,0);

% Assign a cell index to each individual
factor = nCells.^(nC-1:-1:0);
cell_indices = sum(grid.*repmat(factor,nK,1),2)+1;
cell_indices = reshape(cell_indices,1,[]);

% Compute total number of cells
nCells = nCells^nC;

% Compute density (count the number of occurences
% of each cell index in the population (i.e. the density of each
% individual is the number of individuals sharing the same cell)
density = countAllValues(cell_indices,nCells);