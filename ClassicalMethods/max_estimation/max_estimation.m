function [classrate,means,covs,g,result,rate] = max_estimation(train,classRange,test,beta)
% This function is a Bayesian classifier based on maximum-likelihood
% estimation
% PARAMETERS:
%   -train : training dataset
%   -classRange : the vector with two elements indicates the start and the
%   end of the class number
%   -test : testing dataset

    classNum = classRange(2)-classRange(1)+1;
    classIdx = {};
    dim = size(train,2) - 1;

%   get the label range of classes
    c=1;
    label = classRange(1);
    for i=1:classNum
        classIdx{i,1} = c;      
        for j=c:size(train,1)
            if(train(j,1)~=label)
                break;
            end
            c = c+1;           
        end
        label = label + 1;
        classIdx{i,2} = c-1;
    end 

%   class prior probability
    for i=1:classNum
        priorProb{i,1} = (classIdx{i,2} - classIdx{i,1} + 1) / size(train,1);
    end
%   maximum likelihood estamition of class means
    for i=1:classNum
        means{i,1} = mean(train(classIdx{i,1}:classIdx{i,2},2:size(train,2)));
    end
    means = cell2mat(means);
    
%  maximum likelihood estimation of class covariances
    for i=1:classNum
        temp = zeros(dim);
        for j=classIdx{i,1}:classIdx{i,2}
            diff = train(j,2:size(train,2))-means(i,:);
            temp = temp + diff' * diff;
        end
        covs{i,1} = temp / (classIdx{i,2} - classIdx{i,1});
    end   
%   construct classifiers
    for i=1:classNum
%         beta = 0.1;
        I = eye(dim);
        covs{i,1} = covs{i,1} * (1-beta) + I * beta;        
        inverse = pinv(covs{i,1});
        
        Wi{i,1} = -0.5 * inverse;
        wi{i,1} = inverse * means(i,:)';
        wio{i,1} = -0.5 * means(i,:) * pinv(covs{i,1}) * means(i,:)' - 0.5 * log(det(covs{i,1})) + log(priorProb{i,1});
    end
    
%   classify the test data
    for i=1:size(test,1)
        for j=1:classNum
            sample = test(i,2:size(test,2));
            g{i,j} = sample * Wi{j,1} * sample' + wi{j,1}' * sample' + wio{j,1}; %calculate the discriminant function value of three classes
        end
    end   
    g = cell2mat(g);
    for i=1:size(test,1)       
        [~,result] = max(g,[],2);
    end
    result = result - (1-classRange(1));
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




