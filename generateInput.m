% Funkcja zwraca losowy zbior punktow wejsciowych (zbior kryteriow), punkty maja
% wartosci calkowito-liczbowe. Nie wystepuja duplikaty punktow, tzn. jesli
% zakresy sa zbyt male by wygenerowac unikalne punkty zostanie zwrocona
% mniejsza ilosc.
% dimensions - liczba kryteriow
% min, max - wygenerowane wspolrzedne z zakresu [min, max]
% count - liczba utworzonych punktow (obiektow)
% wywolanie generateInput(-5, 5, 3, 25, 1) zwroci 25 obiektow o 3
% wspolrzednych z zakresu [-5, 5], posortowanych wzglêdem pierwszego
% kryterium
function X=generateInput( min, max, dimensions, count, to_sort)
        gen = randi([min max], dimensions, count * 2 )';
        [C, ia, ic] = unique(gen,'rows');
        ia = sort(ia);
        tmp_size = size(ia,1);
        if( size(ia,1) > count)
            tmp_size=count;
        end
        
        X = zeros(dimensions, tmp_size);

        
        for i=1:tmp_size
            X(:,i) = gen(ia(i),:)';
        end
        if(to_sort == 1)
            X = sortrows(X')';
        end
end