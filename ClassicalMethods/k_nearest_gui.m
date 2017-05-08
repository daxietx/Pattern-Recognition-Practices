function varargout = k_nearest_gui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @k_nearest_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @k_nearest_gui_OutputFcn, ...
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


% --- Executes just before k_nearest_gui is made visible.
function k_nearest_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for k_nearest_gui
handles.output = hObject;
% Update handles structure
handles.prepared = -1;
handles.miniclass = -1;
handles.maxclass = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.standrate = -1;
handles.nonstandrate = -1;
handles.featurenum = -1;
handles.standresult = [];
handles.nonstandresult = [];
handles.standclassrate = [];
handles.nonstandclassrate = [];

handles.standard = -1;
handles.autosetk = -1;
handles.manualkval = 1;
handles.standk = 1;
handles.nonstandk = 1;
set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.kEdit,'string','NaN');

cla(handles.axes1);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = k_nearest_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in traindataBtn.
function traindataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.txt'});
train = [path filename];
set(handles.trainpathText,'string',train);
handles.trainpath = train;
guidata(hObject,handles);


% --- Executes on button press in testdataBtn.
function testdataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.txt'});
test = [path filename];
set(handles.testpathText,'string',test);
handles.testpath = test;
guidata(hObject,handles);

% --- Executes on button press in standexplainBtn.
function standexplainBtn_Callback(hObject, eventdata, handles)
winopen('.\k_nearest_comment\standardization.pdf');


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

[handles.standrate,handles.standclassrate,handles.standk,handles.standresult] = k_nearest(handles.traindata,classRange,handles.testdata,1,handles.autosetk,handles.manualkval);
[handles.nonstandrate,handles.nonstandclassrate,handles.nonstandk,handles.nonstandresult] = k_nearest(handles.traindata,classRange,handles.testdata,0,handles.autosetk,handles.manualkval);
classrate = [handles.standclassrate handles.nonstandclassrate];
guidata(hObject,handles);

%fill result
str = sprintf('%d(Standarized)',handles.standrate);
set(handles.standrateEdit,'string',str);
str = sprintf('%d(Non-standarized)',handles.nonstandrate);
set(handles.nonstandrateEdit,'string',str);

%fill class rate table
set(handles.classrateTable,'Data',classrate);

%fill parameters
if handles.autosetk==1
    if handles.standard==1 
        set(handles.autokEdit,'string',handles.standk);
    else
        set(handles.autokEdit,'string',handles.nonstandk);
    end
end

%draw figure
x = 1:1:size(handles.testdata,1);
y = x;
if handles.standard==1
    z = handles.standresult(:,2);
    result = handles.standresult;
else
    z = handles.nonstandresult(:,2);
    result = handles.nonstandresult;
end
axes(handles.axes1);
xlabel('Sample index');
ylabel('Sample index');
zlabel('Class Label');
scatter3(x,y,z);
hold on;
for i=1:size(result,1)
    if result(i,1)~=result(i,2)
        xlabel('Sample index');
        ylabel('Sample index');
        zlabel('Class Label');
        scatter3(i,i,result(i,2),'red','fill');
    end
end


guidata(hObject,handles);


% --- Executes on button press in clearBtn.
function clearBtn_Callback(hObject, eventdata, handles)
handles.miniclass = -1;
handles.maxclass = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.standrate = -1;
handles.nonstandrate = -1;
handles.featurenum = -1;
handles.standresult = [];
handles.nonstandresult = [];
handles.standclassrate = [];
handles.nonstandclassrate = [];

handles.standard = -1;
handles.autosetk = -1;
handles.manualkval = 1;
handles.standk = 1;
handles.nonstandk = 1;

guidata(hObject,handles);
set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.standrateEdit,'string','NaN (Standarized)');
set(handles.nonstandrateEdit,'string','NaN (Non-standarized)');
cla(handles.axes1);


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
winopen('.\k_nearest_comment\k_nearest_explain.pdf');


% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
winopen('.\k_nearest_comment\help.txt');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function standrateEdit_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in standRdBtn.
function standRdBtn_Callback(hObject, eventdata, handles)
handles.standard = get(hObject,'Value');
guidata(hObject,handles);


function kEdit_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function kEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in leave1explainBtn.
function leave1explainBtn_Callback(hObject, eventdata, handles)
winopen('.\k_nearest_comment\leave_one_out.pdf');


% --- Executes on button press in leave1outRaBtn.
function leave1outRaBtn_Callback(hObject, eventdata, handles)
handles.autosetk = get(hObject,'Value');
if handles.autosetk~=1
    set(handles.autokEdit,'string','NaN');
end
guidata(hObject,handles);


% --- Executes on slider movement.
function kSlider_Callback(hObject, eventdata, handles)
handles.manualkval = floor(get(hObject,'Value')*10);
guidata(hObject,handles);
if handles.autosetk==0
    set(handles.kEdit,'string',handles.manualkval);
end

% --- Executes during object creation, after setting all properties.
function kSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function state1Text_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in loaddataBtn.
function loaddataBtn_Callback(hObject, eventdata, handles)
data = get_data(handles.trainpath,handles.featurenum+1);
handles.traindata = data;
data = get_data(handles.testpath,handles.featurenum+1);
handles.testdata = data;
guidata(hObject,handles);
msgbox('Data loaded!','Notice');
