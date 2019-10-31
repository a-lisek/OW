% Plik zawierajacy funkcje tworzace GUI, czesc funkcji wygenerowana przy
% uzyciu polecenia guide

function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 22-Sep-2013 21:50:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


%% -------------------------------------------EDYCJA----------------------------------------------
% --- Executes on button press in addCriteriaButton.
function addCriteriaButton_Callback(hObject, eventdata, handles)
    data = get(handles.criteriaTable, 'Data');
    rows = size(data,1) + 1;
    data(rows,:) = {['Kryterium ',int2str(rows)] 'Min'};
    set(handles.criteriaTable,'Data',data);
    assignin('base','criteriaData',data);
    refreshGuiTable(handles);
    set(handles.sortNumber,'String', int2str((1:rows)'));
    set(handles.sortNumber,'Value', 1);
    assignin('base','labels',getLabels(handles));


% --- Executes on button press in deleteCriteriaButton.
function deleteCriteriaButton_Callback(hObject, eventdata, handles)
    data = get(handles.criteriaTable, 'Data');
    rows = size(data,1) -1;
    if ( rows <=1)
        return
    end
    data = data(1:rows,:);
    set(handles.criteriaTable,'Data',data);
    assignin('base','criteriaData',data);
    refreshGuiTable(handles);
    set(handles.sortNumber,'String', int2str((1:rows)'));
    set(handles.sortNumber,'Value', 1);
    assignin('base','labels',getLabels(handles));
    
    
% --- Executes on button press in addValueButton.
function addValueButton_Callback(hObject, eventdata, handles)
    data = get(handles.guiTable, 'Data');
    [rows cols] = size(data);
    rows = rows +1;
    data(rows,:) = zeros(1,cols);
    set(handles.guiTable,'Data',data);
    assignin('base','input',data');


% --- Executes on button press in deleteValueButton.
function deleteValueButton_Callback(hObject, eventdata, handles)
    data = get(handles.guiTable, 'Data');
    [rows cols] = size(data);
    rows = rows-1;
    if ( rows <=0)
        return
    end
    data = data(1:rows,:);
    set(handles.guiTable,'Data',data);
    assignin('base','input',data');


% --- Executes when entered data in editable cell(s) in criteriaTable.
function criteriaTable_CellEditCallback(hObject, eventdata, handles)
    refreshGuiTable(handles);

%% -------------------------------------------AKCJE----------------------------------------------
% Wcisniecie przycisku Generuj
% Pobranie danych z innych elementow GUI, wywolanie generatora i
% przypisanie wartosci do tabeli w GUI
function generateButton_Callback(hObject, eventdata, handles)
    % pobranie danych

    [count status3] = str2num( get(handles.count, 'String') );
    if( status3 == 0 || count <= 0)
        msgbox( 'Wartoœæ w polu liczba obiektów musi byæ liczb¹ ca³kowit¹, dodatni¹.','Nieprawid³owa wartoœæ','error');
        return;
    end
    
    
    selected = get(handles.distributions, 'Value');
    if selected == 1 % jednostajny
        %weryfikacja poprawnosci wprowadzonych danych
        [max status1] = str2num ( get(handles.guiRangeMax, 'String') );
        [min status2] = str2num( get(handles.guiRangeMin, 'String') );
        if( status1 ==0 || status2 == 0)
            msgbox( 'B³êdna wartoœæ zakresu. Wartoœæ zakresu min lub max powinna byæ liczb¹ ca³kowit¹.','Nieprawid³owa wartoœæ','error');
            return;
        end
        if (max <= min)
            msgbox( 'Wartoœæ zakresu maksymalnego musi byæ wiêksza ni¿ wartoœæ min.','Nieprawid³owa wartoœæ','error');
            return;
        end
        input = random('Uniform',min,max, size(get(handles.criteriaTable,'Data'),1), count);
    elseif selected == 2 % Gaussa
        [max status1] = str2num ( get(handles.guiRangeMax, 'String') );
        [min status2] = str2num( get(handles.guiRangeMin, 'String') );
        if( status1 ==0 || status2 == 0)
            msgbox( 'B³êdna wartoœæ argumentu. Wartoœæ argumentu generatora powinna byæ liczb¹.','Nieprawid³owa wartoœæ','error');
            return;
        end
        if (max < 0)
            msgbox( 'Wartoœæ odchylenia nie mo¿e byæ mniejsza ni¿ 0','Nieprawid³owa wartoœæ','error');
            return;
        end
        input = random('Normal',min,max, size(get(handles.criteriaTable,'Data'),1), count);
    elseif selected == 3 % Poissona
        
        [min status1] = str2num( get(handles.guiRangeMin, 'String') );
        if( status1 ==0)
            msgbox( 'B³êdna wartoœæ argumentu. Wartoœæ argumentu generatora powinna byæ liczb¹.','Nieprawid³owa wartoœæ','error');
            return;
        end
        if (min < 0)
            msgbox( 'Wartoœæ œredniej nie mo¿e byæ mniejsza od zera. Zalecana jest du¿a wartoœæ.','Nieprawid³owa wartoœæ','error');
            return;
        end
        input = random('Poisson',min, size(get(handles.criteriaTable,'Data'),1), count);

    elseif selected == 4 % Ekspotencjalny
        [min status1] = str2num( get(handles.guiRangeMin, 'String') );
        if( status1 ==0)
            msgbox( 'B³êdna wartoœæ argumentu. Wartoœæ argumentu generatora powinna byæ liczb¹.','Nieprawid³owa wartoœæ','error');
            return;
        end
        if (min < 0)
            msgbox( 'Wartoœæ œredniej nie mo¿e byæ mniejsza od zera. Zalecana jest du¿a wartoœæ.','Nieprawid³owa wartoœæ','error');
            return;
        end
        input = random('Exponential',min, size(get(handles.criteriaTable,'Data'),1), count);
    else % zewnetrzny
        sel = selected - 4;
        generators = evalin('base','externalGenerators');
        generator = generators(sel);
        names = generator.arguments;
        count2 = numel(names);
        if count2 == 0
            input = generator.generate([], [size(get(handles.criteriaTable,'Data'),1) count]);
        elseif count2 == 1
            [min status1] = str2num( get(handles.guiRangeMin, 'String') );
            if( status1 ==0)
                msgbox( 'B³êdna wartoœæ argumentu. Wartoœæ argumentu generatora powinna byæ liczb¹.','Nieprawid³owa wartoœæ','error');
                return;
            end
            input = generator.generate(min, [size(get(handles.criteriaTable,'Data'),1) count]);
        else
            [max status1] = str2num ( get(handles.guiRangeMax, 'String') );
            [min status2] = str2num( get(handles.guiRangeMin, 'String') );
            if( status1 ==0 || status2 == 0)
                msgbox( 'B³êdna wartoœæ argumentu. Wartoœæ argumentu generatora powinna byæ liczb¹.','Nieprawid³owa wartoœæ','error');
                return;
            end
            input = generator.generate(min, max, [size(get(handles.criteriaTable,'Data'),1) count]);
        end
    end

    % generacja obiektow i ustawienie zmiennych w workspace na potrzeby
    % pozostalych fragmentow kodu
    %input = generateInput(  min, max, size(get(handles.criteriaTable,'Data'),1), count, 0);
    assignin('base', 'input', input);
    %assignin('base', 'axis_range',[min-1 max+1 min-1 max+1]);
    
    % Zapis do tabelki
    table =  handles.guiTable;
    set(table, 'Data', input');
    
% Wywolanie przy nacisnieciu przycisku Sortuj
% Pobiera dane po ktorym kryterium posortowac i dokonuje sortowania,
% ustawia zmienne w workspace i tabelce
function sortButton_Callback(hObject, eventdata, handles)
    % sortujemy malejaco/rosnaco w zaleznosci kierunku optymalizacji
    selection = get(handles.sortNumber,'Value');
    dir = get(handles.criteriaTable,'Data');
    dir = dir(selection, 2);
    
    if strcmp('Min', dir)
        dir = selection;
    else
        dir = -selection;
    end
    input = get(handles.guiTable, 'Data');
    % posortowanie danych
    input = sortrows(input,dir);
    assignin('base','input',input');
    table =  handles.guiTable;
    set(table, 'Data', input);
    

% Funkcja wywolywana przy wcisnieciu przycisku Renderuj animacje
% Wyswietlane jest okno animacji, przeprowadzana animacja dla wybranego
% algorytmu, klatki animacji sa przechwytywane i po jej zakonczeniu pojawia
% sie okno umozliwiajace zapis animacji do pliku. Automatycznie uruchomi
% sie odtwarzacz animacji po zapisie
function renderButton_Callback(hObject, eventdata, handles)
    direction = getDirection(handles);
    algorithm = get(handles.algorithmSwitch, 'Value');
    assignin('base','interruptFlag',0);
    data = get(handles.criteriaTable, 'Data');
    assignin('base','labels', getLabels(handles));
    input = get(handles.guiTable,'Data');
    
    if(size(data,1) > 4)
        msgbox( 'Animacja jest dostêpna tylko dla problemów 2D, 3D oraz 4D','Nieobslugiwana akcja','error');
        return;
    end
        
    
    if algorithm == 1
        movie = renderAnimation_Naive(input', direction);
    elseif algorithm == 2
        movie = renderAnimation_Naive2(input', direction);
    else
        movie = KungLuccioPreparata(input', direction);
    end
    
    if evalin('base', 'interruptFlag') ==1 
        return;
    end
    
    [filename, pathname, filterindex] = uiputfile({'*.avi'}, 'Zapisz rozwi¹zanie');
    if isequal(filename,0)
        return;
    end
    
    if( ~isempty(strfind(filename, '.avi')) || filterindex==1)
        if exist(fullfile(pathname,filename), 'file') == 2
            delete(fullfile(pathname,filename));
        end
        saveMovie(movie, fullfile(pathname,filename));
    else
        msgbox( 'Proszê wybraæ plik o rozszerzeniu .avi','Nieprawid³owe rozszerzenie','error');
    end

% Funkcja wywolywana przy wcisnieciu przycisku Benchmark
% Wywolywane sa optymalizacje wykorzystujac obydwa algorytmy, mierzony jest
% czas i liczba wykonanych porownan.
function benchButton_Callback(hObject, eventdata, handles)
    direction = getDirection(handles);
    assignin('base','labels',getLabels(handles));
    input = get(handles.guiTable,'Data');
    benchmark(input', direction); 
    data = get(handles.criteriaTable, 'Data');

% --- Executes on button press in solveButton.
function solveButton_Callback(hObject, eventdata, handles)
    direction = getDirection(handles);
    assignin('base','labels',getLabels(handles));
    input = get(handles.guiTable,'Data')';
    
    [PSet indicator dominated count] = getNonDominated_Naive(input, direction);

    if (size(input,1) <= 4)
        f = figure('Position',[400 150 800 450]);
        set(f, 'Resize', 'off');
        plotInputs(f, input, [], PSet, dominated, 'Rozwi¹zanie problemu', 1);
    end
    
    [filename, pathname, filterindex] = uiputfile({'*.xls'}, 'Zapisz rozwi¹zanie');
    if isequal(filename,0)
        return;
    end
    critData = get(handles.criteriaTable,'Data');
    values = get(handles.guiTable,'Data');
    [rows cols] = size(values);
    output = cell(2+rows, cols+1);
    output(1:2,1:cols) = critData';
    output(3:rows+2,1:cols) = num2cell(values);
    output = output';
    
    
    for i=1:size(indicator,2)
        if(indicator(i) == 1)
            output{cols+1,i+2} = 'niezdominowany';
        else
            output{cols+1,i+2} = 'zdominowany';
        end
    end
    
    if( ~isempty(strfind(filename, '.xls')) || filterindex==2)
        if exist(fullfile(pathname,filename), 'file')==2
            delete(fullfile(pathname,filename));
        end
        xlswrite(fullfile(pathname,filename), output);
    else
        msgbox( 'Proszê wybraæ plik o rozszerzeniu .xls','Nieprawid³owe rozszerzenie','error');
    end
    

    
% --- Executes on button press in interruptButton.
function interruptButton_Callback(hObject, eventdata, handles)
    assignin('base','interruptFlag',1);



%% -------------------------------------------INICJALIZACJA----------------------------------------------
% --- Executes during object creation, after setting all properties.
function criteriaTable_CreateFcn(hObject, eventdata, handles)
    dat =  {'Kryterium 1','Min';...
        'Kryterium 2','Min';...
        'Kryterium 3','Min';...
        'Kryterium 4','Min'};
    set(hObject, 'Data', dat);
    
% --- Executes during object creation, after setting all properties.
function guiTable_CreateFcn(hObject, eventdata, handles)
    set(hObject,'ColumnWidth','auto')
    set(hObject,'ColumnName',{'Kryterium 1' 'Kryterium 2' 'Kryterium 3' 'Kryterium 4'});

%% -------------------------------------------MENU----------------------------------------------
% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function saveProblemMenu_Callback(hObject, eventdata, handles)
    [filename, pathname, filterindex] = uiputfile({'*.csv';'*.xls'}, 'Zapisz plik zadania');
    if isequal(filename,0)
        return;
    end
    critData = get(handles.criteriaTable,'Data');
    values = get(handles.guiTable,'Data');
    [rows cols] = size(values);
    output = cell(2+rows, cols);
    output(1:2,:) = critData';
    output(3:rows+2,:) = num2cell(values);
    
    if( ~isempty(strfind(filename, '.csv')) || filterindex==1)
        writeCell2Csv(fullfile(pathname,filename), output);
    elseif( ~isempty(strfind(filename, '.xls')) || filterindex==2)
        if exist(fullfile(pathname,filename), 'file')==2
            delete(fullfile(pathname,filename));
        end
        xlswrite(fullfile(pathname,filename), output);
    else
        msgbox( 'Proszê wybraæ plik o rozszerzeniu .csv lub .xls','Nieprawid³owe rozszerzenie','error');
    end

function writeCell2Csv(filename, cellArray)
    f = fopen(filename,'wt');
    [rows cols] = size(cellArray);
    for i=1:rows
        for j=1:cols
            fprintf(f, '%s;',num2str(cellArray{i,j}));
        end
        fprintf(f,'\n');
    end

    fclose(f);


% --------------------------------------------------------------------
function LoadProblemMenu_Callback(hObject, eventdata, handles)
    [filename, pathname, filterindex] = uigetfile({'*.csv;*.xls'}, 'Wczytaj plik zadania');
    if isequal(filename,0)
        return;
    end
    
    if( ~isempty(strfind(filename, '.csv')) ||  ~isempty(strfind(filename, '.xls')) ) 
        [A B C] = xlsread(fullfile(pathname, filename));
        [oCount cCount] = size(C);
        set(handles.criteriaTable,'Data',  C(1:2,1:cCount)');
        refreshGuiTable(handles);
        set(handles.guiTable, 'Data', C(3:oCount,:));
    else
        msgbox( 'Proszê wybraæ plik o rozszerzeniu .csv lub .xls','Nieprawid³owe rozszerzenie','error');
    end
    

%% -------------------------------------------POMOCNICZE----------------------------------------------
function refreshGuiTable(handles)
    data = get(handles.criteriaTable, 'Data');
    columnNames =  data(:,1)';
    set(handles.guiTable,'ColumnWidth','auto');
    set(handles.guiTable,'ColumnName',columnNames);
    dat2 = get(handles.guiTable, 'Data');
    cols = size(columnNames,2);
    
    if(cols==0)
        dat2=[];
    elseif cols <= size(dat2,2)
        dat2 = dat2(:,1:cols);
    else
        dat2(:,size(dat2,2)+1) = zeros(1,size(dat2,1));
        %dat2 = dat2(:,1:size(dat2,2));
    end
    set(handles.guiTable,'Data',dat2);
    assignin('base','input',dat2');
    
function direction = getDirection(handles)
    criteriaData = get(handles.criteriaTable, 'Data');
    direct = criteriaData(:,2)';
    critLength = size(direct,2);
    direction = zeros(1,critLength);
    for i=1:critLength
        if (strcmp('Min',direct{i}) == 1 )
            direction(i) = -1;
        else
            direction(i) = 1;
        end
    end
    
function labels = getLabels(handles)
    data = get(handles.criteriaTable, 'Data');
    lab = data(:,1)';
    for i=1:size(lab,2)
        lab{i} = [lab{i} ' (' data{i,2} ')'];
    end
    labels = lab;
        

    
%% -------------------------------------------POZOSTALE----------------------------------------------
% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function guiRangeMin_Callback(hObject, eventdata, handles)
% hObject    handle to guiRangeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of guiRangeMin as text
%        str2double(get(hObject,'String')) returns contents of guiRangeMin as a double


% --- Executes during object creation, after setting all properties.
function guiRangeMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to guiRangeMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function guiRangeMax_Callback(hObject, eventdata, handles)
% hObject    handle to guiRangeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of guiRangeMax as text
%        str2double(get(hObject,'String')) returns contents of guiRangeMax as a double


% --- Executes during object creation, after setting all properties.
function guiRangeMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to guiRangeMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function count_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of count as text
%        str2double(get(hObject,'String')) returns contents of count as a double


% --- Executes during object creation, after setting all properties.
function count_CreateFcn(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in sortNumber.
function sortNumber_Callback(hObject, eventdata, handles)
% hObject    handle to sortNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sortNumber contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sortNumber


% --- Executes during object creation, after setting all properties.
function sortNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sortNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in algorithmSwitch.
function algorithmSwitch_Callback(hObject, eventdata, handles)
% hObject    handle to algorithmSwitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns algorithmSwitch contents as cell array
%        contents{get(hObject,'Value')} returns selected item from algorithmSwitch


% --- Executes during object creation, after setting all properties.
function algorithmSwitch_CreateFcn(hObject, eventdata, handles)
% hObject    handle to algorithmSwitch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in distributions.
function distributions_Callback(hObject, eventdata, handles)
    selected = get(hObject, 'Value');
    if selected == 1 % jednostajny
        set(handles.param1,'String','Min');
        set(handles.param2,'String','Max');
        set(handles.guiRangeMin, 'Enable','On');
        set(handles.guiRangeMax, 'Enable','On');
    elseif selected == 2 % Gaussa
        set(handles.param1,'String','Œrednia');
        set(handles.param2,'String','Odchylenie');
        set(handles.guiRangeMin, 'Enable','On');
        set(handles.guiRangeMax, 'Enable','On');
    elseif selected == 3 % Poissona
        set(handles.param1,'String','Œrednia');
        set(handles.param2,'String','');
        set(handles.guiRangeMin, 'Enable','On');
        set(handles.guiRangeMax, 'Enable','Off');
    elseif selected == 4 % Ekspotencjalny
        set(handles.param1,'String','Œrednia');
        set(handles.param2,'String','');
        set(handles.guiRangeMin, 'Enable','On');
        set(handles.guiRangeMax, 'Enable','Off');
    else % zewnetrzny
        sel = selected - 4;
        generators = evalin('base','externalGenerators');
        generator = generators(sel);
        names = generator.arguments;
        count = numel(names);
        if count == 0
            set(handles.param1,'String','');
            set(handles.param2,'String','');
            set(handles.guiRangeMin, 'Enable','Off');
            set(handles.guiRangeMax, 'Enable','Off');
        elseif count == 1
            set(handles.param1,'String',names(1));
            set(handles.param2,'String','');
            set(handles.guiRangeMin, 'Enable','On');
            set(handles.guiRangeMax, 'Enable','Off');
        else
            set(handles.param1,'String',names{1});
            set(handles.param2,'String',names{2});
            set(handles.guiRangeMin, 'Enable','On');
            set(handles.guiRangeMax, 'Enable','On');
        end
    end


% --- Executes during object creation, after setting all properties.
function distributions_CreateFcn(hObject, eventdata, handles)
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    files = dir('*Generator.m');
    externalGenerators = [];
    names = get(hObject,'String');
    nSize = size(names,1);
    for i=1:numel(files)
        [pathstr,name,ext] = fileparts(files(i).name);
        externalGenerators = [externalGenerators evalin('base',name)];
        names{nSize+i} = externalGenerators(i).name;
    end
    assignin('base','externalGenerators',externalGenerators);
    set(hObject,'String',names);
    



function guiCount_Callback(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of count as text
%        str2double(get(hObject,'String')) returns contents of count as a double


% --- Executes during object creation, after setting all properties.
function guiCount_CreateFcn(hObject, eventdata, handles)
% hObject    handle to count (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
