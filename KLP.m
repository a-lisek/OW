function [ PSet indicator dominated count] = KLP( x, dir )
    indicator = [];
    [column,row] = size(x);
    [input sort_count] = prepareDataForLuccio(x, dir);
    
    if( column == 2)
        [ PSet dominated count] = MinimalSet2D_Base(input, row, dir, sort_count, []);
        return;
    else
        [ PSet dominated count] = MinimalSet_Base(input, 1, row, dir,sort_count, []);
    end

    
end
function [data dominated_ count_] = MinimalSet_Base(X, first, last, dir, count, dominated)
    [column,row] = size(X);
    
    if(first >= last)
        data = X(:,first);
        dominated_ = dominated;
        count_ = count;
        return;
    end
    m = fix((first + last) / 2);
    [data1 dominated1_ count1_] = MinimalSet_Base(X, first, m, dir, count, dominated);
    
	[s dominated1_ count1_] = MinimalSet_Base(X, m + 1, last, dir, count1_, dominated1_);
    
    [data dominated_ count_] = UnionM_Base(data1, s, dir, count1_, dominated1_);
end
function [data dominated_ count_] = MinimalSet2D_Base(X, row, dir,count, dominated)
    min_ = X(:,1);
    data = min_;
    count_ = count;
    for(i =2 : row)
        count_ = count_ + 1;
        if(min_(2)*dir(2) < X(2,i)*dir(2))
            min_ = X(:,i);
            data = [data min_];
        else
           dominated = [dominated X(:,i)];
        end
    end
    dominated_ = dominated;
    %data = [data, min];
end

function [data dominated_ count_] = UnionM_Base(r,s, dir,count, dominated)
    [column,row] = size(s);
    
    isdominated = false;
    
    for(is = 1 : row)
       isdominated = false;
       jr = 1;
       [rColumn,rRow] = size(r);
       while(jr <= rRow && isdominated == false)
           count = count + 1;
           if true == Dominates_Base(2, r(:,jr),s(:,is), dir)
               isdominated = true;
               dominated = [dominated r(:,jr)];
           else if true == Dominates_Base(1,s(:,is), r(:,jr), dir)
                   %isdominated = true;
                   flag = 0;
                   for tmp = 1:rRow
                        if(r(:,tmp)==s(:,is))
                            r(:,tmp) = [];
                            [~,rRow] = size(r);
                            %isdominated = false;
                            dominated = [dominated s(:,is)];
                            flag = 1;
                            if(tmp >= rRow)
                                break;
                            end          
                            tmp = tmp - 1;
                        end
                   end       
                   if flag == 0
                      jr = jr + 1;
                   end
                   %tmp = find(ismember(r(:,:),s(:,is)),1,'first');
               else
                   jr = jr + 1;
               end
           end
       end
       if(isdominated == false)
           r = [r, s(:,is)];
          % break;
       else
           dominated = [dominated s(:,is)];
       end
       
    end
    data = r;
    dominated_ = dominated;
    count_ = count;
end

function isDominates = Dominates_Base(first, x, y, dir)
    len = length(x);
    counter = 1;
    for i=first:len
        if(x(i)*dir(i) < y(i)*dir(i))
            isDominates = false;
            counter = counter + 1;
            return;
        else if(x(i)==y(i))
                counter = counter + 1;
            end
        end
    end
    if counter == len
        isDominates = false;
        return;
    else 
        isDominates = true;
        return;
    end
    
end



