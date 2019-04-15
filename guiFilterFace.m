% GUI pour les filtres de l'application qui contient :
% - Selection d'une image
% - Sauvegarde de l'image selectionnee
% - Buttons pour les filtres
function varargout = guiFilterFace(varargin)
% GUIFILTERFACE MATLAB code for guiFilterFace.fig
%      GUIFILTERFACE, by itself, creates a new GUIFILTERFACE or raises the existing
%      singleton*.
%
%      H = GUIFILTERFACE returns the handle to a new GUIFILTERFACE or the handle to
%      the existing singleton*.
%
%      GUIFILTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFILTERFACE.M with the given input arguments.
%
%      GUIFILTERFACE('Property','Value',...) creates a new GUIFILTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiFilterFace_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiFilterFace_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiFilterFace

% Last Modified by GUIDE v2.5 15-Apr-2019 21:26:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFilterFace_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFilterFace_OutputFcn, ...
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

% Initiliase les filtres
% --- Executes just before guiFilterFace is made visible.
function guiFilterFace_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiFilterFace (see VARARGIN)
    global cumulate;
    global filtering;
    global a;
    global bright;
    % Choose default command line output for guiFilterFace
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);
    cumulate = 0;
    filtering = fwFilter();
    a = 45;
    bright = 20;

% UIWAIT makes guiFilterFace wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiFilterFace_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% Selectionne une image selon les formats choisis
% --- Executes on button press in selectImageButton.
function selectImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to selectImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img;
    global filteredImg;
    global filename;

    [filename, pathname] = uigetfile({'*.tif;*.jpg;*.png;*.gif*;*.pgm;*.jpeg','Select a file'});
    imagefilename = fullfile(pathname, filename);
    [filepath, name, ext] = fileparts(filename);
    img = imread(imagefilename);
    axes(handles.originalAxe);
    imshow(img);
    handles.img = img;
    guidata(hObject, handles);
    filteredImg = img;

% Sauvegarde l'image selectionnee en rajoutant le suffixe 'fw'
% --- Executes on button press in SaveImageButton.
function SaveImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filename;
    global filteredImg;
    imwrite(filteredImg, strcat('fw', filename));

% Revient a l'image originale
% --- Executes on button press in originalButton.
function originalButton_Callback(hObject, eventdata, handles)
% hObject    handle to originalButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filteredImg;
    global img;
    filteredImg = img;

    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles);

% Applique le filtre de Sobel sur l'image
% --- Executes on button press in sobelButton.
function sobelButton_Callback(hObject, eventdata, handles)
% hObject    handle to sobelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;
    
    if cumulate == 0
        filteredImg = img;
    end

    filteredImg = filtering.applySobel(filteredImg);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles);

% Applique le filtre de tourbillon sur l'image
% --- Executes on button press in swirlButton.
function swirlButton_Callback(hObject, eventdata, handles)
% hObject    handle to swirlButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;
    global a;

    if cumulate == 0
        filteredImg = img;
    end
    
    filteredImg = filtering.applySwirl(filteredImg, a);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Applique l'egalisateur d'histogramme sur l'image
% --- Executes on button press in heqButton.
function heqButton_Callback(hObject, eventdata, handles)
% hObject    handle to heqButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;
  
    if cumulate == 0
        filteredImg = img;
    end
    
    filteredImg = filtering.applyHistEq(filteredImg);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Augmente la luminosite de l'image
% --- Executes on button press in brightnessButton.
function brightnessButton_Callback(hObject, eventdata, handles)
% hObject    handle to brightnessButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;
    global bright
  
    if cumulate == 0
        filteredImg = img;
    end
    
    filteredImg = filtering.applyBrightness(filteredImg, bright);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Transforme l'image en nuance de gris
% --- Executes on button press in grayscaleButton.
function grayscaleButton_Callback(hObject, eventdata, handles)
% hObject    handle to grayscaleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;
  
    if cumulate == 0
        filteredImg = img;
    end
    
    filteredImg = filtering.applyGrayscale(filteredImg);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Applique le filtre moyenneur sur l'image
