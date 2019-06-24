function export_instrument_symbol_info(knowledge_instance, symbolfile, handles)

% EXPORT_INSTRUMENT_SYMBOL_INFO - Export in a text file a table of symbols,
% folders and families for all the instruments in the database.
%
% Usage: export_instrument_symbol_info(knowledge_instance, symbolfile, handles)
%

% Check if in server mode
if nargin < 3
    handles = [];
end

% Open export file
if symbolfile(1) == '~'
    symbolfile = [ home_directory symbolfile(2:length(symbolfile)) ];
end

% Get known nomenclature
known_nomenclature = nomenclature(knowledge_instance);
symbols = known_nomenclature(:,3);
folders = known_nomenclature(:,2);
families = known_nomenclature(:,1);

% Compute text formating info
maxsymbolsize = 0;
for k = 1:length(symbols)
    if length(symbols{k})>maxsymbolsize, maxsymbolsize = length(symbols{k}); end
end
maxfoldersize = 0;
for k = 1:length(folders)
    if length(folders{k})>maxfoldersize, maxfoldersize = length(folders{k}); end
end
maxsymbolsize = maxsymbolsize+3;
maxfoldersize = maxfoldersize+3;
symbolformat = [ ' %-' num2str(maxsymbolsize) 's' ];
folderformat = [ ' %-' num2str(maxfoldersize) 's' ];

% Get instrument list sorted in orchestral order
scoreorder = get_score_order(knowledge_instance);
instrument_list = regexp(scoreorder, '\w*', 'match');

% Open export file
fid = fopen(symbolfile, 'w');
if fid == -1
    error('orchidee:knowledge:export_instrument_symbol_info:CannotOpenFile', ...
        [ 'Cannot open ''' symbolfile '''.' ] );
end

% Print data
fprintf(fid, '\n ORCHIDEE INSTRUMENT SYMBOLS\n\n');
% Iterate on instrument list
for k = 1:length(instrument_list)
    [t, idx] = ismember(instrument_list{k}, symbols);
    % If current instrument in known symbols ...
    if t
        % ... get folder and family from known nomenclature
        fprintf(fid, symbolformat, instrument_list{k});
        fprintf(fid, folderformat, folders{idx});
        fprintf(fid, ' %s\n', families{idx});
    else
        % ... else, get folder and family from known nomenclature from DB
        fprintf(fid, symbolformat, instrument_list{k});
        fprintf(fid, folderformat, get_folder(knowledge_instance, instrument_list{k}));
        fprintf(fid, ' %s\n', get_family(knowledge_instance, instrument_list{k}));
    end
end

% Close export file
fclose(fid);




function family = get_family(knowledge_instance, instrument)

% GET_FAMILY - Get the family of an instrument.
%
% Usage: family = get_family(knowledge_instance, instrument)
%

idx = query(knowledge_instance, 'instrument', instrument);
family = get_field_values(knowledge_instance, 'family', idx(1));
family = family{1};




function dir = get_folder(knowledge_instance, instrument)

% GET_FOLDER - Get the folder of an instrument.
%
% Usage: dir = get_folder(knowledge_instance, instrument)
%

idx = query(knowledge_instance, 'instrument', instrument);
dir = get_field_values(knowledge_instance, 'dir', idx(1));
dir = dir{1};
idx = regexp(dir, '/');
dir = dir(idx(2)+1:idx(3)-1);
