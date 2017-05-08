function [data,c] = data_read(data)
%data is the matrix for data and c contained the class info about that.
n = size(data,1);   %number of points
cnt = data(n,1) - data(1,1) + 1;    %cnt is the number of classes  
c = zeros(1,cnt);
for i = 1:n
    c(data(i,1)-data(1,1)+1) = c(data(i,1)-data(1,1)+1) + 1;
end
end

