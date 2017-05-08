function [ result,cor_rate ] = parzen_classify( train, test, h )
[train,c] = data_read(train);
class = zeros(1,size(test,1));
err = 0;

result = {};
for j = 1:size(test,1)
    max = 0;
    for i = 1:size(c,2)
       P = c(i)/size(train,1);                 %prior get from training data
       if i == 1
        xi = train(1:c(1), : );
       else
           curs = sum(c(1:i-1))+1;
           xi = train(curs:curs+c(i)-1, : );
       end
       p = Parzen(xi, test(j,:), h);    
       gx = p*P;
       if(gx > max)
         max = gx;
         class(1,j) = i;
         result{j,1} = test(j,1);
         result{j,2} = class(1,j); 
       end
    end
    if class(1,j) ~= test(j,1)
        err = err + 1;
    end
end
cor_rate = (size(test,1)-err)/size(test,1);

result = cell2mat(result);

end

