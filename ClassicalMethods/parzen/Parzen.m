function p = Parzen( xi, x, h)
% xi is the training data matrix
% x is present data
% h is the present window width
% in this case, we choose Gaussian function as window function

n = size(xi,1); %n is the size of the training set
d = size(xi,2)-1; % d is the dimension of the training set
p = 0;

%% calcalate p while assuming it belongs to class i
for i = 1:n
    p = (1/power(h,d))*(1/sqrt(2*pi))*exp(-0.5*power((poweradd(x(2:end),xi(i,2:end))/h),2))+ p;
end

p = p/n;

end