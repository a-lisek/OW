% Funkcja rysujaca wykres w zaleznosci od ilosci kryteriow. Przy jej uzyciu
% funkcje animujace dokonuja animacji algorytmow.
%
% fig - uchwyt do figure
% input - dane wejscowe, wygenerowane punkty
% compared - punkty aktualnie porownywane
% nonDominated - punkty niezdominowane
% dominated - punkty zdominowane
% tit - tytul wykresu
function plotInputs(fig, input, compared, nonDominated, dominated, tit, last)
    % ustaw fig jako aktywna
    set(0,'CurrentFigure',fig);
    crit = size(input,1);
    labels = evalin('base','labels');
    % 2 kryteria - wykres 2d
    if crit == 2
        hold off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5]);
        
        % rysuj punkty obecnie porownywane
        if(size(compared,1)>0 )
            plot(compared(1,:), compared(2, :), 's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0],...
                'MarkerSize',11) ;
        else
            plot(-1000, -1000, 's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0],...
                'MarkerSize',11) ;
        end
        
        hold on
        % rysuj wszystkie punkty
        if last == 0
            plot(input(1,:), input(2, :), '.', 'LineWidth',12,...
                    'MarkerEdgeColor','g',...
                    'MarkerFaceColor',[1 .1 .0],...
                    'MarkerSize',14) ;
        else
            plot(-10000, -10000, '.', 'LineWidth',12,...
                    'MarkerEdgeColor','g',...
                    'MarkerFaceColor',[1 .1 .0],...
                    'MarkerSize',14) ;
        end
        hold on

        % rysuj punkty niezdominowane
        if(size(nonDominated,1) >0)
            plot(nonDominated(1,:), nonDominated(2, :),  'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c',...
                'MarkerSize',10) ;
        else
            plot(-1000, -1000 ,  'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c',...
                'MarkerSize',10) ;
        end

        % rysuj punkty zdominowane
        if (size(dominated,1) >0 )
            plot(dominated(1,:), dominated(2, :), 'o',...
                'LineWidth',1,...
                'MarkerFaceColor','b',...
                'MarkerSize',8);
        else
            plot(-1000, -1000, 'o',...
                'LineWidth',1,...
                'MarkerFaceColor','b',...
                'MarkerSize',8);
        end

        % dodaj legende i ustaw osie
        legend('Punkty  porownywane', 'Zbior punktow','Zbior niezdominowany','Punkty zdominowane', 'Location','NorthEastOutside');
        xlabel(labels(1));
        ylabel(labels(2));
        hold off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5]);
    % 3 kryteria - wykres 3d
    elseif crit == 3 
        hold off
        box off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5 min(input(3,:))-0.5 max(input(3,:))+0.5]);
        
        % rysuj punkty obecnie porownywane
        if(size(compared,1)>0 )
            plot3(compared(1,:), compared(2, :), compared(3, :), 's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0],...
                'MarkerSize',11) ;
        else
            plot3(-1000, -1000 , -1000,  's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0],...
                'MarkerSize',11) ;
        
        end
        
        hold on
        box on
        % rysuj wszystkie punkty
        if last == 0
            plot3 (input(1,:), input(2, :), input(3,:), '.', 'LineWidth',12,...
                    'MarkerEdgeColor','g',...
                    'MarkerFaceColor',[1 .1 .0],...
                    'MarkerSize',14) ;
        else
            plot3 (-10000, -10000,-10000, '.', 'LineWidth',12,...
                    'MarkerEdgeColor','g',...
                    'MarkerFaceColor',[1 .1 .0],...
                    'MarkerSize',14) ;
        end
        hold on
        box on
      

        % rysuj punkty niezdominowane
        if(size(nonDominated,1) >0)
            plot3(nonDominated(1,:), nonDominated(2, :), nonDominated(3, :), 'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c',...
                'MarkerSize',10) ;
        else
            plot3(-1000, -1000 , -1000, 'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c',...
                'MarkerSize',10) ;
        end
        hold on
        % rysuj punkty zdominowane
        if (size(dominated,1) >0 )
            plot3(dominated(1,:), dominated(2, :), dominated(3, :), 'o',...
                'LineWidth',1,...
                'MarkerFaceColor','b',...
                'MarkerSize',8);
        else
            plot3(-1000, -1000, -1000, 'o',...
                'LineWidth',1,...
                'MarkerFaceColor','b',...
                'MarkerSize',8);
        end

        % dodaj legende i ustaw osie
        legend('Punkty  porownywane', 'Zbior punktow','Zbior niezdominowany','Punkty zdominowane', 'Location','NorthEastOutside');
        xlabel(labels(1));
        ylabel(labels(2));
        zlabel(labels(3));
        hold off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5 min(input(3,:))-0.5 max(input(3,:))+0.5]);

    
    % 4 kryteria - wykres 3d z kolorami    
    elseif crit == 4
        mrk_size = 150;

        hold off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5 min(input(3,:))-0.5 max(input(3,:))+0.5]);
        
        % rysuj punkty obecnie porownywane
        if(size(compared,1)>0 )
            s=scatter3(compared(1,:), compared(2, :), compared(3, :), mrk_size, compared(4, :)', 's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0]) ;
            row=dataTipTextRow('W',compared(4,:));
            s.DataTipTemplate.DataTipRows(end+1)=row;
        else
            s=scatter3(-1000, -1000 , -1000, mrk_size, 0, 's', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[1 .1 .0]) ;
        
        end
        
        hold on
        box on
        
        % rysuj wszystkie punkty

        s=scatter3(input(1,:), input(2, :), input(3,:),mrk_size*2,input(4,:), '.', 'LineWidth',12) ;
        row=dataTipTextRow('W',input(4,:));
        s.DataTipTemplate.DataTipRows(end+1)=row;


        hold on
        box on
        
        % rysuj wszystkie punkty
