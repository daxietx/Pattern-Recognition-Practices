function [ corr_p2,corr_add, results] = algo8_1vsR( traindata,testdata,c_l,c_h,l,b)
class=[];
corr_p2 = [];
results = ones(size(testdata,1),2).*(-1);
for i = 1:c_h - c_l + 1
    class = cat(2,class,c_l+i-1);
end

results(:,1)=testdata(:,1);
    
a = [];
for i = 1:size(class,2)
  a = cat(1,a,algo8(traindata,class(i),l,b));   %for class i  
end
%testdata = testdata(:,2:size(testdata,2));
%[result,rate,amrate]= one_rest(a,testdata,[c_l,c_h]);
%[result,rate] = one_other(a,testdata,[c_l,c_h]);
for i = 1:size(class,2)
  [corr_n,map] = two_class(testdata,class(i),a(i,:),0,c_l);
  for j = 1:size(map,2)
      if map(j) == 0
          if results(j,2) == 0
              results(j,2) = -1;
          else
              results(j,2) = class(i);
          end   
      end
  end
  corr_p2 = cat(2,corr_p2,corr_n);
end
tr = 0;
for k = 1:size(results,1)
    if results(k,1) == results(k,2)
        tr = tr + 1;
    end
end
corr_add = tr/size(testdata,1);

corr_add = corr_add';
corr_p2 = corr_p2';
end

