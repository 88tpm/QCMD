function [output]=full_QCMD(inputs,controls,graphs)

%   Simulates a full QCM-D response to changes in the viscoelastic properties 
%   of a thin film and the solution surrounding it. It can simulate a full
%   QCMD responce with protein adsorption steps and a buffer wash.
%   © 2015 T.P. McNamara and C.F. Blanford
% 
% -------------------------------------------------------------------------
%   >>Inputs<<
% 
% **************************Inputs structure*******************************
%   .base_solvent -------> [density (kg m^-3),viscosity (Pa s)]
%       buffer density and viscosity
%   .modifier_conc ------> [concentration (kg m^?3) = (g l^-1)]
%       concentration of enzyme solution
%   .density_constant ---> [density constant]
%       the ratio of how the enzyme concentration effects the density of
%       the bulk solution
%   .viscosity_constant > [Enzyme viscosity constant, Huggins constant]
%       the ratio of how the enzyme concentration effects the viscosity of
%       the bulk solution. The value of the Huggins constant
% 
% *************************Controls structure******************************
%   .time ---------------> [T_start (s), T_end (s)]
%       the range in time the simulation will run from T_start to T_end
%   .time_step ----------> [T_step (s)]
%       length of the timestep
%   .basline_time -------> [baseline (s)]
%       how long the initial basline runs for before any protein is added
%   .slug_time ----------> [time (s), exponential decay constant (s)]
%       the sensor was left in the enzyme solution for "time" seconds and
%       whos concentration will decay exponentially with "decay constant"
%       when the flow is switched back to neat buffer
%   .coverage -----------> K_on constant [K_on]
%       the fractional amount of proteins that will adhere to the surface
%       of the sensor
% 
%   vary?: 1 or TRUE then the variable will take the fixed/static
%   value, 0 or FALSE then value will be as an exponential decay
% 
%   .thickness ----------> layer thickness [vary? (Boolean),fixed value (m),coverage to thickness ratio]
%   .viscosity ----------> layer viscosity [vary?,fixed value (Pa s)]
%   .shear --------------> layer shear value [vary?,fixed value (Pa)]
%   .density ------------> layer density [vary?,fixed density (kg m^-3)]
% 
% ******************************Graphs structure***************************
% Set the variable to 1 or TRUE to display the graphs you want. The QCM-D 
% frequency and dissipation response will be plotted automatically.
%   .normalise -----> set to one or true will divide the resonance by its harmonic
%   .D_vs_F -------------> [plot?, harmonic number]
%       set plot? to 1 or TRUE to plot the graph
%       Harmonic number: 1 = 1st harmonic, 2 = 3rd harmonic, etc.
%   .f0
%       plots the base frequency with time
%   .sol_viscosity
%       plots the solution viscosity with time 
%   .sol_density
%       plots the solution density with time
%   .shear
%       plots the film's shear value with time
%   .viscosity
%       plots the film's viscosity with time
%   .coverage
%       plots the coverage of the enzyme over the sensor with time
%   .conc
%       plots the concentration of enzyme in the bulk solution with time
%   .density
%       plots the film's density with time
%   .thickness
%       plots the film's thickness with time
% -------------------------------------------------------------------------      
%   <<Outputs>>
% 
% ******************************Output structure***************************
%   .time
%       time in seconds
%   .sol_visc
%       solution viscosity in SI units as a function of time
%   .lay_visc
%       layer viscosity in SI units as a function of time
%   .sol_dens
%       solution density in SI units as a function of time
%   .lay_dens
%       layer density in SI units as a function of time
%   .lay_shear
%       layer shear modulus in SI units as a function of time
%   .lay_thick
%       layer thickness in SI units as a function of time
%   .cov
%       fractional surface coverage as a function of time
%   .conc
%       concentration of the enzyme in the bulk solution in SI units as a function of time
%   .f0
%       base frequency of the crystal in Hz
%   .frequency
%       frequency response as a function of time in Hz for harmonics 1, 3, 5, 7, 9, 11 and 13
%   .dissipation
%       dissipation response as a function of time in ppm for harmonics 1, 3, 5, 7, 9, 11 and 13
% -------------------------------------------------------------------------

% Assigning memory
steps = ceil(abs(controls.time(2)-controls.time(1))/controls.time_step)+1;
output.time = zeros(steps,1);
output.sol_visc = zeros(steps,1);
output.lay_visc = zeros(steps,1);
output.sol_dens = zeros(steps,1);
output.lay_dens = zeros(steps,1);
output.lay_shear = zeros(steps,1);
output.lay_thick = zeros(steps,1);
output.cov = zeros(steps,1);
output.conc = zeros(steps,1);
output.f0 = zeros(steps,1);
output.frequency = zeros(steps,7);
output.dissipation = zeros(steps,7);
temp.f = zeros(1,7);
temp.d = zeros(1,7);

% Running checks
if controls.thickness(1)+controls.viscosity(1)+controls.shear(1)+controls.density(1)+controls.f0(1) > 1
    error('You have selected too many of the variable to vairy with time in the controls panel')
elseif controls.thickness(1)+controls.viscosity(1)+controls.shear(1)+controls.density(1)+controls.f0(1) < 1
    error('You arre not vairying any of the variables with time under the controls panel')
end
    
% Creating time! 
output.time(:,1) = (controls.time(1):controls.time_step:controls.time(2));

