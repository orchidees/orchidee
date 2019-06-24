function [] = FOwriteLog(fid, message)
    
    stack_s = dbstack;
    fprintf(fid, '%s\n', message);
    disp(['An error occured in ', stack_s(2).name , ' : ' lasterr]);

