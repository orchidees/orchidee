function [] = FOcloseLogFile(fid)
    
    
if fid ~= -1
    fclose(fid);
end