% TEMP Creating modifier conc exp decay with time
output.sol_dens(:,1)=inputs.modifier_conc(1)*(exp(-output.time(:,1)/controls.slug_time(2)));
% Shifting modifier conc change to correct start, end and exp points
control_subloop_1_1 = 1;
for control_loop_1 = 1:steps;
    if output.time(control_loop_1,1) < controls.baseline_time;
       output.conc(control_loop_1,1)= 0;
    elseif output.time(control_loop_1,1) < (controls.baseline_time+controls.slug_time(1));
           output.conc(control_loop_1,1)= inputs.modifier_conc(1);  
    else
        output.conc(control_loop_1,1)=output.sol_dens(control_subloop_1_1,1);
        control_subloop_1_1 = control_subloop_1_1+1;
    end
end

% Populating solution bulk density
output.sol_dens(:,1) = output.conc(:,1)*inputs.density_constant+inputs.base_solvent(1);
% Populating solution bulk viscosity
output.sol_visc(:,1) = ((output.conc(:,1).*(inputs.viscosity_constant(1)+(inputs.viscosity_constant(2)*inputs.viscosity_constant(1)^2*output.conc(:,1))))+1)*inputs.base_solvent(2); % (conc * ([eta] + huggins * [eta]^2 * conc) + 1)*eta_buffer

% Creating coverage
output.cov(1,1) = 1-exp(output.conc(1,1)*controls.coverage(1)*controls.time_step(1));
for control_loop_2 = 2:steps;
output.cov(control_loop_2,1) = output.cov(control_loop_2-1,1)+controls.coverage*(1-output.cov(control_loop_2-1))*output.conc(control_loop_2,1)*controls.time_step; % phi(t) = phi(t-deltat) + k_on*(1-phi(t-deltat))*conc(t-deltat)*deltat
end

% Populating layer thickness
if controls.thickness(1)
    output.lay_thick(:,1)=output.cov(:,1)*controls.thickness(2);
else
    output.lay_thick(:,1)=controls.thickness(2);
end

% Populating layer density
if controls.density(1)
    output.lay_dens(:,1) = controls.density(2)*output.cov(:,1)+1e-10;
else
    output.lay_dens(:,1) = controls.density(2);
end
% Populating layer viscosity
if controls.viscosity(1)==0
    output.lay_visc(:,1)=controls.viscosity(2);
end

% Populating layer shear value
if controls.shear(1)==0
    output.lay_shear(:,1)=controls.shear(2);
end

% Populating f0 value
if controls.f0(1)==0
    output.f0(:,1)=controls.f0(2);
end

% Calculating F and D
[temp.f(1,:),temp.d(1,:)]=voigt_rel(output.lay_dens(1,1),output.lay_shear(1,1),output.lay_visc(1,1),output.lay_thick(1,1),output.sol_dens(1,1),output.sol_visc(1,1),output.f0(1,1));
for control_loop_3 = 1:steps;
    [output.frequency(control_loop_3,:),output.dissipation(control_loop_3,:)]=voigt_rel(output.lay_dens(control_loop_3,1),output.lay_shear(control_loop_3,1),output.lay_visc(control_loop_3,1),output.lay_thick(control_loop_3,1),output.sol_dens(control_loop_3,1),output.sol_visc(control_loop_3,1),output.f0(control_loop_3,1));
     output.frequency(control_loop_3,:) = output.frequency(control_loop_3,:)-temp.f(1,:);
     output.dissipation(control_loop_3,:) = output.dissipation(control_loop_3,:)-temp.d(1,:);
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
graph = 1+graphs.thickness(1)+graphs.density(1)+graphs.conc(1)+graphs.coverage(1)+graphs.viscosity(1)+graphs.shear(1)+graphs.sol_density(1)+graphs.sol_viscosity(1)+graphs.f0(1)+graphs.D_vs_F(1);
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
if graphs.f0
    figure(graph-graph_count)
    plot(output.time(:,1),output.f0(:,:))
    title('f0');
    xlabel('Time / s')
    ylabel(Freq)
    graph_count = graph_count+1;
end
if graphs.sol_viscosity
    figure(graph-graph_count)
    plot(output.time(:,1),output.sol_visc(:,1))
    title('Solution Viscosity');
    xlabel('Time / s')
    ylabel('Viscosity / Pa s')
    graph_count = graph_count+1;
end
if graphs.sol_density
    figure(graph-graph_count)
    plot(output.time(:,1),output.sol_dens(:,1))
    title('Solution Density');
    xlabel('Time / s')
    ylabel('Density / kg m^-3')
    graph_count = graph_count+1;
end
if graphs.shear
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_shear(:,1))
    title('Layer Shear Modulus');
    xlabel('Time / s')
    ylabel('Shear Modulus/ Pa')
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
if graphs.coverage
    figure(graph-graph_count)
    plot(output.time(:,1),output.cov(:,1))
    title('Sensor Coverage');
    xlabel('Time / s')
    ylabel('Fractional coverage')
    graph_count = graph_count+1;
end
if graphs.conc
    figure(graph-graph_count)
    plot(output.time(:,1),output.conc(:,1))
    title('Solution Concentration of Modifier');
    xlabel('Time / s')
    ylabel('Concentration / kg m^-3')
    graph_count = graph_count+1;
end
if graphs.density
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_dens(:,1))
    title('Layer Density');
    xlabel('Time / s')
    ylabel('Density / kg m^-3')
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
 if graphs.D_vs_F
     figure(graph-graph_count)
     plot(output.dissipation(:,graphs.D_vs_F(2)),output.frequency(:,graphs.D_vs_F(2)))
     title('D vs F');
     xlabel('Dissipation / ppm')
     ylabel('Frequency / Hz')
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