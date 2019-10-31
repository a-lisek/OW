% Funkcja wyswietlajaca animacje dla zmodyfikowanego algorytmu naiwnego
% X - obiekty wejsciowe dla algorytmu
% dir - wektor kierunkow optymalizacji kryteriow
function F = renderAnimation_Naive2(X, dir)
    % przygotowanie wykresu
    a = size(X);
    assignin('base', 'toPlot', [1 1 1 1]);
    domin = zeros(1,a(2)); % 0 - zdominowany, 1 - niezdominowany, inicjalizacja 0
    f = figure('Position',[400 150 800 450]);
    set(f, 'Resize', 'off');
    cur_title = ['Zmodyfikowany algorytm naiwny, liczba obiektów= ', num2str(size(X,2)) ];

    pause on
    dominated = [];
    nonDominated = [];
    compared = [];
    % rysuj poczatkowe punkty
    plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
    
    plotStaticText(f);
    isDominating = 1;
    counter = 0;
    frameCounter = 2;
    PSet = [];
    F(1) = getframe(f); % pierwsza klatka animacji
    % rozpoczecie tworzenia kolejnych klatek
    for ii=1:a(2)
        isDominating = 1;
        
       % Porownujemy najpierw ze zbiorem punktow niezdominowanych
       for i = 1:size(PSet,2)
            tmp = 0;
            
            % Utworz klatke z zaznaczonymi punktami porownywanymi
            compared(:,1) = X(:,ii);
            compared(:,2) = PSet(:,i);
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F(frameCounter) = getframe(f);
            frameCounter = frameCounter+1;
            % odczekaj troche, Matlab wykonuje najpierw obliczenia a pozniej akcje graficzne
            % bez pauzy zamrozenie animacji
            pause(0.08); 
            % sprawdzamy czy uzytkownik nie przerwal renderowania
            if evalin('base', 'interruptFlag') == 1
                return;
            end
            
            %sprawdzamy kazde kryterium
            for j = 1:size(X,1)
                counter = counter + 1; % zwieksz licznik porownan
                if X(j, ii)*dir(j) <= PSet(j,i)*dir(j)
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
       
       for i = 1:size(X,2)
            if i == ii
                continue;
            end

            % porownywalismy juz z puntkami niezdominowanymi, pomijamy
            % aby zaoszczedzic obliczenia
            if domin(i) == 1
                continue;
            end
            
            tmp = 0;
            % Utworz klatke z zaznaczonymi punktami porownywanymi
            compared(:,1) = X(:,ii);
            compared(:,2) = X(:,i);
            plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
            F(frameCounter) = getframe(f);
            frameCounter = frameCounter+1;
            % odczekaj troche, Matlab wykonuje najpierw obliczenia a pozniej akcje graficzne
            % bez pauzy zamrozenie animacji
            pause(0.08); 
            % sprawdzamy czy uzytkownik nie przerwal renderowania
            if evalin('base', 'interruptFlag') == 1
                return;
            end
            
            %sprawdzamy kazde kryterium
            for j = 1:size(X,1)
                counter = counter + 1;
                if X(j, ii)*dir(j) <= X(j,i)*dir(j)
                    tmp = tmp + 1;
                else
                    break; % punkt ii posiada lepsze kryterium, nie dominuje go punkt i, mozna przejsc dalej
                end
            end
            
            plotCount(f, counter); % aktualizujemy liczbe porownan na animacji
            if tmp == size(X,1) % punkt ii jest dominowany przez punkt i (kazde kryterium slabsze lub rowne)
                % Utworzenie klatki animacji z punktem oznaczonym jako
                % zdominowany
                dominated = [dominated  X(:,ii)];
                isDominating = 0;
                plotInputs(f,X,compared,nonDominated,dominated, cur_title,0);
                F(frameCounter) = getframe(f);
                frameCounter = frameCounter+1;
                break;
            end
       end
       if isDominating == 1
           % Utworzenie klatki animacji z punktem oznaczonym jako
           % niezdominowany
            nonDominated = [nonDominated X(:,ii)];
            domin(ii) = 1; % oznaczenie punktu jako niezdominowany
            PSet  = [PSet X(:,ii)];
            plotInputs(f,X,compared,nonDominated,dominated, cur_title, 0);
            F(frameCounter) = getframe(f);
            frameCounter = frameCounter+1;
       end
    end

    % rysowanie ostatniej klatki z ostatecznym rozwiazaniem
    plotInputs(f,X,[],nonDominated,dominated, cur_title, 1);
    F(frameCounter) = getframe(f);
end