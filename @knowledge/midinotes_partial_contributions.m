function contributions = midinotes_partial_contributions(knowledge_instance,midinotes,target_partials,delta)

% MIDINOTES_PARTIAL_CONTRIBUTIONS - Return a matrix CONTRIB with N lines
% and P columns. N the number of input midinotes, and P is the number
% of target partials. CONTRIB(n,p) indicates which harmonic of note n
% contributes to the partial p of the target, modulo a error threshold
% delta. CONTRIB(n,p)=0 iif note n does note contribute to partial p at
% all.
%
% Note that harmonic frequencies are theoretic values derived from
% the pitch information in the input midinotes vector. A harmonic
% of note n contributes to a partial p iif their frequency ratio
% falls under a given threshold delta.
%
% Usage: contributions = midinotes_partial_contributions(knowledge_instance,midinotes,target_partials,delta)
%

midinotes = reshape(midinotes,[],1);

% Get number of harmonics to consider from the
% 'partialsMeanAmplitude' feature
n_harmonics = length(get_field_values(knowledge_instance,'partialsMeanAmplitude',1));

n_notes = length(midinotes);
n_partials = length(target_partials);

% Compute theoretic harmonic frequencies for each midi note
F = midi2hz(midinotes)*(1:1:n_harmonics);

% Allocate memory for contribution matrix
contributions = zeros(n_notes,n_partials);

lim_inf = 1/(1+delta);
lim_sup = 1+delta;

for i = 1:n_partials
    
    %%%% T = F/target_partials(i);
    %%%% T1 = (T>=lim_inf).*abs(1-T);
    %%%% T2 = (T<=lim_sup).*abs(1-T);
    %%%% T = sqrt(T1.*T2);
    %%%% T(find(T==0)) = inf;
    %%%% [Tmin,Imin] = min(T,[],2);
    %%%% idx = find(Tmin<inf);
    %%%% contributions(idx,i) = Imin(idx);
    
    % Compute frequency ratios
    T = F/target_partials(i);
    % Lower limit test
    T1 = double(T>=lim_inf);
    T1(T1==0) = inf;
    % Compute frequency ratios for matched partials (lower limit)
    T1 = T1.*abs(1-T);
    % Upper limit test
    T2 = double(T<=lim_sup);
    T2(T2==0) = inf;
    % Compute frequency ratios for matched partials (upper limit)
    T2 = T2.*abs(1-T);
    % Compute frequency ratios for matched partials (upper upper
    % and lower limit)
    T = sqrt(T1.*T2);
    % Take the lower ratio for the contribution
    [Tmin,Imin] = min(T,[],2);
    idx = find(Tmin<inf);
    contributions(idx,i) = Imin(idx);
    
end