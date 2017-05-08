function [ corr,corr_add,results] = algo8_1vsO( traindata,testdata,l,b)
traindata01 = [];
traindata02 = [];
traindata12 = [];
testdata01 = [];
testdata02 = [];
testdata12 = [];
class0_n = 109;
class1_n = 117;
class2_n = 74;
results = ones(size(testdata,1),2).*(-1);
results(1:109,1) = 0;
results(110:226,1) = 1;
results(227:300) = 2;

for i = 1:size(traindata,1);
    if(traindata(i,1) ~= 2)
       traindata01 = cat(1,traindata01,traindata(i,:));
    end
    if(traindata(i,1) ~= 1)
       traindata02 = cat(1,traindata02,traindata(i,:));
    end
    if(traindata(i,1) ~= 0)
       traindata12 = cat(1,traindata12,traindata(i,:)); 
    end
end

%change the order of testdata
for i = 1:size(testdata,1);
    if(testdata(i,1) == 0)
       testdata01 = cat(1,testdata01,testdata(i,:));
       testdata02 = cat(1,testdata02,testdata(i,:));
    end
end
for i = 1:size(testdata,1)
    if(testdata(i,1) == 2)
       testdata02 = cat(1,testdata02,testdata(i,:));
       testdata12 = cat(1,testdata12,testdata(i,:));
    end
end
for i = 1:size(testdata,1)
    if(testdata(i,1) == 1)
       testdata01 = cat(1,testdata01,testdata(i,:)); 
       testdata12 = cat(1,testdata12,testdata(i,:)); 
    end
end
 a1 = algo8(traindata01,0,l,b);   %for class 01
 [~,map1] = two_class(testdata01,0,a1,0);  
a2 = algo8(traindata02,0,l,b);   %for class 02
[~,map2] = two_class(testdata02,0,a2,0);
a3 = algo8(traindata12,1,l,b);   %for class 21
[~,map3] = two_class(testdata12,1,a3,0);
correct_count0 = 0;
correct_count1 = 0;
correct_count2 = 0;

for i = 1:class0_n
    if map1(i) == 0 && map2(i) == 0 %belong to 0
        correct_count0 = correct_count0 + 1;
        results(i,2) = 0;
    end
end
corr0 = correct_count0/class0_n;
for i = 1:class1_n
    if map1(class0_n+i) == 1 && map3(class2_n+i) == 0 %belong to 1
        correct_count1 = correct_count1 + 1;
        results(i+class0_n,2) = 1;
    end
end
corr1 = correct_count1/class1_n;
for i = 1:class2_n
    if map2(class0_n+i) == 1 && map3(i) == 1 %belong to 2
        correct_count2 = correct_count2 + 1;
        results(i+class0_n+class1_n,2) = 2;
    end
end
for k = 1:size(testdata,1)
    
end
corr2 = correct_count2/class2_n;
corr_add = (correct_count0+correct_count1+correct_count2)/size(testdata,1);
corr = [corr0 corr1 corr2];

corr_add = corr_add';
corr = corr';
end

