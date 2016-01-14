function DF_predictor(controls,graphs)

%   This function simulates a dissipation vs. frequency plot from 
%   exponential changes in shear, viscosity, thickness and density, each
%   with independent time constants.
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
%       length of the timestep
%   .solution ---------> [density (kg m^-3),viscosity (Pa s)]
%       properties of the solution
%   .f0 ---------------> [frequency (Hz)]
%       base frequency of the crystal
%   .run_thickness ----> BOOLEAN
%       set to 1 or TRUE to vary thickness
%   .run_viscosity ----> BOOLEAN
%       set to 1 or TRUE to vary viscosity
%   .run_density ------> BOOLEAN
%       set to 1 or TRUE to vary density
%   .run_shear --------> BOOLEAN
%       set to 1 or TRUE to vary shear
%   .run-all ----------> BOOLEAN
%       set to 1 or TRUE to run all combinations of increasing and
%       decreasing for the two selected variables to film parameters.
%       This will run all 9 simulations and plot a graph of the summary
%       plot of the D vs F plots.
%   .thickness --------> [1 x 5 vector] see below
%   .density ----------> [1 x 5 vector] see below
%   .viscosity --------> [1 x 5 vector] see below
%   .shear ------------> [1 x 5 vector] see below
%       Direction of change     -1 for decrease, 1 for increase, 0 for constant
%       Lowest value            Final value of the variable (in SI units) if it's decreasing
%       Middle value            Starting value of the variable (in SI units)
%       Highest value           Final value of the variable (in SI units) if it's increasing
%       Time constant           Time constant of exponential change in seconds
%
%       For example, controls.shear = [-1,3e4,1e5,3e5,120] will decrease
%       the shear modulus from 1e5 Pa to 3e4 Pa with a time constant of 120
%       s. The fourth position is ignored unless controls.run-all = TRUE.
% 
% ******************************Graphs structure***************************
% 1 or true next to the graphs you want, the QCDM frequency and dissipation
% plot will be plotted automatically
%   .normalise -----> BOOLEAN
%       set to one or true will divide the resonance by its harmonic number
%   .D_vs_F --------> [plot?, harmonic number]
%       set plot? to 1 or TRUE to plot the graph.
%       set harmonic number 1 for 1st harmonic, 2 for 3rd harmonic, etc.
%   .thickness
%       plots the film's thickness with time
%   .density
%       plots the film's density with time
%   .viscosity
%       plots the film's viscosity with time
%   .shear
%       plots the film's shear modulus with time
%   .all_harmonics
%       1 or TRUE will plot D_vs_F for all odd harmonics from 1 to 13
%       inclusive
% -------------------------------------------------------------------------

if controls.run_all
    if (controls.run_thickness+controls.run_viscosity+controls.run_density+controls.run_shear)>2
        error('You have more than two variables changing, to .run_all you need two to run, eg run_density and run_shear set to 1');
    elseif (controls.run_thickness+controls.run_viscosity+controls.run_density+controls.run_shear)<2
        error('You have less than two variables changing, to .run_all you need two to run, eg run_density and run_shear set to 1');
    end
    macro_DF_predictor(controls,graphs);
else
    DF_predictor_core(controls,graphs);
end
    
