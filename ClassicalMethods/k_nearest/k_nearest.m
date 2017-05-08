function [rate,classrate,k,result] = k_nearest(origtrain,classRange,origtest,standard,autosetk,kval)
% This function is a k-nearest neighbor classifier
% PARAMETER:
%   -train : training dataset
%   -classRange : the vector with two elements indicates the start and the
%   end of the class number
%   -test : testing dataset

    classNum = classRange(2)-classRange(1)+1;
    dim = size(origtrain,2) - 1;
    train = origtrain;
    test = origtest;
   
%     standize the dataset 
    if standard==1
        for i=1:size(origtrain,1)
            tmean = mean(origtrain(i,2:dim+1));
            tvar = std(origtrain(i,2:dim+1));
            train(i,2:dim+1) = (train(i,2:dim+1) - tmean) / tvar;       
        end

        for i=1:size(origtest,1)
            tmean = mean(origtest(i,2:dim+1));
            tvar = std(origtest(i,2:dim+1));
            test(i,2:dim+1) = (test(i,2:dim+1) - tmean) / tvar;         
        end   
    else
        for i  = 2:size(origtrain,2)
            u = mean(origtrain(:,i));
            v = std(origtrain(:,i));
            if v ~= 0
              for j = 1:size(origtrain,1)
                train(j,i) = (origtrain(j,i) - u) / v;
              end
            else
                train(:,i) = zeros(size(origtrain,1),1);
            end
        end

        for i = 2:size(origtest,2)
            u = mean(origtest(:,i));
            v = std(origtest(:,i));
            if v ~= 0
             for j = 1:size(origtest,1)
                test(j,i) = (origtest(j,i) - u)/ v;
             end
            else
                test(:,i) = zeros(size(origtest,1),1);
            end
        end    
    end 
%   leave-one-out select k value
    if autosetk==1
        count = {};
        for i=1:10
            correct = 0;
            for j=1:size(train,1)
                one = train(j,2:dim+1);
                class = train(j,1);
                temptrain = train;
                temptrain(j,:) = [];
                dist = pdist2(one,temptrain(:,2:dim+1));
                dist = [temptrain(:,1) dist'];
                dist = sortrows(dist,2);
                tempresult = mode(dist(1:i,1));
                if tempresult == class
                    correct = correct + 1;
                end
            end
            count{i,1} = correct;
        end
        count = cell2mat(count);
        [amount,k] = max(count);
% set k value manully
    else
        k = kval;
    end

    
%   get the distance between the testing sample and training samples
    for i=1:size(test,1)
        temp = pdist2(test(i,2:dim+1),train(:,2:dim+1));  
        temp = [train(:,1) temp'];
        temp = sortrows(temp,2);
        distances{i,1} = temp;
    end    

%   get the most frequent appears class's points near to the testing
%   samples
    for i=1:size(test,1)
        temp = distances{i};
        temp = temp(1:k,1);
        result{i,1} = mode(temp);        
    end
    
   result = cell2mat(result);
   result = [test(:,1) result];
   
%    get the classifier's correct rate
    correct = 0;
    for i=1:size(test,1)
        if result(i,1)==result(i,2)
            correct = correct + 1;
        end           
    end
    rate = correct / size(test,1);

%     get the classifier's correct rate for each class
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