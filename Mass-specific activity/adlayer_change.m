function [output]=adlayer_change(controls,graphs)

%   Simulates the QCM-D response to changes in the viscoelastic properties 
%   of a thin film and the solution surrounding it. When run it will print
%   a text summary to the main console about what is being modelled.
%   © 2015 T.P. McNamara and C.F. Blanford
% 
% -------------------------------------------------------------------------
%   >>Inputs<<
% 
% *************************Controls structure******************************
% 
%   .time -----------> [T_start (s), T_end (s)]
%       the range in time the simulation will run from T_start to T_end
%   .time_step -----> [T_step (s)]
%       length of the timestep in seconds
%   .thickness -----> [final thuickness (m),initial thickness (m), decay constant (s)]
%       layer thickness from initial thickness to final thickness with an
%       exponential decay of decay constant.
%   .sol_visc ------> [final viscosity (Pa s),initial viscosity (Pa s), decay constant (s)]
%       solution viscosity from initial viscosity to final viscosity with an
%       exponential decay of decay constant
%   .sol_dens ------> [final density (kg m^-3),initial density (kg m^-3), decay constant (s)]
%       solution density from initial density to final density with an
%       exponential decay of decay constant
%   .density -------> [initial density of the layer (kg m^-3), time constant (s)]
%       layer density with an initial density and the exponential time
%       constant with which it changes
%   .DPI_density ---> [start (kg m^-3), finish (kg m^-3)]
%       initial and final densities of the layer density from DPI measurments.
%       The code takes the inital density of the layer from
%       controls.density and calculates the final density based on the
%       fractional increase in the DPI start and end densities. For
%       example, if .density = [1000, 100] and .DPI_density = [2, 4] then the initial
%       density of the layer would be 1000 the final would be 2000 and the
%       exponential constant would be 100
%   .viscosity -----> [final viscosity (Pa s),initial viscosity (Pa s), decay constant (s)]
%       viscosity of the layer from initial viscosity to final viscosity with an
%       exponential decay of decay constant
%   .shear ---------> [final shear (Pa),initial shear (Pa), decay constant (s)]
%       shear value of the layer from initial shear to final shear with an
%       exponential decay of decay constant
%   .f0 ------------> / Hz
%       fundamental resonance frequency of the crystal
%   .conserve_mass -> BOOLEAN
%       set to 1 or TRUE to conserve mass, in this case only the initial 
%       .thickness value will be used and the thickness will then vary
%       according to the film density to keep the mass on the surface constant.
%       Set to 0 or FALSE to take the manual .thickness values, this
%       means that density and thickness of the layer will independantly
%       vary so the mass on the surface will not be conserved
% 
% ******************************Graphs structure***************************
% Set the variable to 1 or TRUE to display the graphs you want. The QCM-D 
% frequency and dissipation response will be plotted automatically.
%   .normalise -----> set to one or true will divide the resonance by its harmonic
%   .D_vs_F -------------> [plot?, harmonic number]
%       set plot? to 1 or TRUE to plot the graph
%       Harmonic number: 1 = 1st harmonic, 2 = 3rd harmonic, etc.
%   .D_F_T --------> [plot?, 3D?]
%       D vs F vs time plot. Set plot to one to plot the graph
%       and 3D to one if you want it in 3D wall view. Red is frequency,
%       blue is dissipation and purple is time
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
%   .density
%       plots the film's density with time
%   .thickness
%       plots the film's thickness with time
%       
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

% Creating time! 
output.time(:,1) = (controls.time(1):controls.time_step:controls.time(2));

% Populating solution bulk density
if controls.sol_dens(1) == controls.sol_dens(2)
output.sol_dens(:,1) = controls.sol_dens(1);
sol_dens_con = 'solution density, ';
sol_dens_vai = '';
else
output.sol_dens(:,1) = controls.sol_dens(1)+(controls.sol_dens(2)-controls.sol_dens(1))*(exp(-output.time(:,1)/controls.sol_dens(3)));
sol_dens_con = '';
sol_dens_vai = 'solution density, ';
end

% Populating solution bulk viscosity
if controls.sol_visc(1) == controls.sol_visc(2)
output.sol_visc(:,1) = controls.sol_visc(1);
sol_visc_con = 'solution viscosity, ';
sol_visc_vai = '';
else
output.sol_visc(:,1) = controls.sol_visc(1)+(controls.sol_visc(2)-controls.sol_visc(1))*(exp(-output.time(:,1)/controls.sol_visc(3)));
sol_visc_con = '';
sol_visc_vai = 'solution viscosity, ';
end

% Creating density with time
if controls.DPI_density(1) == controls.DPI_density(2)
    output.lay_dens(:,1) = controls.density(1); % density constant
    dens_con = 'density, ';
    dens_vai = '';
