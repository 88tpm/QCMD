function [output]=macro_DF_predictor(controls,graphs)

% Runs DF_predictor function for all 9 possible outcomes and then plots a 3
% by 3 grid of the D vd F responces for all of the harmonics
% 
% *********************************Controls*******************************
% "time" -------------> the range in time the simulation will run [T_start (s), T_end (s)]
% "time_step" --------> length of the timestep in seconds [T_step (s)]
% "solution" ---------> properties of the solution [density (kg/m^3),viscosity (***)]
% "f0" ---------------> frequency of the crystal / Hz
% The next four are what is vaired in this model and are made up of a 5 numbered vector
% 1 Plot?               Set to 1 if you want it to be vaired
% 2 Lowest value        Final value if it's decreasing
% 3 Middle value        Starting value of the variable, or constant if unchanging
% 4 Highest value       Final value if it's increasing
% 5 Time constant       Time constant of exponential change in seconds
% "thickness" --------> units m
% "density" ----------> units kg m^-3
% "viscosity ---------> units Pa s
% "shear" ------------> units Pa
% "run-all -----------> must be true for this function to run and calls up
% the next four variables to see what to run
% "run_thickness" ----> if true thickness will be varied
% "run_viscosity" ----> if true viscosity will be varied
% "run_density" ------> if true density will be varied
% "run_shear" --------> if true sheer will be varied

% Creating RAM storage for function
steps = ceil(abs(controls.time(2)-controls.time(1))/controls.time_step)+1;

% Column number depicts the sun number/subplot the f & d calculations are for
output.frequency = zeros(steps,7,9);
output.dissipation = zeros(steps,7,9);
temp.thickness = zeros(5,1);
temp.viscosity = zeros(5,1);
temp.density = zeros(5,1);
temp.shear = zeros(5,1);
f1 = zeros(steps,7);
d1 = zeros(steps,7);
f2 = zeros(steps,7);
d2 = zeros(steps,7);
f3 = zeros(steps,7);
d3 = zeros(steps,7);
f4 = zeros(steps,7);
d4 = zeros(steps,7);
f5 = zeros(steps,7);
d5 = zeros(steps,7);
f6 = zeros(steps,7);
d6 = zeros(steps,7);
f7 = zeros(steps,7);
d7 = zeros(steps,7);
f8 = zeros(steps,7);
d8 = zeros(steps,7);
f9 = zeros(steps,7);
d9 = zeros(steps,7);

temp.thickness(:,:) = controls.thickness(:,:);
temp.viscosity(:,:) = controls.viscosity(:,:);
temp.density(:,:) = controls.density(:,:);
temp.shear(:,:) = controls.shear(:,:);

a = 'Thickness '; b = num2str(controls.thickness(3)); c = ' / m'; text_1 = [a b c];
a = 'Viscosity '; b = num2str(controls.viscosity(3)); c = ' / Pa s'; text_2 = [a b c];
a = 'Density '; b = num2str(controls.density(3)); c = ' / kg m^-3'; text_3 = [a b c];
a = 'Shear '; b = num2str(controls.shear(3)); c = ' / Pa'; text_4 = [a b c];
a = 'f0 '; b = num2str(controls.f0(1)); c = ' / Hz'; text_5 = [a b c];
a = 'Time '; b = num2str(controls.time(2)); c = ' / s'; text_6 = [a b c];
a = 'Time step '; b = num2str(controls.time_step(1)); c = ' / s'; text_7 = [a b c];

output_counter = 1;
if controls.run_thickness
    if controls.run_viscosity
        y_upper = strcat('Thickness increase to',num2str(controls.thickness(4)),' m');
        y_mid = strcat('Thickness fixed at ',num2str(controls.thickness(3)),' m');
        y_lower = strcat('Thickness decrease to ',num2str(controls.thickness(2)),' m');
        x_upper = strcat('Viscosity increase to ',num2str(controls.viscosity(4)),' Pa s');
        x_mid = strcat('Viscosity fixed at ',num2str(controls.viscosity(3)),' Pa s');
        x_lower = strcat('Viscosity decrease to ',num2str(controls.viscosity(2)),' Pa s');
        for thick_count = -1:1;
        temp.thickness(1,1) = thick_count;
            for visc_count = -1:1;
            temp.viscosity(1,1) = visc_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
    if controls.run_density
        y_upper = strcat('Thickness increase to ',num2str(controls.thickness(4)),' m');
        y_mid = strcat('Thickness fixed at ',num2str(controls.thickness(3)),' m');
        y_lower = strcat('Thickness decrease to ',num2str(controls.thickness(2)),' m');
        x_upper = strcat('Density increase to ',num2str(controls.density(4)),'kg m^-3');
        x_mid = strcat('Density fixed at ',num2str(controls.density(3)),'kg m^-3');
        x_lower = strcat('Density decrease to ',num2str(controls.density(2)),'kg m^-3');
        y_label = 'Increasing Thickness';
        x_label = 'Increasing Density';
        for thick_count = -1:1;
        temp.thickness(1,1) = thick_count;
            for dens_count = -1:1;
            temp.density(1,1) = dens_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
    if controls.run_shear
        y_upper = strcat('Thickness increase to ',num2str(controls.thickness(4)),' m');
        y_mid = strcat('Thickness fixed at ',num2str(controls.thickness(3)),' m');
        y_lower = strcat('Thickness decrease to ',num2str(controls.thickness(2)),' m');
        x_upper = strcat('Shear increase to ',num2str(controls.shear(4)),' Pa');
        x_mid = strcat('Shear fixed at ',num2str(controls.shear(3)),' Pa');
        x_lower = strcat('Shear decrease to ',num2str(controls.shear(2)),' Pa');
        x_label = 'Increasing Shear';
        for thick_count = -1:1;
        temp.thickness(1,1) = thick_count;
            for shear_count = -1:1;
            temp.shear(1,1) = shear_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
