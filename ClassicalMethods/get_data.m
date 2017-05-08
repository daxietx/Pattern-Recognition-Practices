function [data] = get_data(file,d)
% This function reads data from txt files and stores into matrixs
% PARAMETER:
%   -file : file path and name
%   -d : the number of file dimensions

    fr = fopen(file);
    data = {};
    i = 1;
    while ~feof(fr)
        line = fgetl(fr);
        if(~isempty(line))
            [token,rem] = strtok(line);
            data{i,1} = str2num(token);
            for j=2:1:d
                [token,rem] = strtok(rem);
                data{i,j} = str2num(token);
            end   
            i = i+1;
        end
    end
    fclose(fr);
    data = cell2mat(data);
end
