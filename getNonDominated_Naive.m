% Funkcja wykorzystujaca algorytm naiwny do odnalezienia punktow
% niezdominowanych
% Zwracane:
% PSet - zbior punktow niezdominowanych (obiektow)
% indicator - wektor okreslajacy wlasciwosc punktow - jesli w wektorze na
% pozycji i wystepuje 1 oznacza to ze punkt wejsciowy o numerze i jest
% niezdominowany, jesli 0 to punkt jest zdominowany
% Wejscia:
% X - zbior wejsciowy
% dir - wektor wskazujacy kierunek optymalizacji kryterium, 
% -1 - minimalizacja, 1 - maksymalizacja
function [PSet indicator dominated count] = getNonDominated_Naive(X, dir)
    a = size(X);
    domin = zeros(1,a(2)); % 0 - zdominowany, 1 - niezdominowany, inicjalizacja 0
    
    % przygotowanie zmiennych pomocniczych
    dominated = [];
    isDominating = 1;
    counter = 0;
    for ii=1:a(2)
        isDominating = 1;
       for i = 1:size(X,2)
            if i == ii % nie porownujemy punktu z samym soba
                continue;
            end
            tmp = 0;
            %sprawdzamy kazde kryterium
            for j = 1:size(X,1)
                counter = counter + 1; % zwieksz licznik porownan
                if X(j, ii)*dir(j) <= X(j,i)*dir(j)
                    tmp = tmp + 1;
                else
                    break; % punkt ii posiada lepsze kryterium, nie dominuje go punkt i, mozna przejsc dalej
                end
                
            end

            if tmp == size(X,1) % punkt ii jest dominowany przez punkt i (kazde kryterium slabsze lub rowne)
                dominated = [dominated  X(:,ii)];
                isDominating = 0;
                break;
            end
       end
       
       if isDominating == 1 % punkt ii nie byl zdominowany przez zaden punkt, dodanie do listy niezdominowanej
            domin(ii) = 1; % oznaczenie punktu jako niezdominowany
       end
    end
    
    % ustawienie wyniku
    count = counter;
    indicator = domin;
    
    % przypisanie punktow niezdominowanych do zwracanego zbioru
    PSet = zeros(a(1), sum(domin));
    j = 1;  
    for i = 1:a(2)
        if indicator(i) == 1
            PSet(:,j) = X(:,i);
            j = j+1;
        end
    end
end