function [combinations,score,fd_derivative] = combo(controls)

% combo generates a list of the highest scoring TPM-sensitivity 
%   combinations with their corresponding scores. 
%
% Inputs
%   f0
%       base frequency of the QCM (Hz)
%   properties: 2 x 6 vector of thin film and fluid properties
%       row 1: real, positive materials parameter
%       row 2: Boolean, TRUE if value remains constant
%       order of properties
%           film thickness (m)
%           film density (kg m^-3)
%           film viscosity (Pa s)
%           film shear modulus (Pa)
%           fluid density (kg m^-3)
%           fluid viscosity (Pa s)
%   f_sensitivity: 1 x 7 real vector
%       weights scoring of frequency based on instrument response
%           (e.g., 1 = measurement precision of 1 Hz)
%       vector position corresponds to harmonic index (i.e., position 4 is
%           7th harmonic)
%   d_sensitivity: 1 x 7 real vector
%       weights scoring of dissipation based on instrument response
%           (e.g., 1e-6 = measurement precision of 1 ppm)
%   Outputs
%       combinations: matrix with each row giving the combination of
%           derivatives used. Number of columns is determined by number of 
%           free material parameters (free_property_count). Each column 
%           gives the index of a frequency or dissipation measurement.
%           First seven indices are f1,f3, f5 ...; next seven are d1, d3, 
%           d7 … . E.g., a row [3 7 10 12] means [f5  f13  d5  d9].
%       score: sensitivity score for those parameters
%       fd_derivative: the derivative of the frequency and dissipation with
%           respect to the non-fixed film properties
% 

% AT-cut quartz resonator constants
rho_q = 2643; % quartz density, kg m-3
shear_q = 2.947e10; % shear modulus for AT-cut quartz, Pa
h_q = sqrt(shear_q/rho_q)/2/controls.f0; % resonator thickness, m

% Initialize variables
harmonics = 7; % harmonic number = 2N - 1
properties = controls.properties(1,:);
fixed_properties = controls.properties(2,:);
free_property_count = length(fixed_properties)-sum(fixed_properties);
score_matrix = zeros(free_property_count);
combinations = nchoosek([1:2*harmonics],free_property_count);
score = zeros(length(combinations),1);
fd_derivative = zeros(harmonics*2,free_property_count); % first half is for frequency, second for dissipation

% Calculate derivatives
if controls.linear
    for N=1:harmonics
        beta_derivatives = beta_derivative(properties,fixed_properties,N,controls.f0);
        beta_derivatives(1) = beta_derivatives(1); % In for linear
        beta_derivatives(2) = beta_derivatives(2); % In for linear
        fd_derivative(N,:) = imag(beta_derivatives)/(2*pi*rho_q*h_q)/controls.f_sensitivity(N);
        fd_derivative(harmonics+N,:) = -real(beta_derivatives)/(pi*(2*N-1)*controls.f0*rho_q*h_q)/controls.d_sensitivity(N);
    end
else
    for N=1:harmonics
        beta_derivatives = beta_derivative(properties,fixed_properties,N,controls.f0);
        beta_derivatives(1) = beta_derivatives(1)*properties(3); % In for Log
        beta_derivatives(2) = beta_derivatives(2)*properties(4); % In for log
        fd_derivative(N,:) = imag(beta_derivatives)/(2*pi*rho_q*h_q)/controls.f_sensitivity(N);
        fd_derivative(harmonics+N,:) = -real(beta_derivatives)/(pi*(2*N-1)*controls.f0*rho_q*h_q)/controls.d_sensitivity(N);
    end
end

% Produce scoring matrix for each combination

count = 1;
while count<=length(combinations)
    for N = 1:free_property_count
       score_matrix(N,:)=fd_derivative(combinations(count,N),:); 
    end
    score(count)=abs(det(score_matrix));
    count=count+1;
end

% Comment out all below apart from the final end to supress text score responce
% Output stats for top scores
[~,sortIndex] = sort(score(:),'descend');
for tophitcount = 1:controls.tophits
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