%         scatter3(input(1,:), input(2, :), input(3,:),mrk_size,input(4,:)', '.');
%         
%         hold on
% 
%         % rysuj punkty obecnie porownywane
%         if(size(compared,1)>0 )
%             scatter3(compared(1,:), compared(2, :), compared(3, :), mrk_size, compared(4, :)', 's') 
%         else
%             scatter3(-1000, -1000 , -1000, mrk_size, 0, 's') 
%         end

        % rysuj punkty niezdominowane
        if(size(nonDominated,1) >0)
            s=scatter3(nonDominated(1,:), nonDominated(2, :), nonDominated(3, :), mrk_size, nonDominated(4, :)',  'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c') ;
            row=dataTipTextRow('W',nonDominated(4,:));
            s.DataTipTemplate.DataTipRows(end+1)=row;
        else
            s=scatter3(-1000, -1000 , -1000, mrk_size, 0,  'd', 'LineWidth',1,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','c') ;
        end

        % rysuj punkty zdominowane
        if (size(dominated,1) >0 )
            s=scatter3(dominated(1,:), dominated(2, :), dominated(3, :), mrk_size*0.8, dominated(4, :)', 'o','MarkerFaceColor','b');
            row=dataTipTextRow('W',dominated(4,:));
            s.DataTipTemplate.DataTipRows(end+1)=row;
        else
            s=scatter3(-1000, -1000 , -1000, mrk_size*0.8, 'o','MarkerFaceColor','b');
        end

        % dodaj legende i ustaw osie
        legend('Punkty  porownywane', 'Zbior punktow','Zbior niezdominowany','Punkty zdominowane', 'Location','NorthEastOutside');
        xlabel(labels(1));
        ylabel(labels(2));
        zlabel(labels(3));

        uicontrol('Style', 'text',...
       'String', labels(4),...
       'Units','normalized',...
       'Position', [0.68 0.3 0.16 0.05], 'BackgroundColor', [0.8 0.8 0.8],'HorizontalAlignment', 'left','FontSize', 10); 
        
        
        hold off
        axis([ min(input(1,:))-0.5 max(input(1,:))+0.5 min(input(2,:))-0.5 max(input(2,:))+0.5 min(input(3,:))-0.5 max(input(3,:))+0.5]);
        colorbar
        
        
    end
    title(tit);
end

