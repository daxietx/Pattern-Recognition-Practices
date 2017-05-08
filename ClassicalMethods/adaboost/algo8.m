function a = algo8(traindata,class,l,b)

traindata = traindata';
fn = size(traindata,1);  %feature numbers
sn = size(traindata,2);  %sample numbers
YK = [];
a = zeros(1,fn-1);
% l = 0.1;
% b = 1;
count = 0;

    for i = 1:sn
       % traindata(2:fn,i) = zscore(traindata(2:fn,i));  %standalize the data
         if traindata(1,i) == class
             traindata(1,i) = 1;
             traindata(2:fn,i) = traindata(2:fn,i).*1;
         else
             traindata (1,i) = -1;
             traindata(2:fn,i) = traindata(2:fn,i).*(-1);  
         end     
    end
    
    while(1)
        middle = [];
       for i=1:sn
           middle = cat(2,middle,(a)*traindata(2:fn,i));
         if (a)*traindata(2:fn,i)< b
            YK = cat(2,YK,traindata(2:fn,i));
         end
       end

       if(size(YK,2)< 15||count>50000)
          break;
       end

       v = zeros(fn-1,1);
       for j = 1:size(YK,2)   %YK's sample numbers
         v = v + ((b - (a*YK(:,j)))/(sum(YK(:,j).^2)))*YK(:,j);  
       end
       a = a + l.*(v');
       YK = [];
       count = count + 1;
    end
    return
end