else
    max_density = controls.density(1)*(controls.DPI_density(2)/controls.DPI_density(1));
    output.lay_dens(:,1) = max_density-(max_density-controls.density(1))*exp(-output.time(:,1)/controls.density(2));
    dens_con = '';
    dens_vai = 'density, ';
end

% Creating thickness with time
if controls.conserve_mass
    output.lay_thick(:,1) = (controls.thickness(2)*controls.density(1))./output.lay_dens(:,1); % mass conserved
    if controls.DPI_density(1) == controls.DPI_density(2)
        thick_con = 'thickness, ';
        thick_vai = '';
        m_text = '';
    else
        thick_con = '';
        thick_vai = 'thickness, ';
        m_text = 'Mass conserved';
    end
elseif controls.thickness(1) == controls.thickness(2)
    output.lay_thick(:,1) = controls.thick(2); % thickness constant
    m_text = 'Mass unconserved';
    thick_con = 'thickness, ';
    thick_vai = '';
else
    output.lay_thick(:,1) = controls.thickness(1)+(controls.thickness(2)-controls.thickness(1))*(exp(-output.time(:,1)/controls.thickness(3))); % non-conserved
    m_text = 'Mass unconserved';
    thick_con = '';
    thick_vai = 'thickness, ';
end

% Populating layer viscosity
if controls.viscosity(1) == controls.viscosity(2)
output.lay_visc(:,1) = controls.viscosity(1);
visc_con = 'viscosity, ';
visc_vai = '';
else
output.lay_visc(:,1) = controls.viscosity(1)+(controls.viscosity(2)-controls.viscosity(1))*(exp(-output.time(:,1)/controls.viscosity(3)));
visc_con = '';
visc_vai = 'viscosity, ';
end

% Populating layer shear value
if controls.shear(1) == controls.shear(2)
output.lay_visc(:,1) = controls.viscosity(1);
shea_con = 'shear, ';
shea_vai = '';
else
output.lay_shear(:,1) = controls.shear(1)+(controls.shear(2)-controls.shear(1))*(exp(-output.time(:,1)/controls.shear(3)));
shea_con = '';
shea_vai = 'shear, ';
end
% Populating f0 value
output.f0(:,1)=output.f0(:,1)+controls.f0;

% Text responce to input
disp(m_text)
if (controls.thickness(3)==controls.viscosity(3)) && (controls.thickness(3)==controls.shear(3)) && (controls.thickness(3)==controls.density(2)) && (controls.thickness(3)==controls.sol_visc(3)) && (controls.thickness(3)==controls.sol_dens(3))
	disp('Time constants all match')
else
    disp('Non-equal time constants')
end
disp(strcat(['Constant: ',sol_visc_con,sol_dens_con,thick_con,dens_con,visc_con,shea_con]))
disp(strcat(['Changing: ',sol_visc_vai,sol_dens_vai,thick_vai,dens_vai,visc_vai,shea_vai]))
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
graph = 1+graphs.thickness(1)+graphs.density(1)+graphs.viscosity(1)+graphs.shear(1)+graphs.sol_density(1)+graphs.sol_viscosity(1)+graphs.f0(1)+graphs.D_vs_F(1)+graphs.D_F_T(1);
graph_count = 0;

% Plotting graphs & world domination ...
 if graphs.normalise
     Freq = 'Normalised Frequency / Hz';
 else
     Freq = 'Frequency / Hz';
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
    ylabel('Shear / Pa')
    graph_count = graph_count+1;
end
if graphs.viscosity
    figure(graph-graph_count)
    plot(output.time(:,1),output.lay_visc(:,1))
    title('Layer Viscosity');
    xlabel('Time / s')
    ylabel('Viscosity / Pa s');
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
if graphs.D_vs_F(1)
    figure(graph-graph_count)
    plot(output.frequency(:,graphs.D_vs_F(2)),output.dissipation(:,graphs.D_vs_F(2)))
    title('D vs F Plot');
    xlabel('Change in Frequency / Hz')
    ylabel('Change in Dissipation / ppm')
end
figure(1)
subplot(2,1,1)
plot(output.time(:,1),output.frequency(:,:))
title('Frequency');
xlabel('Time')
ylabel(Freq)
subplot(2,1,2)
plot(output.time(:,1),output.dissipation(:,:))
legend('harmonic 1','harmonic 3','harmonic 5','harmonic 7','harmonic 9','harmonic 11','harmonic 13');
title('Dissipation');
xlabel('Time / s')
ylabel('Dissipation / ppm')
 if graphs.D_F_T(1)
    plot_3D(output.frequency(:,graphs.D_vs_F(2)),output.dissipation(:,graphs.D_vs_F(2)),output.time(:,1));
    if graphs.D_F_T(2)
    go_3D
    end
 end
