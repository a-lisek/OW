% Funkcja dokonujaca testu algorytmu
% X - dane wejsciowe
% dir - kierunek optymalizacji
% Funkcja wywoluje optymalizacje wykorzystujac algorytm naiwny oraz
% algorytm Luccio&Preparata. Rysowany jest wykres z rozwiazaniem oraz z
% czasem wykonana algorytmu i liczba porownan kryteriow
function benchmark(X, dir)
    %% -- benchmark algorytmu naiwnego
    timer = tic; % rozpocznij pomiar czasu
    [PSet indicator dominated count] = getNonDominated_Naive(X, dir); % wywolanie algorytmu naiwnego
    time = toc(timer); % koniec pomiaru czasu
    
    % rysowanie wynikow testu
    f = figure('Position',[400 150 800 450]);
    set(f, 'Resize', 'off');
    plotResult(f, X, PSet, dominated, count, time, ['Algorytm naiwny, liczba obiektów= ', num2str(size(X,2)) ] );
    
    
    %% -- benchmark algorytmu naiwnego2
    timer = tic; % rozpocznij pomiar czasu
    [PSet indicator dominated count] = getNonDominated_Naive2(X, dir); % wywolanie algorytmu naiwnego
    time = toc(timer); % koniec pomiaru czasu
    
    % rysowanie wynikow testu
    f = figure('Position',[400 150 800 450]);
    set(f, 'Resize', 'off');
    plotResult(f, X, PSet, dominated, count, time, ['Zmodyfikowany algorytm naiwny, liczba obiektów= ', num2str(size(X,2)) ] );
    
    %% -- benchmark algorytmu Luccio
    timer2 = tic; % rozpocznij pomiar czasu
    [PSet indicator dominated count] = KLP(X, dir);
    time2 = toc(timer2); % koniec pomiaru czasu

    % rysowanie wynikow testu
    f = figure('Position',[400 150 800 450]);
    set(f, 'Resize', 'off');
    plotResult(f, X, PSet, dominated, count, time2, ['Luccio&Preparata, liczba obiektów= ', num2str(size(X,2)) ]);

end

% Funkcja pomocnicza, do rysowania wynikow testu
% f - figure na ktorym rysowac wyniki
% X - dane wejsciowe
% nonDominated - zbior punktow niezdominowanych otrzymanych z algorytmu
% dominated - zbior punktow zdomonowanych otrzymanych z algorytmu
% count - liczba porownan kryteriow z algorytmu
% time - czas wykonania
% tit - tytul wykresu
function plotResult(f, X, nonDominated, dominated, count, time, tit)
    plotInputs(f, X, [], nonDominated, dominated, tit,1);
    plotStaticText(f);
    plotCount(f, count);
    plotTime(f, time);

end

% Funkcja pomocnicza do naniesienia obok wykresu wynikow czasowych
% fig - figure na ktory naniesc czas
% time - liczba sekund wykonania algorytmu
function plotTime(fig, time)
        set(0,'CurrentFigure',fig);
        set(fig, 'Resize', 'off');
        uicontrol('Style', 'text',...
       'String', 'Czas wykonania: ',... %replace something with the text you want
       'Units','normalized',...
       'Position', [0.68 0.55 0.15 0.05],'BackgroundColor', [0.8 0.8 0.8], 'HorizontalAlignment', 'left','FontSize', 10); 
   
        set(0,'CurrentFigure',fig);
        uicontrol('Style', 'text',...
       'String', strcat( num2str(time*1000), ' ms'),... %replace something with the text you want
       'Units','normalized',...
       'Position', [0.82 0.55 0.15 0.05],'BackgroundColor', [0.8 0.8 0.8], 'HorizontalAlignment', 'left','FontSize', 10); 
end