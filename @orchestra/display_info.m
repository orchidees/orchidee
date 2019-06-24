function [] = display_info(orchestra_instance)

% DISPLAY_INFO - Print in shell the content of an orchestra, as
% well as its microtonic resolution. Content is displayed slot by
% slot (each slot may contain several instruments).
%
% Usage: [] = display_info(orchestra_instance)
%

disp(' ');
disp([' - Resolution : 1/' num2str(orchestra_instance.microtonic_resolution) ' semitone' ]);
for k = 1:length(orchestra_instance.instrument_list)

    str = [' - Slot ' sprintf('%3d',k) '   :' ];
    elem = orchestra_instance.instrument_list{k};

    if iscell(elem)
        for j = 1:length(elem)
            str = [ str ' ' elem{j} ];
        end
    else
        str = [ str ' ' elem ];
    end
    disp(str);

end
disp(' ');