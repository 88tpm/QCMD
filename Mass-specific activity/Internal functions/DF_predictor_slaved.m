function [frequency,dissipation]=DF_predictor_slaved(time,time_step,solution,shear,viscosity,thickness,density,f0,normalise)

% This function simulates a D vs F plot from exponential changes in shear,
% viscostity thickness and density with independant time constants. It is
% slaved to macro_DF_predictor.
% 
% *********************************Controls*******************************
% "time" -------------> the range in time the simulation will run [T_start (s), T_end (s)]
% "time_step" --------> length of the timestep in seconds [T_step (s)]
% "solution" ---------> properties of the solution [density (kg/m^3),viscosity (***)]
% "f0" ---------------> frequency of the crystal / Hz
% "run-all -----------> used with macro to run all 9 simulations and plot a graph
% The next four are what is vaired in this model and are made up of a 5 numbered vector
% 1 Direction of change     -1 for decrease, 1 for increase, 0 for constant
% 2 Lowest value            Final value if it's decreasing
% 3 Middle value            Starting value of the variable, or constant if unchanging
% 4 Highest value           Final value if it's increasing
% 5 Time constant           Time constant of exponential change in seconds
% "thickness" --------> units m
% "density" ----------> units kg m^-3
% "viscosity ---------> units Pa s
% "shear" ------------> units Pa
% 
% **********************************Graphs********************************
% Place a 1 next to the graphs you want, the F&D plot will be created automatically
% normalise ----------> if set to one will divide the resonance by it's harmonic
% D_vs_F -------------> [1 for plot this graph, harmonic number to plot,1=1, 2=3, 3=5, 4=7 etc]
% D_F_Ln -------------> D vs F plot with Ln plots on z [plot?,manipulatabel 3D?]
% all_harmonics ------> if ture will plot D_vs_F for all harmonics 1 to 13

% Creating RAM storage for function
steps = ceil(abs(time(2)-time(1))/time_step)+1;
output.time = zeros(steps,1);
output.sol_visc = zeros(steps,1);
output.lay_visc = zeros(steps,1);
output.sol_dens = zeros(steps,1);
output.lay_dens = zeros(steps,1);
output.lay_shear = zeros(steps,1);
output.lay_thick = zeros(steps,1);
output.f0 = zeros(steps,1);
frequency = zeros(steps,7);
dissipation = zeros(steps,7);
temp.f = zeros(1,7);
temp.d = zeros(1,7);

% Creating time! 
output.time(:,1) = (time(1):time_step:time(2));

% Populating solution bulk density
output.sol_dens(:,1) = output.sol_dens(:,1)+solution(1);
% Populating solution bulk viscosity
output.sol_visc(:,1) = output.sol_visc(:,1)+solution(2);

% Creating shear with time
if shear(1) == 1
    output.lay_shear(:,1) = shear(4)+(shear(3)-shear(4))*(exp(-output.time(:,1)/shear(5)));
elseif shear(1) == -1
    output.lay_shear(:,1) = shear(2)+(shear(3)-shear(2))*(exp(-output.time(:,1)/shear(5)));
elseif shear(1) == 0
    output.lay_shear(:,1) = shear(3);
else
    disp('ERROR - the first value of shear needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating viscosity with time
if viscosity(1) == 1
    output.lay_visc(:,1) = viscosity(4)+(viscosity(3)-viscosity(4))*(exp(-output.time(:,1)/viscosity(5)));
elseif viscosity(1) == -1
    output.lay_visc(:,1) = viscosity(2)+(viscosity(3)-viscosity(2))*(exp(-output.time(:,1)/viscosity(5)));
elseif viscosity(1) == 0
    output.lay_visc(:,1) = viscosity(3);
else
    disp('ERROR - the first value of viscosity needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating thickness with time
if thickness(1) == 1
    output.lay_thick(:,1) = thickness(4)+(thickness(3)-thickness(4))*(exp(-output.time(:,1)/thickness(5)));
elseif thickness(1) == -1
    output.lay_thick(:,1) = thickness(2)+(thickness(3)-thickness(2))*(exp(-output.time(:,1)/thickness(5)));
elseif thickness(1) == 0
    output.lay_thick(:,1) = thickness(3);
else
    disp('ERROR - the first value of thickness needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating density with time
if density(1) == 1
    output.lay_dens(:,1) = density(4)+(density(3)-density(4))*(exp(-output.time(:,1)/density(5)));
elseif density(1) == -1
    output.lay_dens(:,1) = density(2)+(density(3)-density(2))*(exp(-output.time(:,1)/density(5)));
elseif density(1) == 0
    output.lay_dens(:,1) = density(3);
else
    disp('ERROR - the first value of density needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Populating f0 value
output.f0(:,1)=output.f0(:,1)+f0(1);

% Calculating F and D
[temp.f(1,:),temp.d(1,:)]=voigt_rel(output.lay_dens(1,1),output.lay_shear(1,1),output.lay_visc(1,1),output.lay_thick(1,1),output.sol_dens(1,1),output.sol_visc(1,1),output.f0(1,1));
for control_loop_3 = 1:steps;
    [frequency(control_loop_3,:),dissipation(control_loop_3,:)]=voigt_rel(output.lay_dens(control_loop_3,1),output.lay_shear(control_loop_3,1),output.lay_visc(control_loop_3,1),output.lay_thick(control_loop_3,1),output.sol_dens(control_loop_3,1),output.sol_visc(control_loop_3,1),output.f0(control_loop_3,1));
end
dissipation = dissipation*1e6;
if normalise
    a = 1;
    for b = 2:7;
    frequency(:,b) = frequency(:,b)/(a+b);
    a = a+1;
    end
end