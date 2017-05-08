function varargout = parzen_window_gui(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @parzen_window_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @parzen_window_gui_OutputFcn, ...
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


% --- Executes just before parzen_window_gui is made visible.
function parzen_window_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Update handles structure
handles.miniclass = -1;
handles.maxclass = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.featurenum = -1;
handles.result = [];
handles.rate = -1;
handles.classrate = [];

handles.autoseth = -1;
handles.manualhval = 0.1;
handles.autohval = 0.1;

set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');

cla(handles.axes1);

guidata(hObject, handles);


% --- Executes on button press in clearBtn.
function clearBtn_Callback(hObject, eventdata, handles)
handles.miniclass = -1;
handles.maxclass = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.featurenum = -1;
handles.result = [];
handles.rate = -1;
handles.classrate = [];

handles.autoseth = -1;
handles.manualhval = 0.1;
handles.autohval = 0.1;
guidata(hObject,handles);

set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.hEdit,'string','0.1');
set(handles.autohEdit,'string','NaN');

cla(handles.axes1);


% --- Outputs from this function are returned to the command line.
function varargout = parzen_window_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function titleText_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in traindataBtn.
function traindataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.txt'});
train = [path filename];
set(handles.trainpathText,'string',train);
handles.trainpath = train;
guidata(hObject,handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)



function miniclassEdit_Callback(hObject, eventdata, handles)
handles.miniclass = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function miniclassEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxclassEdit_Callback(hObject, eventdata, handles)
handles.maxclass = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function maxclassEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in startBtn.
function startBtn_Callback(hObject, eventdata, handles)
set(handles.classrateTable,'Data',[]);
cla(handles.axes1);

classRange = [handles.miniclass handles.maxclass];

%call functions
[handles.autohval,handles.rate,handles.classrate,handles.result] = parzen_start(handles.traindata,classRange,handles.testdata,handles.autoseth,handles.manualhval);

% fill result
set(handles.rateEdit,'string',handles.rate);

%fill class rate table
set(handles.classrateTable,'Data',handles.classrate);

%fill parameters
if handles.autoseth==1
    set(handles.autohEdit,'string',handles.autohval);
end

%draw figure
x = 1:1:size(handles.testdata,1);
y = x;
z = handles.result(:,2);
axes(handles.axes1);
xlabel('Sample index');
ylabel('Sample index');
zlabel('Class Label');
scatter3(x,y,z);
hold on;
for i=1:size(handles.result,1)
    if handles.result(i,1)~=handles.result(i,2)
        xlabel('Sample index');
        ylabel('Sample index');
        zlabel('Class Label');
        scatter3(i,i,handles.result(i,2),'red','fill');
    end
end


guidata(hObject,handles);
 

function featurenumEdit_Callback(hObject, eventdata, handles)
handles.featurenum = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function featurenumEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewprinBtn.
function viewprinBtn_Callback(hObject, eventdata, handles)
winopen('.\parzen_window_comment\parzen_window_explaination.pdf');

% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
winopen('.\parzen_window_comment\help.txt');

% --- Executes on button press in testdataBtn.
function testdataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.txt'});
test = [path filename];
set(handles.testpathText,'string',test);
handles.testpath = test;
guidata(hObject,handles);

% --- Executes on button press in loaddataBtn.
function loaddataBtn_Callback(hObject, eventdata, handles)
data = load(handles.trainpath);
handles.traindata = data;
data = load(handles.testpath);
handles.testdata = data;
guidata(hObject,handles);
msgbox('Data loaded!','Notice');


% --- Executes on button press in leave1explainBtn.
function leave1explainBtn_Callback(hObject, eventdata, handles)
winopen('.\parzen_window_comment\leave_one_out.pdf');

% --- Executes on button press in leave1outRaBtn.
function leave1outRaBtn_Callback(hObject, eventdata, handles)
handles.autoseth = get(hObject,'Value');
if handles.autoseth~=1
    set(handles.autohEdit,'string','NaN');
end
guidata(hObject,handles);

% --- Executes on slider movement.
function hslider_Callback(hObject, eventdata, handles)
handles.manualhval = floor(get(hObject,'Value')*10)/10;
guidata(hObject,handles);
if handles.autoseth==0
    set(handles.hEdit,'string',handles.manualhval);
end

% --- Executes during object creation, after setting all properties.
function hslider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes during object creation, after setting all properties.
function trainpathText_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function autohEdit_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function rateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
