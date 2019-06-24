function s3 = merge_structures(s1,s2)

% MERGE_STRUCTURES - Copy (eventually create) the fields
% of structure s2 into s1.
%
% Usage: s3 = merge_structures(s1,s2)
%

s3 = s1;

f = fieldnames(s2);

for k = 1:length(f)
    s3.(f{k}) = s2.(f{k});
end