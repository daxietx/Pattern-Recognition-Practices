function varargout = maxEstimation_gui(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @maxEstimation_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @maxEstimation_gui_OutputFcn, ...
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


% --- Executes just before maxEstimation_gui is made visible.
function maxEstimation_gui_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
% Update handles structure
handles.prepared = -1;
handles.miniclass = -1;
handles.maxclass = -1;
handles.beta = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.means = [];
handles.covs = [];
handles.rate = -1;
handles.featurenum = -1;
handles.result = [];
handles.classrate = [];
set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.betaEdit,'string','');
set(handles.ratevalText,'string','NaN');

cla(handles.axes1);
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = maxEstimation_gui_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in traindataBtn.
function traindataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.*'});
train = [path filename];
set(handles.trainpathText,'string',train);
handles.trainpath = train;
guidata(hObject,handles);


% --- Executes on button press in testdataBtn.
function testdataBtn_Callback(hObject, eventdata, handles)
[filename,path] = uigetfile({'*.*'});
test = [path filename];
set(handles.testpathText,'string',test);
handles.testpath = test;
guidata(hObject,handles);



function betaEdit_Callback(hObject, eventdata, handles)
handles.beta = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function betaEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in betaexplainBtn.
function betaexplainBtn_Callback(hObject, eventdata, handles)
fid = fopen('.\max_estimation_comment\beta.txt','r');
fclose(fid);
% !start notepad.exe .\max_estimation_comment\beta.txt
winopen('.\max_estimation_comment\beta.txt');


% --- Executes on button press in trainvarBtn.
function trainvarBtn_Callback(hObject, eventdata, handles)
winopen('.\max_estimation_cov.txt');

% --- Executes on button press in testvarBtn.
function testvarBtn_Callback(hObject, eventdata, handles)



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
delete('max_estimation_mean.txt');
delete('max_estimation_cov.txt');

classRange = [handles.miniclass handles.maxclass];

[handles.classrate,handles.means,handles.covs,g,handles.result,handles.rate] = max_estimation(handles.traindata,classRange,handles.testdata,handles.beta);
guidata(hObject,handles);
% write mean matrix to txt
fid = fopen('.\max_estimation_mean.txt','w');
for i=1:size(handles.means,1)
    temp = handles.means(i,:);
    fprintf(fid,'class%d ',i-(1-handles.miniclass));
    for j=1:handles.featurenum
        fprintf(fid,'%d ',temp(j));
    end
     fprintf(fid,'\r\n');
     handles.means;
end
fclose(fid);
% write cov matrix to txt
fid = fopen('.\max_estimation_cov.txt','w');
for i=1:size(handles.covs,1)
    temp = handles.covs(i,:);
    temp = cell2mat(temp);  %get the cov matrix of a single class
    fprintf(fid,'class%d\r\n',i-(1-handles.miniclass));
    for j=1:size(temp,1)
        linetemp = temp(j,:);
        for k=1:handles.featurenum
            fprintf(fid,'%d ',linetemp(k));
        end
        fprintf(fid,'\r\n');        
    end
end
fclose(fid);
set(handles.ratevalText,'string',handles.rate);

%fill class rate table
set(handles.classrateTable,'Data',handles.classrate);

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


% --- Executes on button press in clearBtn.
function clearBtn_Callback(hObject, eventdata, handles)
handles.miniclass = -1;
handles.maxclass = -1;
handles.beta = -1;
handles.traindata = [];
handles.testdata = [];
handles.trainpath = 'Training data path';
handles.testpath = 'Testing data path';
handles.means = [];
handles.covs = [];
handles.rate = -1;
handles.featurenum = -1;
handles.result = [];
handles.classrate = [];
guidata(hObject,handles);
set(handles.classrateTable,'Data',[]);
set(handles.trainpathText,'string',handles.trainpath);
set(handles.testpathText,'string',handles.testpath);
set(handles.miniclassEdit,'string','');
set(handles.maxclassEdit,'string','');
set(handles.featurenumEdit,'string','');
set(handles.betaEdit,'string','');
set(handles.ratevalText,'string','NaN');
cla(handles.axes1);
delete('max_estimation_mean.txt');
delete('max_estimation_cov.txt');


% --- Executes on button press in trainmeanBtn.
function trainmeanBtn_Callback(hObject, eventdata, handles)
winopen('.\max_estimation_mean.txt');



function featurenumEdit_Callback(hObject, eventdata, handles)
handles.featurenum = str2double(get(hObject,'String'));
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function featurenumEdit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in downtrainmeanBtn.
function downtrainmeanBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in downtraincovBtn.
function downtraincovBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in downtestmeanBtn.
function downtestmeanBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in downtestcovBtn.
function downtestcovBtn_Callback(hObject, eventdata, handles)


% --- Executes on button press in viewprinBtn.
function viewprinBtn_Callback(hObject, eventdata, handles)
winopen('.\max_estimation_comment\max_estamition_explain.pdf');


% --- Executes on button press in helpBtn.
function helpBtn_Callback(hObject, eventdata, handles)
winopen('.\max_estimation_comment\help.txt');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function ratevalText_CreateFcn(hObject, eventdata, handles)


% --- Executes on button press in loaddataBtn.
function loaddataBtn_Callback(hObject, eventdata, handles)
data = load(handles.trainpath);
handles.traindata = data;
data = load(handles.testpath);
handles.testdata = data;
guidata(hObject,handles);
msgbox('Data loaded!','Notice');

% --- Executes during object creation, after setting all properties.
function miniclassText_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function maxclassText_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function featurenumText_CreateFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function loaddataBtn_CreateFcn(hObject, eventdata, handles)
