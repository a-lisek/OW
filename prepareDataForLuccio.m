
% Algorytm Luccio Prepata w pierwszym kroku dokonuje sortowania po
% pierwszym kryterium. Funkcja sprawdza czy punkty sa posortowane, jesli
% nie dokonuje sortowania
function [X count] = prepareDataForLuccio(input, dir)
    count = 0;
    needSort = 0;
    X = input;
    for i=1:size(input,2)-1
        if X(1,i)*dir(1) < X(1,i+1)*dir(1)
            needSort = 1;
            break;
        end
        count = count +1;
    end
    
    if(needSort==1)
        [X tmp] = sortInput(input, dir(1));
        count = count + tmp;
    end
end

function [X count] = sortInput(input, dir)
    X = input;
    count = 0;

    pointsCount =  size(input,2);
    pivot_ind = uint8(floor(pointsCount/2));
    Left = [];
    Right = [];
    j = 1;
    k = 1;

   if(pointsCount<2)
      X = input;
    else
      pivot = input(:,pivot_ind);
      for i=1:pointsCount
        if(i~=pivot_ind)
          if(input(1,i) * dir > pivot(1)*dir)
            Left(:,j) = input(:,i);
            j = j+1;
          else
            Right(:,k) = input(:,i);
            k = k+1;
          end
          count = count +1;
        end
      end
      
      [Left cl] = sortInput(Left, dir);
      [Right cr] = sortInput(Right, dir);
      count = count + cl + cr;
      X = [Left pivot Right];
   end
end