end
if controls.run_viscosity
    if controls.run_density
        y_upper = strcat('Viscosity increase to ',num2str(controls.viscosity(4)),' Pa s');
        y_mid = strcat('Viscosity fixed at ',num2str(controls.viscosity(3)),' Pa s');
        y_lower = strcat('Viscosity decrease to ',num2str(controls.viscosity(2)),' Pa s');
        x_upper = strcat('Density increase to ',num2str(controls.density(4)),'kg m^-3');
        x_mid = strcat('Density fixed at ',num2str(controls.density(3)),'kg m^-3');
        x_lower = strcat('Density decrease to ',num2str(controls.density(2)),'kg m^-3');
        for visc_count = -1:1;
        temp.viscosity(1,1) = visc_count;
            for dens_count = -1:1;
            temp.density(1,1) = dens_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
    if controls.run_shear
        y_upper = strcat('Viscosity increase to ',num2str(controls.viscosity(4)),' Pa s');
        y_mid = strcat('Viscosity fixed at ',num2str(controls.viscosity(3)),' Pa s');
        y_lower = strcat('Viscosity decrease to ',num2str(controls.viscosity(2)),' Pa s');
        x_upper = strcat('Shear increase to ',num2str(controls.shear(4)),' Pa');
        x_mid = strcat('Shear fixed at ',num2str(controls.shear(3)),' Pa');
        x_lower = strcat('Shear decrease to ',num2str(controls.shear(2)),' Pa');
        for visc_count = -1:1
        temp.viscosity(1,1) = visc_count;
            for shear_count = -1:1;
            temp.shear(1,1) = shear_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
end
if controls.run_density
    if controls.run_shear
        y_upper = strcat('Density increase to ',num2str(controls.density(4)),'kg m^-3');
        y_mid = strcat('Density fixed at ',num2str(controls.density(3)),'kg m^-3');
        y_lower = strcat('Density decrease to ',num2str(controls.density(2)),'kg m^-3');
        x_upper = strcat('Shear increase to ',num2str(controls.shear(4)),' Pa');
        x_mid = strcat('Shear fixed at ',num2str(controls.shear(3)),' Pa');
        x_lower = strcat('Shear decrease to ',num2str(controls.shear(2)),' Pa');
        for dens_count = -1:1;
        temp.density(1,1) = dens_count;
            for shear_count = -1:1;
            temp.shear(1,1) = shear_count;
            [output.frequency(:,:,output_counter),output.dissipation(:,:,output_counter)] = DF_predictor_slaved(controls.time,controls.time_step,controls.solution,temp.shear,temp.viscosity,temp.thickness,temp.density,controls.f0,graphs.normalise);
            output_counter = output_counter+1;
            end
        end
    end
end

% Putting resuits into seperate matricies, due to the way the 3 by 3 is set
% out, the bottom x rows of graphs and top x rows of graphs have to be
% swapped so that the top right of the grid is positive for both, hence the
% odd assingment below
f1(:,:) = output.frequency(:,:,7);
d1(:,:) = output.dissipation(:,:,7);
f2(:,:) = output.frequency(:,:,8);
d2(:,:) = output.dissipation(:,:,8);
f3(:,:) = output.frequency(:,:,9);
d3(:,:) = output.dissipation(:,:,9);
f4(:,:) = output.frequency(:,:,4);
d4(:,:) = output.dissipation(:,:,4);
f5(:,:) = output.frequency(:,:,5);
d5(:,:) = output.dissipation(:,:,5);
f6(:,:) = output.frequency(:,:,6);
d6(:,:) = output.dissipation(:,:,6);
f7(:,:) = output.frequency(:,:,1);
d7(:,:) = output.dissipation(:,:,1);
f8(:,:) = output.frequency(:,:,2);
d8(:,:) = output.dissipation(:,:,2);
f9(:,:) = output.frequency(:,:,3);
d9(:,:) = output.dissipation(:,:,3);
% Plotting the huge graph, calling a core function:
DvsF_threebythree(x_lower, x_mid, x_upper, y_lower, y_mid, y_upper, f1, d1, f2, d2, f3, d3, f4, d4, f5, d5, f6, d6, f7, d7, f8, d8, f9, d9, text_1, text_2, text_3, text_4, text_5, text_6, text_7);