function [output] = TPM_sensitivity(controls,properties,fixed_properties)


% controls.x --------=-----> Variable to use as the x axis. Choose from 'film height';
%                            'film density'; 'bulk density'; 'film viscosity';
%                            'bulk viscosity'; 'film shear'
% controls.x_range --------> Range of the x axis. Start to finish
% controls.y --------------> Same as controls.x, but for the y axis. Same
%                            choices as controls.x
% controls.y_range --------> Range of the y axis. Start to finish
% controls.steps ----------> Number of points along each axis
% controls.harmonic(1) -----> The first harmonic number of the harmonic pair
%                            to calculate the TPM-sensitivity for
% controls.harmonic(2) -----> The second harmonic number of the harmonic pair
%                            to calculate the TPM-sensitivity for
% controls.z_range --------> Set to [0,0] to let the TPM-sensitivity graph 
%                            auto-scale. Set to desired z axis range if manual
%                            z range of the graph is needed
% controls.harmonic_type --> Sets the harmonic types, e.g. FF sets harmonic
%                            one and two both to frequency, FD would set harmonic
%                            one to frequency and harmonic two to dissipation. 
% controls.publication ----> Set to 0 for general use and auto formatting of 
%                            the graph. Set to one to use a second part of sketch
%                            sub code where a static piece of the code can be
%                            edited to obtain a tailored graph for publication
% controls.linear ---------> Binary operator. Set to 1 for the TPM-sensitivity
%                            to be calculated based upon the true slope and set
%                            to 0 to calculate based upon the apparent log slope
% controls.f0 -------------> Fundamental frequency / Hz
% controls.f_sensitivity --> The error for the frequency response / Hz. Independent
%                            errors for all the overtones, Overtones are ordered as:
%                            1; 3; 5; 7; 9; 11; 13
% controls.d_sensitivity --> The error for the dissipation response. Independent
%                            errors for all the overtones, Overtones are ordered
%                            as: 1; 3; 5; 7; 9; 11; 13
% properties --------------> Properties of the system. Order of properties are:
%                            film height; film density; film viscosity; film shear
%                            modulus; bulk density; bulk viscosity
% fixed_properties --------> Binary choice for which properties of the system
%                            are fixed during calculation. Set to 0 to allow the
%                            property to vary. Has the same ordering of system
%                            properties as properties (above)
% 
% *********************************Outputs*********************************
% 
% output.score_surface ----> The TPM-sensitivity scores that constitute the
%                            plots surface
% output.max_index --------> The maximum scoring TPM-sensitivity harmonic
%                            combination for that location on the x and y axis
% output.max_score --------> The maximum TPM-sensitivity score for that
%                            location on the x and y axis

% assigning asis names and properties to number indexes
if strcmp(controls.x,'film height')
    x_name = 1; x_text = 'Film height (m)';
elseif strcmp(controls.x,'film density')
    x_name = 2; x_text = 'Film density (Kg m^-^3)';
elseif strcmp(controls.x,'bulk density')
    x_name = 5; x_text = 'Bulk density (Kg m^-^3';
elseif strcmp(controls.x,'film viscosity')
    x_name = 3; x_text = 'Film viscosity (Pa s)';
elseif strcmp(controls.x,'bulk viscosity')
    x_name = 6; x_text = 'Bulk viscosity (Pa s)';
elseif strcmp(controls.x,'film shear')
    x_name = 4; x_text = 'Film shear (Pa)';
else
    error('X axsis name mismatch. Choose from: film height; film density; bulk density; film viscosity; bulk viscosity or film shear')
end
if strcmp(controls.y,'film height')
    y_name = 1; y_text = 'Film height (m)';
elseif strcmp(controls.y,'film density')
    y_name = 2; y_text = 'Film density (Kg m^-^3)';
elseif strcmp(controls.y,'bulk density')
    y_name = 5; y_text = 'Bulk density (Kg m^-^3';
elseif strcmp(controls.y,'film viscosity')
    y_name = 3; y_text = 'Film viscosity (Pa s)';
elseif strcmp(controls.y,'bulk viscosity')
    y_name = 6; y_text = 'Bulk viscosity (Pa s)';
elseif strcmp(controls.y,'film shear')
    y_name = 4; y_text = 'Film shear (Pa)';
else
    error('Y axsis name mismatch. Choose from: film height; film density; bulk density; film viscosity; bulk viscosity or film shear')
end

% Transfering inputs to function
variables(:,1) = (log(controls.y_range(1)):((log(controls.y_range(2))-log(controls.y_range(1)))/controls.steps):log(controls.y_range(2)));
variables(:,2) = (log(controls.x_range(1)):((log(controls.x_range(2))-log(controls.x_range(1)))/controls.steps):log(controls.x_range(2)));
variables = exp(variables);
output.score_surface = zeros(controls.steps+1,controls.steps+1,91);
output.max_index = zeros(controls.steps+1,controls.steps+1);
output.max_score = output.max_index;

% Creating all scores values
for x_count = 1:controls.steps+1;
    for y_count = 1:controls.steps+1;
        properties(x_name) = variables(x_count,2);
        properties(y_name) = variables(y_count,1);
        [combs,output.score_surface(x_count,y_count,:),~] = combo_slaved(properties,fixed_properties,controls.f_sensitivity,controls.d_sensitivity,controls.f0,controls.linear);
        [output.max_score(x_count,y_count),output.max_index(x_count,y_count)]=max(output.score_surface(x_count,y_count,:));
    end
end

% Finding the row you want
if strcmp(controls.harmonic_type,'FF')
    row_index = [((controls.harmonic(1)+1)/2) ((controls.harmonic(2)+1)/2)];
    a = 'Sensitivity plot for F'; b = ' and F';
elseif strcmp(controls.harmonic_type,'DD')
    row_index = [(((controls.harmonic(1)+1)/2)+7) (((controls.harmonic(2)+1)/2)+7)];
    a = 'Sensitivity plot for D'; b = ' and D';
elseif strcmp(controls.harmonic_type,'FD')
    row_index = [((controls.harmonic(1)+1)/2) (((controls.harmonic(2)+1)/2)+7)];
    a = 'Sensitivity plot for F'; b = ' and D';
elseif strcmp(controls.harmonic_type,'DF')
    error('Please set harmonic_type to FD. (remember to swap the harmonic numbers too)')
else
    error('Harmonic_type must be FF, DD or FD (case sensitive)')
end

for count = 1:91
    if row_index(1,:) == combs(count,:)
        row = count;
        break
    end
end

% Generating graph titles
f = num2str(controls.harmonic(1)); d = num2str(controls.harmonic(2));
text = [a f b d];
figures = 1;
% mesh(variables(:,1),variables(:,2),squeeze((output.score_surface(:,:,row)))');
[figures] = sketch(variables(:,2),variables(:,1),squeeze((output.score_surface(:,:,row)))',text,figures,controls.z_range(1),controls.z_range(2),'g',controls.publication);

% a = 'Maximum possible score using all harmonics';
% N_optimised_plot(variables(:,1),variables(:,2),output.max_score(:,:)',a,figures,controls.steps,combs,output.max_index,controls.z_range(1),controls.z_range(2),controls.colour,controls.publication);

