function population_out = crossover(population_in)

% CROSSOVER - Uniform crossover operator. Input population is
% a double matrix where each row is an individual and each column
% is an instrument of the orchestra. Ouput population has the
% size of the input population.
%
% Usage: population_out = crossover(population_in) 
%

% Discard last element if population size is an odd number
[N,P] = size(population_in);
if mod(N,2)
    population_in = population_in((1:N-1),:);
    N = N-1;
end

% Shuffle rows
I = rand(N,1);
[o,I] = sort(I);
population_in = population_in(I,:);

% Build crossover index vector
N = size(population_in,1);
i1 = (1:N/2)*2-1;
i2 = i1+1;
I1 = (rand(N/2,P)>0.5);
I2 = 1-I1;
I = zeros(N,P);
I(i1,:) = I1;
I(i2,:) = I2;

% Re-arrange data
A = population_in.*I;
B = population_in.*(1-I);
A = A(i1,:)+A(i2,:);
B = B(i1,:)+B(i2,:);
population_out = zeros(N,P);
population_out(i1,:) = A;
population_out(i2,:) = B;