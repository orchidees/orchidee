function handles = osc_dbanalyzesamples(osc_message,handles)  
        
% OSC_DBANALYZESAMPLES - Extract symbolic attributes and perceptual
% features from sound files and store them in XML description files.
%
% Usage: handles = osc_dbanalyzesamples(osc_message,handles)
%

% Check input arguments number
if length(osc_message.data) < 3
    error('orchidee:osc:osc_dbanalyzesamples:BadArgumentNumber', ...
        [ '/dbanalyzesamples requires four arguments' ]);
end

% Check input arguments type
if ~ischar(osc_message.data{2})
    error('orchidee:osc:osc_dbanalyzesamples:BadArgumentType', ...
        [ 'Samples DB root must be a string.' ]);
end
if ~ischar(osc_message.data{3})
    error('orchidee:osc:osc_dbanalyzesamples:BadArgumentType', ...
        [ 'XML DB root must be a string.' ]);
end  

% The sound files root directory
soundfiledbroot = osc_message.data{2};

% Already existing XML description files may be found here
xmldbroot = osc_message.data{3};

% Output XML description filse will be written here
xmlexportdir = osc_message.data{3};
        
% Call the batch analysis procedure
analyze_db_samples(soundfiledbroot,xmldbroot,xmlexportdir,handles);