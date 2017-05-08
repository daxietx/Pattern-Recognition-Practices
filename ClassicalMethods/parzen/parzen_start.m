function [ best_h,cor_rate,classrate,result ] = parzen_start( train,classRange,test,flag,h )
best_rate = 0;
best_h = 0;
%% normalization
for i  = 2:size(train,2)
    u = mean(train(:,i));
    v = std(train(:,i));
    if v ~= 0
      for j = 1:size(train,1)
        train(j,i) = (train(j,i) - u)/v;
      end
    else
        train(:,i) = zeros(size(train,1),1);
    end
end

for i = 2:size(test,2)
    u = mean(test(:,i));
    v = std(test(:,i));
    if v ~= 0
     for j = 1:size(test,1)
        test(j,i) = (test(j,i) - u)/v;
     end
    else
        test(:,i) = zeros(size(test,1),1);
    end
end
%% correct rate
result = [];
if flag == 1
    hs = leave1out_h(train);
    for i = 1:size(hs,2)
      h = hs(i);    
        [tempresult,cor_rate] = parzen_classify(train,test,h);
         if cor_rate > best_rate
             best_rate = cor_rate;
             best_h = h;
             result = tempresult;
         end
    end
    cor_rate = best_rate;
elseif flag == 0
    [result,cor_rate] = parzen_classify(train,test,h);
end

%     get the classifier's correct rate for each class
    classNum = classRange(2)-classRange(1)+1;
    correct = 0; % amount of correct classified test samples of the class
    class = 0; % amount of all test samples of the class
    classrate = {};
    for i=1:classNum
        for j=1:size(result,1)
            if result(j,1)==i-(1-classRange(1)) % judge whether the current sample belongs to class i
                class  = class + 1;
                if result(j,1)==result(j,2)
                    correct = correct + 1;
                end
            end
        end
        classrate{i,1} = correct/class;
        correct = 0;
        class = 0;
    end
    classrate = cell2mat(classrate);

end

