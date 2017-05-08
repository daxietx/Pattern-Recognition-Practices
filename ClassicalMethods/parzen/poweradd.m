function y = Poweradd(x1, x2)
   n = size(x1,2);
   y = 0;
   for i = 1:n
       y = y + power((x1(i) - x2(i)),2);
   end
   y = sqrt(y);
end