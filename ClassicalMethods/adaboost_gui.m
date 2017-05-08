function varargout = adaboost_gui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @adaboost_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @adaboost_gui_OutputFcn, ...
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


% --- Executes just before adaboost_gui is made visible.
function adaboost_gui_OpeningFcn(hObject, eventdata, handles, varargin)
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
handles.restresult = [];
handles.otherresult = [];
handles.restrate = -1;
handles.otherrate = -1;
handles.restclassrate = [];
handles.otherclassrate = [];
handles.method = 1;
handles.setrest = 1;
handles.setother = 0;
handles.useada = 0;

handles.kval = 0.1;
handles.bval = 1;

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
handles.restresult = [];
handles.otherresult = [];
handles.restrate = -1;
handles.otherrate = -1;
handles.restclassrate = [];
handles.otherclassrate = [];
handles.method = 1;
handles.setrest = 1;
handles.setother = 0;
handles.useada = 0;

handles.kval = 0.1;
handles.bval = 1;

set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.kEdit,'string','NaN');
set(handles.bEdit,'string','NaN');
set(handles.restrateEdit,'string','NaN');
set(handles.otherrateEdit,'string','NaN');

cla(handles.axes1);

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = adaboost_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



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
if handles.useada ==0
[handles.restclassrate,handles.restrate,handles.restresult] = algo8_1vsR(handles.traindata,handles.testdata,classRange(1),classRange(2),handles.kval,handles.bval);
[handles.otherclassrate,handles.otherrate,handles.otherresult] = algo8_1vsO(handles.traindata,handles.testdata,handles.kval,handles.bval);
end
% fill result
set(handles.restrateEdit,'string',handles.restrate);
set(handles.otherrateEdit,'string',handles.otherrate);


% fill class rate table
handles.classrate = [handles.restclassrate handles.otherclassrate];
set(handles.classrateTable,'Data',handles.classrate);

%draw figure
if handles.method ==1 %user chooses rest method
    handles.result = handles.restresult;
else
    handles.result = handles.otherresult;
end
x = 1:1:size(handles.testdata,1);
y = x;
z = handles.result(:,2);
axes(handles.axes1);
set(gca,'ZTick',[-1:1:3]);
xlabel('Sample index');
ylabel('Sample index');
zlabel('Class Label');
scatter3(x,y,z);
hold on;
for i=1:size(handles.result,1)
    if handles.result(i,1)~=handles.result(i,2)
        set(gca,'ZTick',[-1:1:3]);
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
winopen('.\adaboost_comment\adaboost_explaination.pdf');



% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
winopen('.\adaboost_comment\help.txt');



% --- Executes on button press in loaddataBtn.
function loaddataBtn_Callback(hObject, eventdata, handles)
data = load(handles.trainpath);
handles.traindata = data;
data = load(handles.testpath);
handles.testdata = data;
guidata(hObject,handles);
msgbox('Data loaded!','Notice');


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)



% --- Executes on button press in restexplainText.
function restexplainText_Callback(hObject, eventdata, handles)
winopen('.\adaboost_comment\rest.pdf');



% --- Executes on button press in restRaBtn.
function restRaBtn_Callback(hObject, eventdata, handles)
handles.setrest = get(hObject,'Value');
if handles.setrest==1
    set(handles.otherRaBtn,'Value',0);
    handles.method = 1;
else
    set(handles.otherRaBtn,'Value',1);
    handles.method = 2;
end
guidata(hObject,handles);


% --- Executes on button press in otherexplainText.
function otherexplainText_Callback(hObject, eventdata, handles)
winopen('.\adaboost_comment\other.pdf');



% --- Executes on button press in otherRaBtn.
function otherRaBtn_Callback(hObject, eventdata, handles)
handles.setother = get(hObject,'Value');
if handles.setother==1
    set(handles.restRaBtn,'Value',0);
    handles.method = 2;
else
    set(handles.restRaBtn,'Value',1);
    handles.method = 1;
end
guidata(hObject,handles);


% --- Executes on slider movement.
function bSlider_Callback(hObject, eventdata, handles)
handles.bval = floor(get(hObject,'Value')*10)/10;
guidata(hObject,handles);
set(handles.bEdit,'string',handles.bval);


% --- Executes during object creation, after setting all properties.
function bSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in adaexplainBtn.
function adaexplainBtn_Callback(hObject, eventdata, handles)
winopen('.\adaboost_comment\adaboost.pdf');



% --- Executes on button press in adaRaBtn.
function adaRaBtn_Callback(hObject, eventdata, handles)
handles.useada = get(hObject,'Value');


% --- Executes on slider movement.
function kSlider_Callback(hObject, eventdata, handles)
handles.kval = floor(get(hObject,'Value')*10)/10;
guidata(hObject,handles);
set(handles.kEdit,'string',handles.kval);


% --- Executes during object creation, after setting all properties.
function kSlider_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in kexplainBtn.
function kexplainBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in bexplainBtn.
function bexplainBtn_Callback(hObject, eventdata, handles)


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


% --- Executes during object creation, after setting all properties.
function trainpathText_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
