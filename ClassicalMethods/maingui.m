function varargout = maingui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maingui_OpeningFcn, ...
                   'gui_OutputFcn',  @maingui_OutputFcn, ...
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


% --- Executes just before maingui is made visible.
function maingui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = maingui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in maxestimationBtn.
function maxestimationBtn_Callback(hObject, eventdata, handles)
run('maxEstimation_gui');


% --- Executes on button press in knearestBtn.
function knearestBtn_Callback(hObject, eventdata, handles)
run('k_nearest_gui');

% --- Executes on button press in parzenBtn.
function parzenBtn_Callback(hObject, eventdata, handles)
run('parzen_window_gui');

% --- Executes on button press in adaboostBtn.
function adaboostBtn_Callback(hObject, eventdata, handles)
run('adaboost_gui');


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function knearestBtn_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function parzenBtn_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function adaboostBtn_CreateFcn(hObject, eventdata, handles)
