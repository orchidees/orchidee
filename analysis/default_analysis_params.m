
function [params_values,params_class,params_range] = default_analysis_params()

% DEFAULT_ANALYSIS_PARAMS - Default parameters for taret analysis:
% Default values, expected types and value ranges.
%
% Usage: [params_values,params_class,params_range] = default_analysis_params()
% 

% Default values
params_values.t1 = 0.3333; % analysis segment start
params_values.t2 = 0.6667; % analysis segment end
params_values.fmin = 50; % frequency resolution (Hz)
params_values.npartials = 25; % number of partials to extract 
params_values.delta = 0.015; % threshold for mapping target
                             % partials and partials of database sounds
params_values.autodelta = 1; % If true, delta is infered from the
                             % microtonic resolution of the orchestra
% Types
params_class.t1 = 'double';                     
params_class.t2 = 'double';                     
params_class.fmin = 'double';                       
params_class.npartials = 'double';                  
params_class.delta = 'double';                   
params_class.autodelta = 'double';                   

% Ranges
params_range.t1 = [0 60000];                     
params_range.t2 = [0 60000];                     
params_range.fmin = [0 10000];                       
params_range.npartials = [0 100];                  
params_range.delta = [0 0.2];                   
params_range.autodelta = { 0 1 };                   
   