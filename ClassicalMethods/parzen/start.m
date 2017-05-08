clc, clear all, close all;

train = load('train3.txt');
test = load('test3_s.txt');
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
hs = leave1out_h(train);
for i = 1:size(hs,2)
  h = hs(i);    
    cor_rate = parzen_classify(train,test,h);
    if cor_rate > best_rate
        best_rate = cor_rate;
        best_h = h;
    end
end

