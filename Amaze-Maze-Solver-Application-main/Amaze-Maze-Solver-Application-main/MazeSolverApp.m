function varargout = MazeSolverApp(varargin)
% MAZESOLVERAPP MATLAB code for MazeSolverApp.fig
%      MAZESOLVERAPP, by itself, creates a new MAZESOLVERAPP or raises the existing
%      singleton*.
%
%      H = MAZESOLVERAPP returns the handle to a new MAZESOLVERAPP or the handle to
%      the existing singleton*.
%
%      MAZESOLVERAPP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAZESOLVERAPP.M with the given input arguments.
%
%      MAZESOLVERAPP('Property','Value',...) creates a new MAZESOLVERAPP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MazeSolverApp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MazeSolverApp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MazeSolverApp

% Last Modified by GUIDE v2.5 27-Mar-2022 21:21:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MazeSolverApp_OpeningFcn, ...
                   'gui_OutputFcn',  @MazeSolverApp_OutputFcn, ...
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


% --- Executes just before MazeSolverApp is made visible.
function MazeSolverApp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MazeSolverApp (see VARARGIN)

set(handles.findpath,'enable','off');
set(handles.clearall,'enable','off');

% Choose default command line output for MazeSolverApp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes MazeSolverApp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MazeSolverApp_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in chooseimage.
function chooseimage_Callback(hObject, eventdata, handles)
% hObject    handle to chooseimage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Select Image');
    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       imagefile = strcat(pathname,filename);
       set(handles.imagepath,'String',imagefile);
       I = imread(imagefile);
       axes(handles.inputimage);
       imshow(I);
       handles.I = I;
       guidata(hObject, handles);
       set(handles.findpath,'enable','on');
       set(handles.clearall,'enable','on');
    end


function imagepath_Callback(hObject, eventdata, handles)
% hObject    handle to imagepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagepath as text
%        str2double(get(hObject,'String')) returns contents of imagepath as a double


% --- Executes during object creation, after setting all properties.
function imagepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in findpath.
function findpath_Callback(hObject, eventdata, handles)
% hObject    handle to findpath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

J = handles.I;

% Convert to binary image
if size(J,3) ==3
    J = rgb2gray(J);
end
threshold = graythresh(J);
Maze_Binary = im2bw(J,threshold);
% Maze_Binary = imbinarize(J,graythresh(J)-0.1); % Make sure to have black walls and white path 
% There should not be any broken walls, walls should be seperate from boundary of images  
% disp(size(Maze_Binary))
% figure,imshow(Maze_Binary);title('Binary Maze');

% Start Solving 
%Use Watershed transform to find catchment basins
%Some other methods also can be used
Maze_Watershed = watershed(Maze_Binary);
C1 = (Maze_Watershed == 2);%Obtain First Part of Watershed
Maze_watershed1 = C1.*Maze_Binary;
% figure,imshow(Maze_watershed1);title('One of the Part of catchment basins');

C2 = watershed(Maze_watershed1);
%Using watershed transform once again so the image obtained will be
%shrinked along path of maze, imshow pir is used to observe this.
% figure,imshowpair(Maze_Watershed,C2);title('Shrinked Path')

%So now we can easily Take difference of both images to get the path.
P1 = Maze_Watershed == 2;
P2 = C2 == 2;
path = P1 - P2;
output = imoverlay(Maze_Binary, path, [0 1 0]); 
% figure,imshow(Solved);title('Solved Maze') 

axes(handles.outputimage);
imshow(output);


function out = imoverlay(in, mask, color)
    % If the user doesn't specify the color, use white.
    DEFAULT_COLOR = [1 1 1];
    if nargin < 3
        color = DEFAULT_COLOR;
    end

    % Force the 2nd input to be logical.
       mask = (mask ~= 0);

    % Make the uint8 the working data class.  The output is also uint8.
    in_uint8 = im2uint8(in);
    color_uint8 = im2uint8(color);

    % Initialize the red, green, and blue output channels.
    if ndims(in_uint8) == 2
        % Input is grayscale.  Initialize all output channels the same.
        out_red   = in_uint8;
        out_green = in_uint8;
        out_blue  = in_uint8;
    else
        % Input is RGB truecolor.
        out_red   = in_uint8(:,:,1);
        out_green = in_uint8(:,:,2);
        out_blue  = in_uint8(:,:,3);
    end

    % Replace output channel values in the mask locations with the appropriate
    % color value.
    out_red(mask)   = color_uint8(1);
    out_green(mask) = color_uint8(2);
    out_blue(mask)  = color_uint8(3);

    % Form an RGB truecolor image by concatenating the channel matrices along
    % the third dimension.
    out = cat(3, out_red, out_green, out_blue);


% --- Executes on button press in clearall.
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chooseimage,'string','Choose Image');
set(handles.imagepath,'String','');
cla(handles.inputimage,'reset');
cla(handles.outputimage,'reset');
set(handles.findpath,'enable','off');
set(handles.clearall,'enable','off');
