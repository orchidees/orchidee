function [population,criteria] = smooth_population(population,criteria,pop_size)

% SMOOTH_POPULATION - Remove elements in from denser region of a
% population, until a max population size value is reached.
% The main difference with the 'preserveDiversity' function is that
% the PADE grid is NOT recomputed after each removal.
%
% Usage: [population,criteria] = smooth_population(population,criteria,pop_size)
%

if size(population,1) > pop_size

    % Compute local density
    [density,cell_idx] = density_PADE(criteria);

    % While current population size exceed a max value, remove the
    % element with higher local density
    while size(population,1) > pop_size
        
        % Pick the first element with highest density
        denser_cell = find(density==max(density),1);
        rem_idx = find(cell_idx==denser_cell,1);
        % Decrement the local density in the cell
        density(denser_cell) = density(denser_cell)-1;
        % Remove individual
        population = [ population(1:rem_idx-1,:) ; population(rem_idx+1:size(population,1),:) ];
        criteria = [ criteria(1:rem_idx-1,:) ; criteria(rem_idx+1:size(criteria,1),:) ];
        cell_idx = [ cell_idx(1:rem_idx-1) cell_idx(rem_idx+1:length(cell_idx)) ];

    end

end