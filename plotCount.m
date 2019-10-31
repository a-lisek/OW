% Funkcja pomocnicza dla funkcji rysujacych. Nanosi na wybrana figure
% informacje o liczbie porownan
% fig - figure na ktorej wypisac text
% count - liczba porownan
function plotCount(fig, count)
        set(0,'CurrentFigure',fig);
        uicontrol('Style', 'text',...
       'String', num2str(count),... %replace something with the text you want
       'Units','normalized',...
       'Position', [0.82 0.6 0.05 0.05],'BackgroundColor', [0.8 0.8 0.8], 'HorizontalAlignment', 'left','FontSize', 10); 
end