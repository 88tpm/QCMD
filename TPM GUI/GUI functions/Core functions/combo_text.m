function [combinations,score,fd_derivative] = combo_text(properties,fixed_properties,f_weighting,d_weighting,f0,linear,text,rows)

% *********************************Inputs**********************************
% 
% controls.f0 -------------> Fundamental frequency / Hz
% controls.f_ sensitivity -> The error for the frequency response / Hz.
%                            Independent errors for all the overtones, Overtones
%                            are ordered as: 1; 3; 5; 7; 9; 11; 13
% controls.d_ sensitivity -> The error for the dissipation response. Independent
%                            errors for all the overtones, Overtones are ordered
%                            as: 1; 3; 5; 7; 9; 11; 13
% controls.linear ---------> Binary operator. Set to 1 for the TPM-sensitivity
%                            to be calculated based upon the true slope and set
%                            to 0 to calculate based upon the apparent log slope
% controls.n --------------> Number of top scores to show
% properties --------------> Properties of the system. Order of properties are:
%                            film height; film density; film viscosity; film shear
%                            modulus; bulk density; bulk viscosity
% fixed_properties --------> Binary choice for which properties of the system are
%                            fixed during calculation. Set to 0 to allow the
%                            property to vary. Has the same ordering of system
%                            properties as properties (above)

% *********************************Outputs*********************************
%
% combinations ----------->	All of the combinations of the harmonics for the
%                            number of parameters set to vary. 1 – 7 represents
%                            F1 – F13, 8 – 14 represents D1 – D13
% fd_derivative ---------->
% score	------------------>	The TPM-sensitivity score for the corresponding
%                            harmonic combination in the combinations matrix

%% Starting calculations
% AT-cut quartz resonator constants
rho_q = 2643; % quartz density, kg m-3
shear_q = 2.947e10; % shear modulus for AT-cut quartz, Pa
h_q = sqrt(shear_q/rho_q)/2/f0; % resonator thickness, m

% Initialize variables
harmonics = 7; % harmonic number = 2N - 1
free_property_count = length(fixed_properties)-sum(fixed_properties);
score_matrix = zeros(free_property_count);
combinations = nchoosek([1:2*harmonics],free_property_count);
score = zeros(length(combinations),1);
fd_derivative = zeros(harmonics*2,free_property_count); % first half is for frequency, second for dissipation

%% Calculate derivatives
if linear
    for N=1:harmonics
        beta_derivatives = beta_derivative(properties,fixed_properties,N,f0);
        beta_derivatives(1) = beta_derivatives(1); % In for linear
        beta_derivatives(2) = beta_derivatives(2); % In for linear
        fd_derivative(N,:) = imag(beta_derivatives)/(2*pi*rho_q*h_q)/f_weighting(N);
        fd_derivative(harmonics+N,:) = -real(beta_derivatives)/(pi*(2*N-1)*f0*rho_q*h_q)/d_weighting(N);
    end
else
    for N=1:harmonics
        beta_derivatives = beta_derivative(properties,fixed_properties,N,f0);
        beta_derivatives(1) = beta_derivatives(1)*properties(3); % In for Log
        beta_derivatives(2) = beta_derivatives(2)*properties(4); % In for log
        fd_derivative(N,:) = imag(beta_derivatives)/(2*pi*rho_q*h_q)/f_weighting(N);
        fd_derivative(harmonics+N,:) = -real(beta_derivatives)/(pi*(2*N-1)*f0*rho_q*h_q)/d_weighting(N);
    end
end
%% Produce scoring matrix for each combination

count = 1;
while count<=length(combinations)
    for N = 1:free_property_count
       score_matrix(N,:)=fd_derivative(combinations(count,N),:); 
    end
    score(count)=abs(det(score_matrix));
    count=count+1;
end
if text
% Comment out all below apart from the final end to supress text score responce
% Output stats for top scores
    [~,sortIndex] = sort(score(:),'descend');
    for tophitcount = 1:rows
        uses_string = ['Top Score ' num2str(score(sortIndex(tophitcount)),'%7.2e') ' (row ' num2str(sortIndex(tophitcount)) ') using '];
        for N = 1:free_property_count
            if combinations(sortIndex(tophitcount),N)>harmonics
                uses_string=[uses_string 'd' num2str((combinations(sortIndex(tophitcount),N)-harmonics)*2-1) ' '];
            else
                uses_string=[uses_string 'f' num2str(combinations(sortIndex(tophitcount),N)*2-1) ' '];
            end
        end
    disp(uses_string)
    end
end
end

