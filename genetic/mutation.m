function population_out = mutation(population_in,variable_domains)

% MUTATION - 1-point mutation operator. Input population is
% a double matrix where each row is an individual and each column
% is an instrument of the orchestra. Ouput population has the
% size of the input population.
%
% Usage: population_out = mutation(population_in,variable_domains) 
%

% Generate a random population (same size as population_in)
random_pop = generate_random_population(variable_domains,size(population_in,1));

% Randomly insert elements of the random_pop matrix in the
% population_in matrix (one element per line)
random_pop = random_pop';
population_out = population_in';
mutation_idx = randsample(size(population_in,2),size(population_in,1),1);
mutation_idx = mutation_idx+(0:1:size(population_in,1)-1)'*size(population_in,2);
population_out(mutation_idx) = random_pop(mutation_idx);
population_out = population_out';