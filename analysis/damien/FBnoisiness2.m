function [db_s] = FBnoisiness2(db_s,handles)
    
if nargin < 2
    handles = [];
end
    
check_interruption();
server_says(handles,'Computing noisiness',0);    

for k=1:length(db_s.data_s)    
    db_s.data_s(k).melNoisiness = db_s.data_s(k).envnMeanEner/db_s.data_s(k).melMeanEner;
    
    check_interruption();
    server_says(handles,'Computing noisiness',k/length(db_s.data_s));  
end