function varargout = guiMenu(varargin)
% GUIMENU MATLAB code for guiMenu.fig
%      GUIMENU, by itself, creates a new GUIMENU or raises the existing
%      singleton*.
%
%      H = GUIMENU returns the handle to a new GUIMENU or the handle to
%      the existing singleton*.
%
%      GUIMENU('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMENU.M with the given input arguments.
%
%      GUIMENU('Property','Value',...) creates a new GUIMENU or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guiMenu_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guiMenu_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guiMenu

% Last Modified by GUIDE v2.5 14-Apr-2019 21:58:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guiMenu_OpeningFcn, ...
                   'gui_OutputFcn',  @guiMenu_OutputFcn, ...
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


% --- Executes just before guiMenu is made visible.
function guiMenu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guiMenu (see VARARGIN)

% Choose default command line output for guiMenu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guiMenu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guiMenu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filterButton.
function filterButton_Callback(hObject, eventdata, handles)
% hObject    handle to filterButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    guiFilterFace;


% --- Executes on button press in IRecognitionButton.
function IRecognitionButton_Callback(hObject, eventdata, handles)
% hObject    handle to IRecognitionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    guiFaceRecoImage;

% --- Executes on button press in VRecognitionButton.
function VRecognitionButton_Callback(hObject, eventdata, handles)
% hObject    handle to VRecognitionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in quitButton.
function quitButton_Callback(hObject, eventdata, handles)
% hObject    handle to quitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    close all;
