% Funkcja pomocnicza do zapisu animacji. Zapisuje stworzona animacje do
% pliku o wybranej nazwie.
% movie - utworzona animacja
% fileName - nazwa pliku
function saveMovie(movie, fileName)
    writerObj = VideoWriter(fileName,'Motion JPEG AVI');
    set(writerObj, 'FrameRate', 2);
    open(writerObj);
    writeVideo(writerObj,movie);
    close(writerObj);
end