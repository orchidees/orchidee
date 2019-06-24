function searchstructure_instance = orchestrate(searchstructure_instance,handles)

% ORCHESTRATE - Multicriteria orchestration algorithm.
%
% Usage: searchstructure_instance = orchestrate(searchstructure_instance,handles)
%


% Search parameters
initPopSize = 200; % 200
maxPopSize = 500; % 500
matingPoolSize = 50; % 50
nIter = 200; % 200
paretoMaxSize = 100; % 100

% Optimization features
features = searchstructure_instance.used_features;

% Get search structure data
variable_domains = searchstructure_instance.variable_domains;
feature_structure = searchstructure_instance.feature_structure;
target_features = searchstructure_instance.target_features;

% Draweights weights (Jaszkiewicz's method)
if length(features) > 1
    weights = draw_jaszkiewicz_weights(nIter,length(features));
else
    weights = ones(nIter,1);
end




%%%%%%%%%%%%%%%%%%%%%
% Inital population %
%%%%%%%%%%%%%%%%%%%%%

check_interruption();

% Swith warning messages off
warning('off');

% instantiate random initial population
pop_genes = generate_random_population(variable_domains,initPopSize);

% ***** Evaluate initial population *****
pop_critr = abs(eval_population(pop_genes,feature_structure,target_features,features));
[pop_genes,pop_critr] = discard_nan(pop_genes,pop_critr);

% ***** Estract initial Pareto set *****
[n,pop_critr_sampled] = sample_criteria_space(pop_critr,100);
pareto_critr = extract_pareto_set(pop_critr_sampled);
[t,loc] = ismember(pareto_critr,pop_critr,'rows');
pareto_genes = pop_genes(loc,:);

% Ideal and nadir estimations
nadir_estimate = max(pop_critr,[],1);
ideal_estimate = min(pop_critr,[],1);
critr_ranges = nadir_estimate-ideal_estimate;





%%%%%%%%%%%%%%%%%%
% Evolution loop %
%%%%%%%%%%%%%%%%%%

%barHandle = waitbar(0,'Exploring search space...');

for iter = 1:nIter
    
    check_interruption();
    
    server_says(handles,'Exploring search space ...',iter/nIter);

    %%%%%%%%%%%%%%%%%%%%%%%
    % GENETIC EXPLORATION %
    %%%%%%%%%%%%%%%%%%%%%%%

    % ***** Compute fitness *****
    % Compute audio fitness
    pop_fitness = scalarize(pop_critr,weights(iter,:),ideal_estimate,critr_ranges);

    % ***** Selection *****
    selected_idx = select_popuation(pop_fitness,matingPoolSize);
    mating_pool = pop_genes(selected_idx,:);

    % ***** Crossover *****
    offspring_genes = crossover(mating_pool);

    % ***** Mutation *****
    offspring_genes = mutation(offspring_genes,variable_domains);

    % ***** Compute offspring criteria and audio fitness *****
    offspring_critr = abs(eval_population(offspring_genes,feature_structure,target_features,features));
    [offspring_genes,offspring_critr] = discard_nan(offspring_genes,offspring_critr);
    
    % update ideal and nadir
    nadir_estimate = max([offspring_critr ; nadir_estimate],[],1);
    ideal_estimate = min([offspring_critr ; ideal_estimate],[],1);
    critr_ranges = nadir_estimate-ideal_estimate;

    % ***** Insert offspring in population *****
    new_pop_genes = [ pop_genes ; offspring_genes ];
    new_pop_critr = [ pop_critr ; offspring_critr ];
    pop_genes = new_pop_genes;
    pop_critr = new_pop_critr;

    % update pareto set
    new_pareto_genes = [ pareto_genes ; offspring_genes ];
    new_pareto_critr = [ pareto_critr ; offspring_critr ];
    pareto_genes = new_pareto_genes;
    pareto_critr = new_pareto_critr;
    [pareto_genes_tmp,I] = unique(pareto_genes,'rows');
    pareto_critr_tmp = pareto_critr(I,:);
    pareto_critr = extract_pareto_set(pareto_critr_tmp);
    [t,loc] = ismember(pareto_critr,pareto_critr_tmp,'rows');
    pareto_genes = pareto_genes_tmp(loc(t==1),:);



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % POPULATION SIZE HANDLING %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    J = ismember(pop_critr,pareto_critr,'rows');
    dominated_critr = pop_critr(~J,:);
    dominated_genes = pop_genes(~J,:);
    
    % Reduce pareto set size if too large
    if size(pareto_genes,1) > paretoMaxSize
        [pareto_critr,I] = preserveDiversity(pareto_critr,paretoMaxSize,'random');
        pareto_genes = pareto_genes(I,:);
    end

    % Preserve density for dominated individuals
    if size(dominated_critr,1) > maxPopSize-size(pareto_critr,1)
        [dominated_genes,dominated_critr] = ...
            smooth_population(dominated_genes,dominated_critr,maxPopSize-size(pareto_critr,1));
    end

    % Mix reduced Pareto set and individuals of homogeneous density into
    % next generation
    pop_critr = [ dominated_critr ; pareto_critr ];
    pop_genes = [ dominated_genes ; pareto_genes ];

end

% Switch warning messages back on
warning('on');

% Build output structure
searchstructure_instance.solution_set.genes = pareto_genes;
searchstructure_instance.solution_set.features = compute_features(feature_structure,pareto_genes,features);
searchstructure_instance.solution_set.criteria = pareto_critr;




function fitness = scalarize(criteria,weights,ideal,ranges)

% Fitness computation. First scale the population in the unit
% hypercube (thanks to current ideal point and ranges info), then
% apply a weighted Chebychev norm.

n = size(criteria,1);
criteria = criteria-repmat(ideal,n,1);
criteria = criteria./repmat(ranges,n,1);
fitness = max(criteria.*repmat(weights,n,1),[],2);




function [genes,critr] = discard_nan(genes,critr)

% Remove from population every idividual for which at least one
% criterion as a NaN value.

critr_nan = max(isnan(critr),[],2);
critr_ok = find(~critr_nan);
critr = critr(critr_ok,:);
genes = genes(critr_ok,:);
