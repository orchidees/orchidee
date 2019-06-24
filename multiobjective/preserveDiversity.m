function [C,I] = preserveDiversity(C,N,mode,F)

% PreserveDiversity - Sample a vector set in such a way to maximize
% density homogeneity (i.e. to preserve diversity). Vector in
% denser regions are iteratively removed from the set, until the
% set size falls under a given threshold N. Density is computed
% thanks to the PADE method.
%
% Usage: [C,I] = preserveDiversity(C,N,mode,<F>)
%
% Input aruments:
%   - C -> initial vector set in criteria space
%   - N -> size of final sample set
%   - mode -> Element removal method ('fitness', 'pareto', 'random'
%             or 'norm')
%   - F -> fitness vector of the input set 'mandatory in 'fitness'
%          mode only)
%

% Keep a backup of input set
Carchive = C;
I = 1:1:size(C,1);

% Compute number of elements to remove
drops = [];
Ndrop = size(C,1)-N;

switch mode
    
    case 'fitness'
        
        % Check 4th argument (fitness vector)
        if nargin < 4
            error(['*** Fitness argument is missing. ***']);
        end
        
        F = reshape(F,1,[]);
        
        % While population is too large, remove an element in
        % densest cell
        while size(drops,1) < Ndrop
            % Compute PADE density          
            [density,cell_indices] = density_PADE(C);
            % Find in densest cell the individual with worse fitness
            % (recall that the lower the fitness, the better the solution)
            [dmax,imax] = max(density);
            this_cell_I = find(cell_indices==imax);
            this_cell_F = F(this_cell_I);
            [fmax,imax] = max(this_cell_F);
            this_drop_I = this_cell_I(imax);
            % Drop the worst individual in densest cell
            drops = [ drops ; C(this_drop_I,:) ];           
            indices = [ (1:this_drop_I-1) (this_drop_I+1:size(C,1)) ];
            C = C(indices,:);
            F = F(indices);          
        end
        
    case 'pareto'
        
        % While population is too large, remove an element in
        % densest cell
        while size(drops,1) < Ndrop
            % Compute PADE density          
            [density,cell_indices] = density_PADE(C);
            % Find in densest cell pareto-dominated individuals
            [dmax,imax] = max(density);
            this_cell_I = find(cell_indices==imax);
            this_cell_C = C(this_cell_I,:);
            this_cell_P = extractParetoSet(this_cell_C);
            % Pick at random a dominated individual
            if size(this_cell_P) == size(this_cell_C)
                this_drop_I = randsample(this_cell_I,1);
            else
                in_pareto = ismember(this_cell_C,this_cell_P,'rows');
                potential_drop = this_cell_I(find(in_pareto==0));
                this_drop_I = randsample(this_cell_I,1);
            end
            % Drop the picked individual
            drops = [ drops ; C(this_drop_I,:) ];
            indices = [ (1:this_drop_I-1) (this_drop_I+1:size(C,1)) ];
            C = C(indices,:);         
        end
        
    case 'random'
        
        % While population is too large, remove an element in
        % densest cell
        while size(drops,1) < Ndrop
            % Compute PADE density         
            [density,cell_indices] = density_PADE(C);
            % Pick at random an individual in densest cell            
            [dmax,imax] = max(density);
            this_cell_I = find(cell_indices==imax);
            this_drop_I = randsample(this_cell_I,1);
            % Drop the picked individual
            drops = [ drops ; C(this_drop_I,:) ];           
            indices = [ (1:this_drop_I-1) (this_drop_I+1:size(C,1)) ];
            C = C(indices,:);           
        end
        
    case 'norm'
        
        % While population is too large, remove an element in
        % densest cell
        while size(drops,1) < Ndrop
            % Compute PADE density          
            [density,cell_indices] = density_PADE(C);
            % Find the element with highest euclidean norm in
            % densest cell            
            [dmax,imax] = max(density);
            this_cell_I = find(cell_indices==imax);
            this_cell_norms = sum(C(this_cell_I,:).^2,2);
            [max_norm,imax] = max(this_cell_norms);
            this_drop_I = this_cell_I(imax);
            % Remove the farest element in densest cell
            drops = [ drops ; C(this_drop_I,:) ];           
            indices = [ (1:this_drop_I-1) (this_drop_I+1:size(C,1)) ];
            C = C(indices,:);
            
        end
        
 otherwise
  
        % Raise exception if unknown mode
        error(['*** ' mode ' : Unknown density preservation mode. ***']);
        
end

% Compute sampled population index vector
[T,I] = ismember(C,Carchive,'rows');
