function varargout = TPM_GUI(varargin)
%TPM_GUI M-file for TPM_GUI.fig
%      TPM_GUI, by itself, creates a new TPM_GUI or raises the existing
%      singleton*.
%
%      H = TPM_GUI returns the handle to a new TPM_GUI or the handle to
%      the existing singleton*.
%
%      TPM_GUI('Property','Value',...) creates a new TPM_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to TPM_GUI_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      TPM_GUI('CALLBACK') and TPM_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in TPM_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TPM_GUI

% Last Modified by GUIDE v2.5 11-Apr-2016 16:46:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TPM_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @TPM_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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

% --- Executes just before TPM_GUI is made visible.
function TPM_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for TPM_GUI
handles.output = hObject;
controls.linear = 1;
% create an axes that spans the whole gui
ah = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('greyswirl.png'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(ah,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(ah, 'bottom');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TPM_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TPM_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in calculate_button.
function calculate_button_Callback(hObject, eventdata, handles)
% hObject    handle to calculate_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Start up functions

error_flag = 0;
harms = zeros(1,2);
controls.harmonic = zeros(1,2);%
controls.harmonic_type = zeros(1,2);%
controls.x_range = zeros(1,2);
controls.y_range = zeros(1,2);
controls.z_range = zeros(1,2);
controls.f_sensitivity = zeros(1,7);
controls.d_sensitivity = zeros(1,7);
properties = zeros(1,6);
fixed_properties = zeros(1,6);
controls.f_sensitivity = zeros(1,7);
controls.d_sensitivity = zeros(1,7);
combinations = zeros(91,2);
controls.text = 0;
%% Sorting out the harmonic assingment

a = get(handles.fundamental_frequency,'String');
if strcmp(a,'Hz')
    set(handles.software_responses,'String','The numerical fundamental frequency value needs to replace the "Hz" unit displayed on startup, (Core Values >> fundamental frequency)');
    error_flag = 1;
elseif strcmp(a,'Tom')||strcmp(a,'tom')||strcmp(a,'McNamara')||strcmp(a,'mcnamara')
    set(handles.software_responses,'String','You found an Easter Egg! I would like to thank my family: Mum, Dad and Max for putting up with my experimetns for so many years! Love you all. xxx');
    error_flag = 1;
elseif strcmp(a,'Tom McNamara')||strcmp(a,'tom mcnamara')||strcmp(a,'88tpm')
    set(handles.software_responses,'String','You found an Easter Egg! Hope you like the code :) If you want to find me online search for 88tpm in your favourite search engine ...');
    error_flag = 1;
elseif strcmp(a,'Kayak')||strcmp(a,'kayak')||strcmp(a,'Lewis')||strcmp(a,'lewis')
    set(handles.software_responses,'String','You found an Easter Egg! Thank you Lewis for making my time in Manchester so fun and special. I feel very lucky to have ever met you. xx');
    error_flag = 1;
elseif strcmp(a,'Max')||strcmp(a,'max')
    set(handles.software_responses,'String','Easter egg! Maxie goes roar!!!');
    error_flag = 1;
elseif strcmp(a,'Mum')||strcmp(a,'mum')
    set(handles.software_responses,'String','Easter egg! Bird-dog is flying around');
    error_flag = 1;
elseif strcmp(a,'Dad')||strcmp(a,'dad')
    set(handles.software_responses,'String','Easter egg! Dad is bobbing around on the ocean');
    error_flag = 1;
elseif isletter(a(1))
    set(handles.software_responses,'String','The fundamental frequency must be a number, (Core Values >> fundamental frequency)');
    error_flag = 1;
elseif get(handles.harmonic_1,'Value') == get(handles.harmonic_2,'Value')
    set(handles.software_responses,'String','Harmnoic 1 and Harmonic 2 (Core Values >> Harmonic 1 or Harmonic 2) must be different, please change either to a different value');
    error_flag = 1;
end

% Harmonic 1
if error_flag == 0
    harm = get(handles.harmonic_2,'Value');
    if harm < 8
        controls.harmonic(2) = (2*harm)-1;
        harms(1,2) = 1;
    else
        harm = (2*(harm-7))-1;
        controls.harmonic(2) = harm;
        harms(1,2) = 0;
    end

    % Harmonic 2
    harm = get(handles.harmonic_1,'Value');
    if harm < 8
        controls.harmonic(1) = (2*harm)-1;
        harms(1) = 1;
    else
        harm = (2*(harm-7))-1;
        controls.harmonic(1) = harm;
        harms(1) = 0;
    end
    
end

if error_flag == 0
    if isequal(harms, [1 1])
        controls.harmonic_type = 'FF';
        controls.harmonic = sort(controls.harmonic);
    elseif isequal(harms, [1 0])
        controls.harmonic_type = 'FD';
    elseif isequal(harms, [0 0])
        controls.harmonic_type = 'DD';
        controls.harmonic = sort(controls.harmonic);
    else
        set(handles.software_responses,'String','For frequency and dissipation pairs, please set Harmonic 1 as the frequency rather than Harmonic 2 as it currently is');
        error_flag = 1;
    end
end
%% Sorting out the axis

if error_flag == 0
    a = get(handles.steps,'String');
    b = get(handles.z_range_start,'String');
    c = get(handles.z_range_end,'String');
    d = get(handles.x_start,'String');
    e = get(handles.x_finish,'String');
    f = get(handles.y_start,'String');
    g = get(handles.y_finish,'String');
    controls.x_range(1,:) = [str2double(d) str2double(e)];
    controls.y_range(1,:) = [str2double(f) str2double(g)];
    controls.x = get(handles.x_axis,'Value');
    controls.y = get(handles.y_axis,'Value');
    controls.steps = str2double(get(handles.steps,'String'));
    if controls.x == controls.y
        set(handles.software_responses,'String','X & Y axis must be different, (X axis or Y axis >> ''list selection'')');
        error_flag = 1;
    elseif strcmp(d,'x start') || strcmp(e,'x finish') || strcmp(f,'y start') || strcmp(g,'y finish')
        set(handles.software_responses,'String','One or more of the X and/or Y start and finish values have not been input (X axis and/or Y axis >> ''box(es)'')');
        error_flag = 1;
    elseif isletter(d(1)) || isletter(e(1))
        set(handles.software_responses,'String','X axis start and finish values must be numbers (X axis >> ''box(es)'')');
        error_flag = 1;
    elseif isletter(f(1)) || isletter(g(1))
        set(handles.software_responses,'String','Y axis start and finish values must be numbers (Y axis >> ''box(es)'')');
        error_flag = 1;
    elseif strcmp(a,'steps')
        set(handles.software_responses,'String','Steps (Settings >> Steps) needs a number, 30 is normaly a good start');
        error_flag = 1;
    elseif isletter(a(1))
        set(handles.software_responses,'String','Steps (Settings >> Steps) must be a number');
        error_flag = 1;
    elseif strcmp(b,'auto') && strcmp(c,'auto')
        controls.z_range(1,:) = [0 0];
    elseif isletter(b(1)) || isletter(c(1))
        set(handles.software_responses,'String','Z range start and end values must be either both numbers or both "auto". On auto, z axis will auto scale. Putting numbers in both will fix the z axis');
        error_flag = 1;
    elseif str2double(get(handles.z_range_start,'String')) > str2double(get(handles.z_range_end,'String'))
        set(handles.software_responses,'String','Please swap Z axis start and z axis end values');
        error_flag = 1;
    else
    controls.z_range(1,:) = [str2double(get(handles.z_range_start,'String')) str2double(get(handles.z_range_end,'String'))];
    end
end

%% Setting up core values
if error_flag == 0
    a = get(handles.film_height,'String');
    b = get(handles.film_density,'String');
    c = get(handles.film_viscosity,'String');
    d = get(handles.film_shear,'String');
    e = get(handles.bulk_density,'String');
    f = get(handles.bulk_viscosity,'String');
    if strcmp(a,'m') || strcmp(b,'kg / m^3') || strcmp(c,'Pa / s') || strcmp(d,'Pa') || strcmp(e,'kg / m^3') || strcmp(f,'Pa / s')
        set(handles.software_responses,'String','You need to put numbers into one or more of the Film Properties and/or Bulk Properties boxes to replace the units shown on startup');
        error_flag = 1;
    elseif isletter(a(1))
        set(handles.software_responses,'String','Film height (Film Properties >> Height) must be a number');
        error_flag = 1;
    elseif isletter(b(1))
        set(handles.software_responses,'String','Film density (Film Properties >> Density) must be a number');
        error_flag = 1;
    elseif isletter(c(1))
        set(handles.software_responses,'String','Film viscosity (Film Properties >> Viscosity) must be a number');
        error_flag = 1;
    elseif isletter(d(1))
        set(handles.software_responses,'String','Film shear (Film Properties >> Shear) must be a number');
        error_flag = 1;
    elseif isletter(e(1))
        set(handles.software_responses,'String','Bulk density (Bulk Properties >> Density) must be a number');
        error_flag = 1;
    elseif isletter(f(1))
        set(handles.software_responses,'String','Bulk viscosity (Bulk Properties >> Viscosity) must be a number');
        error_flag = 1;
    end
end

if error_flag == 0
    controls.f0 = str2double(get(handles.fundamental_frequency,'String'));
    controls.linear = get(handles.linear_maths,'Value');
    controls.publication = get(handles.custom_graph,'Value');
    properties = [str2double(a) str2double(b) str2double(c) str2double(d) str2double(e) str2double(f)];
    fixed_properties = [1 1 1 1 1 1];
    if controls.x == 1 || controls.y == 1
        fixed_properties(1,4) = 0;
    end
    if controls.x == 2 || controls.y == 2
        fixed_properties(1,3) = 0;
    end
    if controls.x == 3 || controls.y == 3
        fixed_properties(1,1) = 0;
    end
    if controls.x == 4 || controls.y == 4
        fixed_properties(1,2) = 0;
    end
    if controls.x == 5 || controls.y == 5
        fixed_properties(1,6) = 0;
    end
    if controls.x == 6 || controls.y == 6
        fixed_properties(1,5) = 0;
    end
end

if error_flag == 0
    if get(handles.text_results,'Value')
        a = get(handles.results,'String');
        if strcmp(a,'number')
            set(handles.software_responses,'String','Number (Settings >> Number) needs to have the number of top TPM-sensitivity results you wish to see, 10 is a good start');
            error_flag = 1;
        elseif isletter(a(1))
            set(handles.software_responses,'String','Number (Settings >> Number) must be a number');
            error_flag = 1;
        else
            controls.text = 1;
            controls.text_rows = str2double(a);
        end
    end
end

%% Setting up the sensitivities
if error_flag == 0
    controls.f_sensitivity = [str2double(get(handles.sf1,'String')) str2double(get(handles.sf3,'String')) str2double(get(handles.sf5,'String')) str2double(get(handles.sf7,'String')) str2double(get(handles.sf9,'String')) str2double(get(handles.sf11,'String')) str2double(get(handles.sf13,'String'))];
    controls.d_sensitivity = [str2double(get(handles.sd1,'String')) str2double(get(handles.sd3,'String')) str2double(get(handles.sd5,'String')) str2double(get(handles.sd7,'String')) str2double(get(handles.sd9,'String')) str2double(get(handles.sd11,'String')) str2double(get(handles.sd13,'String'))];
end

%% Running the calculations

if error_flag ==0
    set(handles.software_responses,'String','Crunching the numbers ...');
    c = 1;
    [output] = TPM_sensitivity_GUI(controls,properties,fixed_properties);
    set(handles.software_responses,'String','Done :)');
end

%% Plotting the graphs
% --- Executes on selection change in harmonic_1.
function harmonic_2_Callback(hObject, eventdata, handles)
% hObject    handle to harmonic_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns harmonic_2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from harmonic_2

% --- Executes during object creation, after setting all properties.
function harmonic_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harmonic_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in harmonic_1.
function harmonic_1_Callback(hObject, eventdata, handles)
% hObject    handle to harmonic_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns harmonic_1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from harmonic_1

% --- Executes during object creation, after setting all properties.
function harmonic_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harmonic_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fundamental_frequency_Callback(hObject, eventdata, handles)
% hObject    handle to fundamental_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fundamental_frequency as text
%        str2double(get(hObject,'String')) returns contents of fundamental_frequency as a double


% --- Executes during object creation, after setting all properties.
function fundamental_frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fundamental_frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in custom_graph.
function custom_graph_Callback(hObject, eventdata, handles)
% hObject    handle to custom_graph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of custom_graph


% --- Executes on button press in linear_maths.
function linear_maths_Callback(hObject, eventdata, handles)
% hObject    handle to linear_maths (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of linear_maths
% a = get(handles.linear_maths,'Value');
% if a
% set(handles.software_responses,'String','Yep, linear maths engaged');
% else
%     set(handles.software_responses,'String',a);
% end


function steps_Callback(hObject, eventdata, handles)
% hObject    handle to steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of steps as text
%        str2double(get(hObject,'String')) returns contents of steps as a double


% --- Executes during object creation, after setting all properties.
function steps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to steps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_range_start_Callback(hObject, eventdata, handles)
% hObject    handle to z_range_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_range_start as text
%        str2double(get(hObject,'String')) returns contents of z_range_start as a double


% --- Executes during object creation, after setting all properties.
function z_range_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_range_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_range_end_Callback(hObject, eventdata, handles)
% hObject    handle to z_range_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_range_end as text
%        str2double(get(hObject,'String')) returns contents of z_range_end as a double


% --- Executes during object creation, after setting all properties.
function z_range_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_range_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in y_axis.
function y_axis_Callback(hObject, eventdata, handles)
% hObject    handle to y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns y_axis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from y_axis
y_selection = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function y_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_start_Callback(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_start as text
%        str2double(get(hObject,'String')) returns contents of y_start as a double


% --- Executes during object creation, after setting all properties.
function y_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_finish_Callback(hObject, eventdata, handles)
% hObject    handle to y_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_finish as text
%        str2double(get(hObject,'String')) returns contents of y_finish as a double


% --- Executes during object creation, after setting all properties.
function y_finish_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in x_axis.
function x_axis_Callback(hObject, eventdata, handles)
% hObject    handle to x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x_selection = get(hObject,'Value');

% Hints: contents = cellstr(get(hObject,'String')) returns x_axis contents as cell array
%        contents{get(hObject,'Value')} returns selected item from x_axis


% --- Executes during object creation, after setting all properties.
function x_axis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_axis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_start_Callback(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_start as text
%        str2double(get(hObject,'String')) returns contents of x_start as a double


% --- Executes during object creation, after setting all properties.
function x_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x_finish_Callback(hObject, eventdata, handles)
% hObject    handle to x_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_finish as text
%        str2double(get(hObject,'String')) returns contents of x_finish as a double


% --- Executes during object creation, after setting all properties.
function x_finish_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function film_shear_Callback(hObject, eventdata, handles)
% hObject    handle to film_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of film_shear as text
%        str2double(get(hObject,'String')) returns contents of film_shear as a double


% --- Executes during object creation, after setting all properties.
function film_shear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to film_shear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function film_viscosity_Callback(hObject, eventdata, handles)
% hObject    handle to film_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of film_viscosity as text
%        str2double(get(hObject,'String')) returns contents of film_viscosity as a double


% --- Executes during object creation, after setting all properties.
function film_viscosity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to film_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function film_height_Callback(hObject, eventdata, handles)
% hObject    handle to film_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of film_height as text
%        str2double(get(hObject,'String')) returns contents of film_height as a double


% --- Executes during object creation, after setting all properties.
function film_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to film_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function film_density_Callback(hObject, eventdata, handles)
% hObject    handle to film_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of film_density as text
%        str2double(get(hObject,'String')) returns contents of film_density as a double


% --- Executes during object creation, after setting all properties.
function film_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to film_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bulk_viscosity_Callback(hObject, eventdata, handles)
% hObject    handle to bulk_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bulk_viscosity as text
%        str2double(get(hObject,'String')) returns contents of bulk_viscosity as a double


% --- Executes during object creation, after setting all properties.
function bulk_viscosity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bulk_viscosity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bulk_density_Callback(hObject, eventdata, handles)
% hObject    handle to bulk_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bulk_density as text
%        str2double(get(hObject,'String')) returns contents of bulk_density as a double


% --- Executes during object creation, after setting all properties.
function bulk_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bulk_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf1_Callback(hObject, eventdata, handles)
% hObject    handle to sf1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf1 as text
%        str2double(get(hObject,'String')) returns contents of sf1 as a double


% --- Executes during object creation, after setting all properties.
function sf1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double


% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf3_Callback(hObject, eventdata, handles)
% hObject    handle to sf3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf3 as text
%        str2double(get(hObject,'String')) returns contents of sf3 as a double


% --- Executes during object creation, after setting all properties.
function sf3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf5_Callback(hObject, eventdata, handles)
% hObject    handle to sf5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf5 as text
%        str2double(get(hObject,'String')) returns contents of sf5 as a double


% --- Executes during object creation, after setting all properties.
function sf5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf11_Callback(hObject, eventdata, handles)
% hObject    handle to sf11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf11 as text
%        str2double(get(hObject,'String')) returns contents of sf11 as a double


% --- Executes during object creation, after setting all properties.
function sf11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf13_Callback(hObject, eventdata, handles)
% hObject    handle to sf13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf13 as text
%        str2double(get(hObject,'String')) returns contents of sf13 as a double


% --- Executes during object creation, after setting all properties.
function sf13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf7_Callback(hObject, eventdata, handles)
% hObject    handle to sf7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf7 as text
%        str2double(get(hObject,'String')) returns contents of sf7 as a double


% --- Executes during object creation, after setting all properties.
function sf7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sf9_Callback(hObject, eventdata, handles)
% hObject    handle to sf9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sf9 as text
%        str2double(get(hObject,'String')) returns contents of sf9 as a double


% --- Executes during object creation, after setting all properties.
function sf9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sf9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd1_Callback(hObject, eventdata, handles)
% hObject    handle to sd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd1 as text
%        str2double(get(hObject,'String')) returns contents of sd1 as a double


% --- Executes during object creation, after setting all properties.
function sd1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd3_Callback(hObject, eventdata, handles)
% hObject    handle to sd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd3 as text
%        str2double(get(hObject,'String')) returns contents of sd3 as a double


% --- Executes during object creation, after setting all properties.
function sd3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd5_Callback(hObject, eventdata, handles)
% hObject    handle to sd5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd5 as text
%        str2double(get(hObject,'String')) returns contents of sd5 as a double


% --- Executes during object creation, after setting all properties.
function sd5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd13_Callback(hObject, eventdata, handles)
% hObject    handle to sd13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd13 as text
%        str2double(get(hObject,'String')) returns contents of sd13 as a double


% --- Executes during object creation, after setting all properties.
function sd13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd9_Callback(hObject, eventdata, handles)
% hObject    handle to sd9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd9 as text
%        str2double(get(hObject,'String')) returns contents of sd9 as a double


% --- Executes during object creation, after setting all properties.
function sd9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd7_Callback(hObject, eventdata, handles)
% hObject    handle to sd7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd7 as text
%        str2double(get(hObject,'String')) returns contents of sd7 as a double


% --- Executes during object creation, after setting all properties.
function sd7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sd11_Callback(hObject, eventdata, handles)
% hObject    handle to sd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sd11 as text
%        str2double(get(hObject,'String')) returns contents of sd11 as a double


% --- Executes during object creation, after setting all properties.
function sd11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sd11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in text_results.
function text_results_Callback(hObject, eventdata, handles)
% hObject    handle to text_results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of text_results



function results_Callback(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of results as text
%        str2double(get(hObject,'String')) returns contents of results as a double


% --- Executes during object creation, after setting all properties.
function results_CreateFcn(hObject, eventdata, handles)
% hObject    handle to results (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
