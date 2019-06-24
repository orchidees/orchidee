function t = check_struct_content(s1,s2)

% CHECK_STRCUT_CONTENT - Check that s1 containts at least all
% fields and sub-fields of s2, with same data types.
%
% Usage: t = check_struct_content(s1,s2)
%

if isstruct(s1) && isstruct(s2)

    f1 = fieldnames(s1);
    f2 = fieldnames(s2);

    if min(ismember(f2,f1));
      
            for k = 1:length(f2)
                t = check_struct_content(s1.(f2{k}),s2.(f2{k}));
                if ~t
                    break;
                end
            end

    else

        t = 0;
    
    end

elseif strcmp(class(s1),class(s2))
    
    t = 1;

else

    t = 0;

end