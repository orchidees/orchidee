function [C_out,max_depth] = flatcell(C_in,depth_in)

% FLATCELL - Converts a recursive structure of cells (i.e. a tree)
% into a single-level cell (i.e. a list)
%
% Usage: [C_out,max_depth] = flatcell(C_in,<depth_in>)
%



% Assign default values of optioal arguments
if nargin < 2
    depth_in = 1;
end
max_depth = depth_in;

if iscell(C_in)
  
    C_in = reshape(C_in,1,[]);

    C_out = {};

    % Iterate on cell elements
    for k = 1:length(C_in)
        
        depth = depth_in;

        if iscell(C_in{k})
            
            % Recursive call of flattcell if current element is
            % itself a cell
            [elem,depth] = flatcell(C_in{k},depth+1);
            C_out = [ C_out elem ];
            % Update max_depth
            max_depth = max(depth,max_depth);
           
        else
            
            % Append flatten subcell to current list
            C_out = [ C_out C_in{k} ];

        end

    end

else

    C_out = C_in;

end