% --- Executes on button press in averageButton.
function averageButton_Callback(hObject, eventdata, handles)
% hObject    handle to averageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;

    if cumulate == 0
        filteredImg = img;
    end
    
    % filteredImg = imnoise(img, 'salt & pepper', 0.02);
    filteredImg = filtering.applyAverage(filteredImg);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Applique le filtre median sur l'image
% --- Executes on button press in medianButton.
function medianButton_Callback(hObject, eventdata, handles)
% hObject    handle to medianButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global filtering;
    global filteredImg;
    global img;
    global cumulate;

    if cumulate == 0
        filteredImg = img;
    end
    
    % filteredImg = imnoise(img, 'salt & pepper', 0.02);
    filteredImg = filtering.applyMedian(filteredImg);
    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles); 

% Applique d'autres filtres sur l'image
% Choix multiples de filtre a l'aide d'un popupbutton
% --- Executes on selection change in otherFiltersPopup.
function otherFiltersPopup_Callback(hObject, eventdata, handles)
% hObject    handle to otherFiltersPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns otherFiltersPopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from otherFiltersPopup
    global img;
    global filteredImg;
    global filtering;
    global cumulate;
    
    if cumulate == 0
        filteredImg = img;
    end
    
    contents = cellstr(get(hObject, 'String'));
    choice = contents(get(hObject, 'Value'));

    if(strcmp(choice, 'Sepia'))
        filteredImg = filtering.applySepia(filteredImg);
    elseif(strcmp(choice, 'Prewitt'))
        filteredImg = filtering.applyPrewitt(filteredImg);
    elseif(strcmp(choice, 'Rotate'))
        filteredImg = filtering.applyRotation(filteredImg, 0.25);
    elseif(strcmp(choice, 'Bilateral'))
        filteredImg = filtering.applyBilateralRGB(filteredImg);
    elseif(strcmp(choice, 'Laplacian'))
        filteredImg = filtering.applyLaplacian(filteredImg);
    elseif(strcmp(choice, 'Invert'))
        filteredImg = filtering.applyInvert(filteredImg);
    elseif(strcmp(choice, 'Binary'))
        filteredImg = filtering.applyBinary(filteredImg);
    elseif(strcmp(choice, 'Complement Binary'))
        filteredImg = filtering.applyComplementBinary(filteredImg);
    elseif(strcmp(choice, 'Mirror'))
        filteredImg = filtering.applyMirror(filteredImg);
    elseif(strcmp(choice, 'Sharpen'))
        filteredImg = filtering.applySharpen(filteredImg);
    elseif(strcmp(choice, 'Interpolation Bilinear'))
        filteredImg = filtering.applyInterpolationB(filteredImg);
    end

    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function otherFiltersPopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to otherFiltersPopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Case permettant de savoir si il faut cumuler ou pas les filtres
% Utilisation de checkbox pour representer une valeur booleenne
% --- Executes on button press in cumulateButton.
function cumulateButton_Callback(hObject, eventdata, handles)
% hObject    handle to cumulateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cumulateButton
    global filteredImg;
    global cumulate;
    cumulate = get(handles.cumulateButton, 'Value');
    disp(cumulate);

% Slider pour modifier la luminosite de l'image
% --- Executes on slider movement.
function brightnessSlider_Callback(hObject, eventdata, handles)
% hObject    handle to brightnessSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global bright;
    bright = get(handles.brightnessSlider, 'Value');


% --- Executes during object creation, after setting all properties.
function brightnessSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to brightnessSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Slider pour modifier le degre du tourbillon qui s'applique sur l'image
% --- Executes on slider movement.
function swirlSlider_Callback(hObject, eventdata, handles)
% hObject    handle to swirlSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
    global a;
    a = get(handles.swirlSlider, 'Value');

% --- Executes during object creation, after setting all properties.
function swirlSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to swirlSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
