function [output]=voigt_responses(controls)

% This function creates a plot of fundamental dissipation and frequency responce.
% 
% *********************************Controls********************************
% 
% controls.x --------------> Variable to use as the x axis. Choose from 
%                            'film height'; 'film density'; 'bulk density';
%                            'film viscosity'; 'bulk viscosity'; 'film shear'
% controls.y --------------> Same as above, but for the y axis. Same choices as above
% controls.x_range --------> Range of the x axis. Start to finish
% controls.y_range --------> Range of the y axis. Start to finish
% controls.steps ----------> Number of points along each axis
% controls.f0 -------------> Fundamental frequency / Hz
% controls.harmonic -------> Harmonic/overtone number. Choose from: 1; 3; 5; 7; 9; 11; 13
% controls.height_film ----> Height of the film / m
% controls.density_bulk ---> Density of the film / kg m-3
% controls.viscosity_film -> Viscosity of the film / Pa s
% controls.shear_film -----> Shear modulus as the film
% controls.density_bulk ---> Density of the bulk
% controls.viscosity_bulk -> Viscosity of the bulk
% controls.normalise ------> Binary operator. Set to 0 for the true harmonic
%                            response or set to 1 for that overtone to be normalized
%                            by division by its overtone number 
% controls.d_sensitivity --> The error for the dissipation response
% controls.f_sensitivity --> The error for the frequency response / Hz
% controls.z_range_f ------> Set to [0,0] to let the frequency response graph
%                            auto-scale. Set to desired z axis range if manual z 
%                            range of the graph is needed
% controls.z_range_d ------> Set to [0,0] to let the dissipation response graph
%                            auto-scale. Set to desired z axis range if manual
%                            z range of the graph is needed
% controls.z_range_s ------> Set to [0,0] to let the TPM-sensitivity graph
% auto-scale. Set to desired z axis range if manual z range of the graph is needed
% controls.z_range_mm -----> Set to [0,0] to let the missing mass graph auto-scale.
%                            Set to desired z axis range if manual z range of the
%                            graph is needed
% controls.publication ----> Set to 0 for general use and auto formatting of the
%                            graph. Set to one to use a second part of sketch sub
%                            code where a static piece of the code can be edited to
%                            obtain a tailored graph for publication
% 
% *********************************Outputs*********************************
% 
% output.f_surface --------> Grid of points constituting the frequency response
%                            surface. Regardless of harmonic selected in controls,
%                            all overtone responses are calculated: F1 [n,n,1];
%                            F3 [n,n,2]; F5 [n,n,3]; F7 [n,n,4]; e.t.c.
% output.d_surface --------> Same as above, but for the dissipation responses
% output.variables	-------> Matrix of all the film properties for each point of
%                            the surface
% output.f_vector ---------> Matrix of frequency response vectors used for the 2D
%                            TPM-sensitivity calculation. [n,n,1] and [n,n,2] x and
%                            y components of the vector respectively. [n,n,3]
%                            vector’s magnitude. [n,n,4] vector’s angle
% output.d_vector ---------> Same as above, but for the dissipation response vectors
% output.missing_mass -----> Grid of points constituting the missing mass surface.
%                            Regardless of harmonic selected in controls, all overtone
%                            responses are calculated: F1 [n,n,1]; F3 [n,n,2];
%                            F5 [n,n,3]; F7 [n,n,4]; e.t.c.


%% Start-up actions
% Creating RAM allocation
output.f_surface = zeros(controls.steps+1,controls.steps+1,7);
output.d_surface = zeros(controls.steps+1,controls.steps+1,7);
output.variables = zeros(controls.steps+1,2);
temp.f_normalised = zeros(controls.steps+1,controls.steps+1,7);
temp.d_normalised = zeros(controls.steps+1,controls.steps+1,7);
output.f_vector = zeros(controls.steps+1,controls.steps+1,4);
output.d_vector = zeros(controls.steps+1,controls.steps+1,4);
output.variables = zeros(controls.steps+1,controls.steps+1,6);
output.missing_mass = zeros(controls.steps+1, controls.steps+1,7);
N = (controls.harmonic+1)/2;
figures = 1;
harmonic = [1 3 5 7 9 11 13];
const = 2*controls.f0^2/sqrt(2643*2.947e10);

% Selecting variables
if strcmp(controls.x,'film height')
    x_name = 4; x_text = 'Film height (m)';
elseif strcmp(controls.x,'film density')
    x_name = 1; x_text = 'Film density (Kg m^-^3)';
elseif strcmp(controls.x,'bulk density')
    x_name = 5; x_text = 'Bulk density (Kg m^-^3';
