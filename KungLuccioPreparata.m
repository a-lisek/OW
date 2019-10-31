function F = KungLuccioPreparata( X, dir )

    %[data count] = KLP(X,dir);
    a = size(X);
    [input counter] = prepareDataForLuccio(X, dir);
    assignin('base', 'toPlot', [1 1 1 1]);
    f = figure('Position',[400 150 800 450]);
    set(f, 'Resize', 'off');
    cur_title = ['Algorytm Kung-Luccio-Preparata, liczba obiektów= ', num2str(size(X,2)) ];

    pause on
    dominated = [];
    nonDominated = [];
    compared = [];
    % rysuj poczatkowe punkty
    plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
    
    plotStaticText(f);
    F(1) = getframe(f); % pierwsza klatka animacji
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [column,row] = size(X);
    if( column == 2)
        [nodominated, F1, dominated,nonDominated,compared, counter ] = MinimalSet2D(input, row, dir,F,dominated, nonDominated, compared, counter, f);
    else
        [nodominated, F1, dominated,nonDominated,compared, counter ]= MinimalSet(input, 1, row, dir,F,dominated, nonDominated, compared, counter, f, X);
    end
    
    % rysowanie ostatniej klatki z ostatecznym rozwiazaniem
    F = F1;
    plotInputs(f,X,[],nodominated,dominated, cur_title,1);
    F1 = getframe(f);
    F = [F F1];
end

function [data, F_return, dominated_,nonDominated_,compared_, counter_] = MinimalSet(X, first, last, dir,F,dominated, nonDominated, compared, counter, f, XAll)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if(first >= last)
        data = X(:,first);
        F_return = F;
        dominated_ = dominated;
        nonDominated_ = nonDominated;
        compared_ = compared;
        counter_ = counter;
        return;
    end
    m = fix((first + last) / 2);
    [data1, F1, dominated_1,nonDominated_1,compared_1, counter_1] = MinimalSet(X, first, m, dir,F,dominated, nonDominated, compared, counter, f, XAll);
    
	[s, F2, dominated_1,nonDominated_1,compared_1, counter_1] = MinimalSet(X, m + 1, last, dir,F1, dominated_1,nonDominated_1,compared_1, counter_1, f, XAll);
    
    [data, F_return, dominated_,nonDominated_,compared_, counter_] = UnionM(data1, s, dir, F2, dominated_1,nonDominated_1,compared_1, counter_1, f, XAll);
end
function [data, F_return, dominated_,nonDominated_,compared_, counter_] = MinimalSet2D(X, row, dir,F,dominated, nonDominated, compared, counter,f)
    min_ = X(:,1);
    data = [];
    cur_title = ['Algorytm Kung-Luccio-Preparata, liczba obiektów= ', num2str(size(X,2)) ];
    for i =2 : row
        counter = counter +1;
        % Utworz klatke z zaznaczonymi punktami porownywanymi
            compared(:,1) = min_;
            compared(:,2) = X(:,i);
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F = [F getframe(f)];
            % odczekaj troche, Matlab wykonuje najpierw obliczenia a pozniej akcje graficzne
            % bez pauzy zamrozenie animacji
            pause(0.01); 
            % sprawdzamy czy uzytkownik nie przerwal renderowania
            if evalin('base', 'interruptFlag') == 1
                return;
            end
            plotCount(f, counter);
        if(min_(2)*dir(2) < X(2,i)*dir(2))
            min_ = X(:,i);
            nonDominated = [nonDominated, min_];
            
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F = [F getframe(f)];
        else
            dominated = [dominated X(:,i)];
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F = [F getframe(f)];
        end
    end
    
    %data = [data, min];
    F_return = F;
    dominated_ = dominated;
    nonDominated_ = nonDominated;
    data = nonDominated;
    compared_ = compared;
    counter_ = counter;
end

function [data, F_ret, dominated_,nonDominated_,compared_, counter_, frameCounter_] = UnionM(r,s, dir,F,dominated, nonDominated, compared, counter, f, X)
    [column,row] = size(s);
    
    %isdominated = true;
    %%%%%%%%%%%%%
    cur_title = ['Algorytm Kung-Luccio-Preparata, liczba obiektów= ', num2str(size(X,2)) ];
    %%%%%%%%%%%%%
    for is = 1 : row
       isdominated = false;
       jr = 1;
       [~,rRow] = size(r);
       while(jr <= rRow && isdominated == false)
           
           % Utworz klatke z zaznaczonymi punktami porownywanymi
            compared(:,1) = s(:,is);
            compared(:,2) = r(:,jr);
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F = [F getframe(f)];
            % odczekaj troche, Matlab wykonuje najpierw obliczenia a pozniej akcje graficzne
            % bez pauzy zamrozenie animacji
            pause(0.01); 
            % sprawdzamy czy uzytkownik nie przerwal renderowania
            if evalin('base', 'interruptFlag') == 1
                return;
            end
           
            counter = counter + 1;
           if true == Dominates(2, r(:,jr),s(:,is), dir)
               isdominated = true;
               
               dominated = [dominated  r(:,jr)];
                plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
                F = [F getframe(f)];
               
           else if true == Dominates(1,s(:,is), r(:,jr), dir)
                   dominated = [dominated  s(:,is)];
                    plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
                    F = [F getframe(f)];
                    
                   %isdominated = true;
                   flag = true;
                   for tmp = 1:rRow
                        if(r(:,tmp)==s(:,is))
                            r(:,tmp) = [];
                            [~,rRow] = size(r);
                            tmp = tmp - 1;
                            flag = false;
                            %isdominated = false;
                        end
                   end  
                   if flag == true
                       jr = jr + 1;
                   end

                   %tmp = find(ismember(r(:,:),s(:,is)),1,'first');
               else
                   jr = jr + 1;
               end
           end
           plotCount(f, counter);
       end
       if(isdominated == false)
           r = [r, s(:,is)];
           nonDominated = r;%[nonDominated s(:,is)];
           plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
           F = [F getframe(f)];
          % break;
       else
            dominated = [dominated s(:,is)];
       end
    end
    data = r;
    F_ret = F;
    dominated_ = dominated;
    nonDominated_ = nonDominated;
    compared_ = compared;
    counter_ = counter;
end

function isDominates = Dominates(first, x, y, dir)
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







