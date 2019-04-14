function varargout = guiFaceRecoImage(varargin)
% GUIFACERECOIMAGE MATLAB code for guiFaceRecoImage.fig
%      GUIFACERECOIMAGE, by itself, creates a new GUIFACERECOIMAGE or raises the existing
%      singleton*.
%
%      H = GUIFACERECOIMAGE returns the handle to a new GUIFACERECOIMAGE or the handle to
%      the existing singleton*.
%
%      GUIFACERECOIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFACERECOIMAGE.M with the given input arguments.
%
%      GUIFACERECOIMAGE('Property','Value',...) creates a new GUIFACERECOIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiFaceRecoImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiFaceRecoImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiFaceRecoImage

% Last Modified by GUIDE v2.5 14-Apr-2019 17:10:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiFaceRecoImage_OpeningFcn, ...
                   'gui_OutputFcn',  @guiFaceRecoImage_OutputFcn, ...
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


% --- Executes just before guiFaceRecoImage is made visible.
function guiFaceRecoImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiFaceRecoImage (see VARARGIN)

% Choose default command line output for guiFaceRecoImage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiFaceRecoImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiFaceRecoImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in originalImgButton.
function originalImgButton_Callback(hObject, eventdata, handles)
% hObject    handle to originalImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global img
    global imagefilename
    [filename, pathname] = uigetfile({'*.tif;*.jpg;*.png;*.gif*;*.pgm;*.jpeg','Select a file'});
    imagefilename = fullfile(pathname, filename);
    [filepath, name, ext] = fileparts(filename);
    img = imread(imagefilename);
    axes(handles.originalAxe);
    imshow(img);
    handles.img = img;
    guidata(hObject, handles);

% --- Executes on selection change in filteredImgButton.
function filteredImgButton_Callback(hObject, eventdata, handles)
% hObject    handle to filteredImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns filteredImgButton contents as cell array
%        contents{get(hObject,'Value')} returns selected item from filteredImgButton
    global img
    filtering = friFilter();
    contents = cellstr(get(hObject, 'String'));
    choice = contents(get(hObject, 'Value'));
    if(strcmp(choice, 'Original'))
        filteredImg = img;
    elseif(strcmp(choice, 'Grayscale'))
        filteredImg = filtering.applyGrayscale(img);
    elseif(strcmp(choice, 'Histogram Eq'))
        filteredImg = filtering.applyHistEq(img);
    elseif(strcmp(choice, 'Sobel'))
        filteredImg = filtering.applySobel(img);
    elseif(strcmp(choice, 'Prewitt'))
        filteredImg = filtering.applyPrewitt(img);
    elseif(strcmp(choice, 'Sepia'))
        filteredImg = filtering.applySepia(img);
    elseif(strcmp(choice, 'Invert'))
        filteredImg = filtering.applyInvert(img);
    elseif(strcmp(choice, 'Swirl'))
        filteredImg = filtering.applySwirl(img, 50);
    elseif(strcmp(choice, 'Bilateral'))
        filteredImg = filtering.applyBilateralRGB(img);
    elseif(strcmp(choice, 'Laplacian'))
        filteredImg = filtering.applyLaplacian(img);
    elseif(strcmp(choice, 'Brightness'))
        filteredImg = filtering.applyBrightness(img, 50);
    elseif(strcmp(choice, 'Average'))
        % filteredImg = imnoise(img, 'salt & pepper', 0.02);
        filteredImg = filtering.applyAverage(img);
    elseif(strcmp(choice, 'Median'))
        % filteredImg = imnoise(img, 'salt & pepper', 0.02);
        filteredImg = filtering.applyMedian(img);
    elseif(strcmp(choice, 'Binary'))
        filteredImg = filtering.applyBinary(img);
    elseif(strcmp(choice, 'Complement Bin'))
        filteredImg = filtering.applyComplementBinary(img);
    elseif(strcmp(choice, 'Mirror'))
        filteredImg = filtering.applyMirror(img);
    elseif(strcmp(choice, 'Sharpen'))
        filteredImg = filtering.applySharpen(img);
    end

    axes(handles.filteredAxe);
    imshow(filteredImg);
    handles.filteredImg = filteredImg;
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function filteredImgButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filteredImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.


function recognizedImgButton_Callback(hObject, eventdata, handles)
% hObject    handle to recognizedImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of recognizedImgButton as text
%        str2double(get(hObject,'String')) returns contents of recognizedImgButton as a double


% --- Executes during object creation, after setting all properties.
function recognizedImgButton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recognizedImgButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in recognizedImageButton.
function recognizedImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to recognizedImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in recognizeImageButton.
function recognizeImageButton_Callback(hObject, eventdata, handles)
% hObject    handle to recognizeImageButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global imagefilename;
    friEig = friEigen('Dataset', imagefilename);
    friEig = friEig.recognize();
    axes(handles.recognizedAxe);
    imshow(friEig.matchedFace);
    handles.friEig.matchFace = friEig.matchedFace;
    guidata(hObject, handles);
