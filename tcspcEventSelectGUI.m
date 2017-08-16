function varargout = tcspcEventSelectGUI(varargin)
% TCSPCEVENTSELECTGUI MATLAB code for tcspcEventSelectGUI.fig
%      TCSPCEVENTSELECTGUI, by itself, creates a new TCSPCEVENTSELECTGUI or raises the existing
%      singleton*.
%
%      H = TCSPCEVENTSELECTGUI returns the handle to a new TCSPCEVENTSELECTGUI or the handle to
%      the existing singleton*.
%
%      TCSPCEVENTSELECTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TCSPCEVENTSELECTGUI.M with the given input arguments.
%
%      TCSPCEVENTSELECTGUI('Property','Value',...) creates a new TCSPCEVENTSELECTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tcspcEventSelectGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tcspcEventSelectGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tcspcEventSelectGUI

% Last Modified by GUIDE v2.5 16-Aug-2017 03:05:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tcspcEventSelectGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @tcspcEventSelectGUI_OutputFcn, ...
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



% --- Executes just before tcspcEventSelectGUI is made visible.
function tcspcEventSelectGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tcspcEventSelectGUI (see VARARGIN)

% Choose default command line output for tcspcEventSelectGUI
handles.output = hObject;

handles.pts = [];
handles.evTimes = [];
handles.evAmp = [];
handles.evTypeArr = [];
handles.evNotesCell = {};
handles.evNote = {};

behavTypeCell = {'EPM' 'lightDark'};
handles.behavTypeCell = behavTypeCell;
set(handles.behavTypeMenu, 'String', behavTypeCell);

handles.fps = 240.55;
set(handles.fpsBox, 'String', num2str(handles.fps));
handles.zeroFr = 0;
set(handles.frBox, 'String', num2str(handles.zeroFr));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tcspcEventSelectGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = tcspcEventSelectGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, path] = uigetfile('.txt', 'Select TCSPC .txt file (samples only)');
handles.filename = filename;
set(handles.filenameTxt, 'String', filename);
%load([path filename]);
disp(['Importing data from: ' filename]); tic;
headerLines = 10;
delimiter = ' ';
dataStruc = importdata([path filename], delimiter, headerLines);
%frTimes = dataStruc.data(:,1);
ca = dataStruc.data(:,1);
handles.dataStruc = dataStruc;

ca = (ca-mean(ca))/var(ca);  % z score the data

try
    ca = runmean(ca, 50);
catch
    disp('couldnt use runmean (not installed?)');
end

hold off;
handles.ca = ca;
xAx = [0 (1:length(ca)-1)/1000];
plot(handles.dataPlot, xAx, ca); hold on;
xlabel('seconds');
ylabel('z-score');
%plot(handles.dataPlot, 5*(1:length(ca)), ca); hold on;
% plot(runmean(ca, 50),'g');

% evTypeCell = { 'newEvent'; 'center entry'; 'open entry'; 'closed entry'};
% handles.evTypeCell = evTypeCell;
% set(handles.evTypeList, 'String', evTypeCell);

% go ahead and zero all lists
handles.pts = [];
handles.evTimes = [];
handles.evAmp = [];
handles.evTypeArr = [];
handles.evNotesCell = {};
handles.evNote = {};
set(handles.evTxt, 'String', '');

guidata(hObject, handles);

% --- Executes on selection change in evTypeList.
function evTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to evTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns evTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from evTypeList


evTypeCell = handles.evTypeCell;
evType = get(hObject,'Value');
evName = cellstr(get(hObject,'String'));
handles.evType = evType;
handles.evName = evName{evType};
set(handles.text3, 'String', evName{evType});
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function evTypeList_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in evList.
function evList_Callback(hObject, eventdata, handles)
% hObject    handle to evList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns evList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from evList