elseif strcmp(controls.x,'film viscosity')
    x_name = 3; x_text = 'Film viscosity (Pa s)';
elseif strcmp(controls.x,'bulk viscosity')
    x_name = 6; x_text = 'Bulk viscosity (Pa s)';
elseif strcmp(controls.x,'film shear')
    x_name = 2; x_text = 'Film shear (Pa)';
else
    error('X axis name mismatch')
end
if strcmp(controls.y,'film height')
    y_name = 4; y_text = 'Film height (m)';
elseif strcmp(controls.y,'film density')
    y_name = 1; y_text = 'Film density (Kg m^-^3)';
elseif strcmp(controls.y,'bulk density')
    y_name = 5; y_text = 'Bulk density (Kg m^-^3';
elseif strcmp(controls.y,'film viscosity')
    y_name = 3; y_text = 'Film viscosity (Pa s)';
elseif strcmp(controls.y,'bulk viscosity')
    y_name = 6; y_text = 'Bulk viscosity (Pa s)';
elseif strcmp(controls.y,'film shear')
    y_name = 2; y_text = 'Film shear (Pa)';
else
    error('Y axis name mismatch')
end

% Populating surface parameters
output.variables(:,:,1) = controls.density_film;
output.variables(:,:,2) = controls.shear_film;
output.variables(:,:,3) = controls.viscosity_film;
output.variables(:,:,4) = controls.height_film;
output.variables(:,:,5) = controls.density_bulk;
output.variables(:,:,6) = controls.viscosity_bulk;
temp_axis(:,1) = (log(controls.x_range(1)):((log(controls.x_range(2))-log(controls.x_range(1)))/controls.steps):log(controls.x_range(2)));
temp_axis(:,2) = (log(controls.y_range(1)):((log(controls.y_range(2))-log(controls.y_range(1)))/controls.steps):log(controls.y_range(2)));
temp_axis(:,:) = exp(temp_axis(:,:));
for x_count = 1:controls.steps+1;
    for y_count = 1:controls.steps+1;
        output.variables(x_count,y_count,x_name) = temp_axis(x_count,1);
        output.variables(x_count,y_count,y_name) = temp_axis(y_count,2);
    end
end

%% Creating all f & d values
for x_count = 1:controls.steps+1;
    for y_count = 1:controls.steps+1;
        [output.f_surface(x_count,y_count,:),output.d_surface(x_count,y_count,:)] = voigt_rel(output.variables(x_count,y_count,1),output.variables(x_count,y_count,2),output.variables(x_count,y_count,3),output.variables(x_count,y_count,4),output.variables(x_count,y_count,5),output.variables(x_count,y_count,6),controls.f0);
    end
end
%% Standard core normalisations etc
if controls.normalise
    a = 1;
    for b = 2:7;
    output.f_surface(:,:,b) = output.f_surface(:,:,b)/(a+b);
    a = a+1;
    end
end
%% Calculating and creating all plots
% F and D plots
[figures] = sketch(squeeze(output.variables(:,1,x_name)),squeeze(output.variables(1,:,y_name))',squeeze(output.f_surface(:,:,N))',strcat(['Frequency response harmonic ',num2str(controls.harmonic)]),figures,controls.z_range_f(1),controls.z_range_f(2),'r',controls.publication);
[figures] = sketch(squeeze(output.variables(:,1,x_name)),squeeze(output.variables(1,:,y_name))',squeeze(output.d_surface(:,:,N))',strcat(['Dissipation response harmonic ',num2str(controls.harmonic)]),figures,controls.z_range_d(1),controls.z_range_d(2),'b',controls.publication);     

% Missing mass calculation
if controls.normalise
    sauerbrey = -controls.density_film*controls.height_film.*const.*[1 1 1 1 1 1 1];
else
    sauerbrey = -controls.density_film*controls.height_film.*const.*harmonic;
end
for i=1:7;
    dvsf15(:,:,i)=output.d_surface(:,:,i)./(output.f_surface(:,:,i)/harmonic(i));
end
for loop=1:7;
    output.missing_mass(:,:,loop)=1-output.f_surface(:,:,loop)/sauerbrey(loop);
end
sketch(squeeze(output.variables(:,1,x_name)),squeeze(output.variables(1,:,y_name))',100.*squeeze(output.missing_mass(:,:,N))',strcat(['Sauerbrey deviation for harmonic ',num2str(controls.harmonic)]),figures,controls.z_range_mm(1),controls.z_range_mm(2),'mm',controls.publication);
 
end