function [output]=DF_predictor_core(controls,graphs)

% This function simulates a D vs F plot from exponential changes in shear,
% viscostity thickness and density with independant time constants.
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
steps = ceil(abs(controls.time(2)-controls.time(1))/controls.time_step)+1;
output.time = zeros(steps,1);
output.sol_visc = zeros(steps,1);
output.lay_visc = zeros(steps,1);
output.sol_dens = zeros(steps,1);
output.lay_dens = zeros(steps,1);
output.lay_shear = zeros(steps,1);
output.lay_thick = zeros(steps,1);
output.f0 = zeros(steps,1);
output.frequency = zeros(steps,7);
output.dissipation = zeros(steps,7);
temp.f = zeros(1,7);
temp.d = zeros(1,7);

% Creating time! 
output.time(:,1) = (controls.time(1):controls.time_step:controls.time(2));

% Populating solution bulk density
output.sol_dens(:,1) = output.sol_dens(:,1)+controls.solution(1);
% Populating solution bulk viscosity
output.sol_visc(:,1) = output.sol_visc(:,1)+controls.solution(2);

% Creating shear with time
if controls.shear(1) == 1
    output.lay_shear(:,1) = controls.shear(4)+(controls.shear(3)-controls.shear(4))*(exp(-output.time(:,1)/controls.shear(5)));
elseif controls.shear(1) == -1
    output.lay_shear(:,1) = controls.shear(2)+(controls.shear(3)-controls.shear(2))*(exp(-output.time(:,1)/controls.shear(5)));
elseif controls.shear(1) == 0
    output.lay_shear(:,1) = controls.shear(3);
else
    disp('ERROR - the first value of shear needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating viscosity with time
if controls.viscosity(1) == 1
    output.lay_visc(:,1) = controls.viscosity(4)+(controls.viscosity(3)-controls.viscosity(4))*(exp(-output.time(:,1)/controls.viscosity(5)));
elseif controls.viscosity(1) == -1
    output.lay_visc(:,1) = controls.viscosity(2)+(controls.viscosity(3)-controls.viscosity(2))*(exp(-output.time(:,1)/controls.viscosity(5)));
elseif controls.viscosity(1) == 0
    output.lay_visc(:,1) = controls.viscosity(3);
else
    disp('ERROR - the first value of viscosity needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating thickness with time
if controls.thickness(1) == 1
    output.lay_thick(:,1) = controls.thickness(4)+(controls.thickness(3)-controls.thickness(4))*(exp(-output.time(:,1)/controls.thickness(5)));
elseif controls.thickness(1) == -1
    output.lay_thick(:,1) = controls.thickness(2)+(controls.thickness(3)-controls.thickness(2))*(exp(-output.time(:,1)/controls.thickness(5)));
elseif controls.thickness(1) == 0
    output.lay_thick(:,1) = controls.thickness(3);
else
    disp('ERROR - the first value of thickness needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Creating density with time
if controls.density(1) == 1
    output.lay_dens(:,1) = controls.density(4)+(controls.density(3)-controls.density(4))*(exp(-output.time(:,1)/controls.density(5)));
elseif controls.density(1) == -1
    output.lay_dens(:,1) = controls.density(2)+(controls.density(3)-controls.density(2))*(exp(-output.time(:,1)/controls.density(5)));
elseif controls.density(1) == 0
    output.lay_dens(:,1) = controls.density(3);
else
    disp('ERROR - the first value of density needs to be -1 for decrease, 0 for constant, or 1 for increase. Please fix this and re-run')
end

% Populating f0 value
output.f0(:,1)=output.f0(:,1)+controls.f0(1);

% Calculating F and D
[temp.f(1,:),temp.d(1,:)]=voigt_rel(output.lay_dens(1,1),output.lay_shear(1,1),output.lay_visc(1,1),output.lay_thick(1,1),output.sol_dens(1,1),output.sol_visc(1,1),output.f0(1,1));
for control_loop_3 = 1:steps;
    [output.frequency(control_loop_3,:),output.dissipation(control_loop_3,:)]=voigt_rel(output.lay_dens(control_loop_3,1),output.lay_shear(control_loop_3,1),output.lay_visc(control_loop_3,1),output.lay_thick(control_loop_3,1),output.sol_dens(control_loop_3,1),output.sol_visc(control_loop_3,1),output.f0(control_loop_3,1));
end
output.dissipation = output.dissipation*1e6;
if graphs.normalise
    a = 1;
    for b = 2:7;
    output.frequency(:,b) = output.frequency(:,b)/(a+b);
    a = a+1;
    end
end

% Populating graph constants
graph = 1+graphs.thickness(1)+graphs.density(1)+graphs.viscosity(1)+graphs.shear(1)+graphs.D_vs_F(1);
graph_count = 0;

% Plotting graphs & world domination ...
Diss = 'Dissipation / ppm';
 if graphs.normalise
     Freq = 'Normalised Frequency / Hz';
%      Diss = 'Normalised Dissipation / ppm';
 else
     Freq = 'Frequency / Hz';
%      Diss = 'Dissipation / ppm';
 end
if graphs.shear
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_shear(:,1))
    title('Layer Shear Value');
    xlabel('Time / s')
    ylabel('Shear / Pa')
    graph_count = graph_count+1;
end
if graphs.viscosity
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_visc(:,1))
    title('Layer Viscosity');
    xlabel('Time / s')
    ylabel('Viscosity / Pa s')
    graph_count = graph_count+1;
end
if graphs.density
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_dens(:,1))
    title('Layer Density');
    xlabel('Time / s')
    ylabel('Density / kg/m^3')
    graph_count = graph_count+1;
end
if graphs.thickness
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_thick(:,1))
    title('Layer Thickness');
    xlabel('Time / s')
    ylabel('Thickness / m')
    graph_count = graph_count+1;
end
figure(1)
subplot(2,1,1)
plot(output.time(:,1),output.frequency(:,:))
title('Frequency');
xlabel('Time / s')
ylabel(Freq)
subplot(2,1,2)
plot(output.time(:,1),output.dissipation(:,:))
title('Dissipation');
xlabel('Time / s')
ylabel(Diss)
 if graphs.D_vs_F % Calls my functions to do a decent D vs F plot
     if graphs.all_harmonics  
     DvsF_2D_all(output.frequency(:,1),output.dissipation(:,1),output.frequency(:,2),output.dissipation(:,2),output.frequency(:,3),output.dissipation(:,3),output.frequency(:,4),output.dissipation(:,4),output.frequency(:,5),output.dissipation(:,5),output.frequency(:,6),output.dissipation(:,6),output.frequency(:,7),output.dissipation(:,7));
     else
     DvsF_2D(output.frequency(:,graphs.D_vs_F(2)),output.dissipation(:,graphs.D_vs_F(2)));
     end
 end