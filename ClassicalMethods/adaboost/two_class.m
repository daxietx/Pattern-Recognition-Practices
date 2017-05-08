function [corr,class_map] = two_class(testdata,class,a,flag,c_l)
    testdata = testdata';
    fnt = size(testdata,1);  %feature numbers
    snt = size(testdata,2);  %sample numbers
    CorrectCount = 0;
    class_n = 0;
    class_map = ones(1,size(testdata,2));
   
    for i = 1:snt
          %testdata(2:fnt,i) = zscore(testdata(2:fnt,i));  %standalize the data
           if testdata(1,i) == class
              class_n = class_n + 1;
           end
           if flag == 0 
             if(a*testdata(2:fnt,i) > 1 && testdata(1,i) == class)
              CorrectCount = CorrectCount + 1; 
             end
             if a*testdata(2:fnt,i) > 1
               class_map(i) = 0; %mark the points belong to class
             end
           elseif flag == 1 %one against rest
               g = [];
               for j = 1:size(a,1)
                   g = cat(2,g,a(j,:)*testdata(2:fnt,i));
               end
               if(find(g == max(g))-c_l+1 == class && testdata(1,i) == class)
               CorrectCount = CorrectCount + 1; 
               end
               if find(g == max(g))-1 == class 
                  class_map(i) = 0; 
               end
           end
    end
corr = CorrectCount/class_n;
return
end

