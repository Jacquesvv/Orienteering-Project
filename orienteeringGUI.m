%Jacques Janse Van Vuuren
%12092369

%==========         Course Info          ==========

%Point 12 - 9 = 360m    -   135.003 pixels  - 0.375
%Point 23 - 26 = 910m   -   331.693 pixels  - 0.365
%Point 11 - 8 = 400m    -   126.400 pixels  - 0.316
%Point 7 - 8 = 340m     -   131.795 pixels  - 0.388
%Point 1 - 9 = 470m     -   171.840 pixels  - 0.366
%
%                          Average : 0.362 pixels/m

%5 km/h = 1.38889 m/s = 0.5018 pixels/sec
%6 km/h = 1.66667 m/s = 0.6033 pixels/sec
%7 km/h = 1.94444 m/s = 0.7039 pixels/sec

%1-9    worth 2 points
%10-18  worth 3 points
%19-27  worth 4 points

%==================================================


function varargout = orienteeringGUI(varargin)
% ORIENTEERINGGUI MATLAB code for orienteeringGUI.fig
%      ORIENTEERINGGUI, by itself, creates a new ORIENTEERINGGUI or raises the existing
%      singleton*.
%
%      H = ORIENTEERINGGUI returns the handle to a new ORIENTEERINGGUI or the handle to
%      the existing singleton*.
%
%      ORIENTEERINGGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ORIENTEERINGGUI.M with the given input arguments.
%
%      ORIENTEERINGGUI('Property','Value',...) creates a new ORIENTEERINGGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before orienteeringGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to orienteeringGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help orienteeringGUI

% Last Modified by GUIDE v2.5 05-Sep-2015 14:26:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @orienteeringGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @orienteeringGUI_OutputFcn, ...
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



function orienteeringGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to orienteeringGUI (see VARARGIN)

% Choose default command line output for orienteeringGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);     

axes(handles.axes1);
title('\fontsize{14}Best and Average value Generations', 'FontWeight', 'bold');

axes(handles.axes2);
im=imread('map.jpg');
image(im);
hold on
title('\fontsize{14}Graphical Route', 'FontWeight', 'bold')



function varargout = orienteeringGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Get default command line output from handles structure
varargout{1} = handles.output;



function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

echo on;
global distMatrix;
global pointMatrix;
global locationMatrix;
global WalkSpeed;

rand('seed',156789);

locationMatrix = [  688 732;
                    652 730; 731 714; 704 770; 801 770; 734 670; 
                    626 671; 595 618; 724 591; 772 607; 832 605; 
                    800 490; 894 556; 428 411; 465 543; 530 504; 
                    498 517; 681 495; 545 339; 651 295; 498 353;
                    921 276; 839 277; 750 223; 727 181; 1109 444;
                    1056 351; 652 55];
                t = locationMatrix;
                
pointMatrix = [ 0; 2; 2; 2; 2; 2; 2; 2; 2; 2; 3; 3; 3; 3; 3; 3; 3; 3; 3; 4; 4; 4; 4; 4; 4; 4; 4; 4;];
 

slidervalue = get(handles.slider1,'value');
WalkSpeed = slidervalue*(1000/3600);

sz=size(pointMatrix,1);
%distMatrix=dists(locationMatrix,locationMatrix);
distMatrix = xlsread('DistanceMatrix.xlsx');

%==========              GA              ==========
xFns  = 'partmapXover orderbasedXover singleptXover linerorderXover'% cyclicXover uniformXover'; %cyclicXover uniformXover'
xOpts = [2;2;2;2];

mFns = 'inversionMutation adjswapMutation shiftMutation swapMutation threeswapMutation';
mOpts = [2;2;2;2;2];

termFns = 'maxGenTerm';
termOps = [100]; %100

selectFn = 'normGeomSelect';
selectOps = [0.08]; %0.08

evalFn = 'tspEval';
evalOps = [];

type tspEval;

bounds = sz;

gaOpts=[1e-6 1 1];

startPop = initializeoga(80,bounds,'tspEval',[1e-6 1]); %80

[x, endPop, bestPop, trace]=ga(bounds,evalFn,evalOps,startPop,gaOpts,...
    termFns,termOps,selectFn,selectOps,xFns,xOpts,mFns,mOpts);

toggleStart =0;
n=0;
score =0;
distance =0;
time =0;

pointsAdded =0;

for n=1:28
    if x(n)==1
        toggleStart =1;
    end
    
    if toggleStart ==0 && n==1
        distance = distance + (distMatrix(x(n),1));
        score = score + pointMatrix(x(n));
        pointsAdded = pointsAdded +1;
    end
    
    if toggleStart ==0 && n>1
        distance = distance + (distMatrix(x(n),x(n-1)));
        score = score + pointMatrix(x(n));
        pointsAdded = pointsAdded +1;
    end
    
end
speed = 8*(1000/3600)*0.362;

time = distance * (1/WalkSpeed) ;

k = mat2str(x(1:pointsAdded+1)-1);
Z = strrep(cellstr(k(2:end-1)), ' ', ', ');

set(handles.txtDistance, 'string', distance);
set(handles.txtTime, 'string', (time/60));
set(handles.txtScore, 'string', score);
set(handles.txtNoLoc, 'string', pointsAdded);
set(handles.txtSeq, 'string', Z);
%==================================================

cla(handles.axes1)

axes(handles.axes1);
plot(trace(:,1),trace(:,2));
hold on;
plot(trace(:,1),trace(:,3));
title('\fontsize{14}Best and Average value Generations', 'FontWeight', 'bold');
set(handles.axes1,'ylim',[0 85]);

axes(handles.axes2);
im=imread('map.jpg');
image(im);

hold on;
plot(t(x(1:pointsAdded+1),1),t(x(1:(pointsAdded+1)),2),'r-','LineWidth',3); 
plot(t([x(1),x(pointsAdded+1)],1),t([x(1),x(pointsAdded+1)],2),'r-','LineWidth',3); 
title('\fontsize{14}Graphical Route', 'FontWeight', 'bold')

 hold off;
 legend('Best Found Path');

 
 
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sliderValue = get(handles.slider1,'value');
set(handles.text2, 'string', sliderValue);



function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
