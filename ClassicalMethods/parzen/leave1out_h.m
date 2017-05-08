function  h  = leave1out_h( data )

max = 0;
h = [];
for hh = 0.1 : 0.1 :1
    count  = 0;
    for i = 1:size(data,1)
        if i == 1
          test = data(1,:);
          train = data(2:end,:);
        else
          test = data(i,:);
          train = cat(1, data(1:i-1,:),data(i+1:end,:));
        end
        cor_rate = parzen_classify(train, test, hh);
        if cor_rate == 1
           count = count + 1; 
        end    
    end
    
    rate = count/size(data,1);
   
    if rate >=  max
        max = rate;
        h = cat(2,h,hh);
    end
end
end