% --- Executes during object creation, after setting all properties.
function evList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to evList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in ptSelectButton.
function ptSelectButton_Callback(hObject, eventdata, handles)
% hObject    handle to ptSelectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x, y] = ginput(1);
yc = handles.ca;
xc = 1:length(yc);
%[a,b]=min((xc-x).^2+(yc-y).^2);
a = find(xc > x, 1);
b = yc(a);
pt = [a b];
plot(handles.dataPlot, a, b, 'r*');
text(a+10,b,handles.evTypeCell{handles.evType});
handles.pts = [handles.pts; pt];
handles.evTypeArr = [handles.evTypeArr handles.evType];

if ~isempty(handles.evNote)
handles.evNotesCell = [handles.evNotesCell handles.evNote];
else
    evNote = 'none';
    handles.evNotesCell = [handles.evNotesCell evNote];
end
handles.evNote = [];

[handles.pts, sortInd] = sortrows(handles.pts);
handles.evTypeArr = handles.evTypeArr(sortInd);
handles.evNotesCell = handles.evNotesCell(sortInd);

guidata(hObject, handles);

set(handles.evTxt, 'String', [num2str([handles.pts handles.evTypeArr'])]);
set(handles.notesTxt, 'String', []);


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = handles.filename;
tcBehStruc.filename = filename;
tcBehStruc.date = date;
tcBehStruc.behavType = handles.behavType;
tcBehStruc.evTypeCell = handles.evTypeCell;
tcBehStruc.ca = handles.dataStruc.data(:,1);
tcBehStruc.timescale = 'sec';
%tcBehStruc.pts = handles.pts;
tcBehStruc.evTimes = handles.pts(:,1);
tcBehStruc.evAmp = handles.pts(:,2);
tcBehStruc.evTypeArr = handles.evTypeArr;
tcBehStruc.evNotesCell = handles.evNotesCell;

evTypeArr = handles.evTypeArr;
for i = 1:length(evTypeArr)
    if evTypeArr(i)~=1
    tcBehStruc.evTypeStr{i}= handles.evTypeCell{evTypeArr(i)};
    else
        tcBehStruc.evTypeStr{i}= handles.evNotesCell{i};
    end
end

[path, name, ext] = fileparts(filename);

try
save([path '/' name '_tcBehStruc_' date], 'tcBehStruc');
catch
    disp('Couldnt save in target dir so saving in current dir.');
    save([name '_tcBehStruc_' date], 'tcBehStruc');
end
disp('Saving data');



function notesTxt_Callback(hObject, eventdata, handles)
% hObject    handle to notesTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notesTxt as text
%        str2double(get(hObject,'String')) returns contents of notesTxt as a double

handles.evNote = get(hObject,'String');

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function notesTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notesTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in behavTypeMenu.
function behavTypeMenu_Callback(hObject, eventdata, handles)
% hObject    handle to behavTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns behavTypeMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from behavTypeMenu

contents = cellstr(get(hObject,'String'));
behavTypeString =  contents{get(hObject,'Value')};

if strfind(behavTypeString, 'EPM')
    evTypeCell = { 'newEvent'; 'center entry'; 'open entry'; 'closed entry'};
elseif strfind(behavTypeString, 'lightDark')
    evTypeCell = { 'newEvent'; 'light entry'; 'dark entry'};
end

handles.evTypeCell = evTypeCell;
set(handles.evTypeList, 'String', evTypeCell);

handles.behavType = behavTypeString;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function behavTypeMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to behavTypeMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fpsBox_Callback(hObject, eventdata, handles)
% hObject    handle to fpsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fpsBox as text
%        str2double(get(hObject,'String')) returns contents of fpsBox as a double

fps = str2double(get(hObject,'String'));
handles.fps = fps;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function fpsBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fpsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frBox_Callback(hObject, eventdata, handles)
% hObject    handle to frBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frBox as text
%        str2double(get(hObject,'String')) returns contents of frBox as a double

zeroFr = str2double(get(hObject,'String'));
handles.zeroFr = zeroFr;

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function frBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
