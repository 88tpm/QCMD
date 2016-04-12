function [result]=d_Beta_wrt_d_h_f(f1,harmonic_index,inputs)

% Calculates the value of the differential of the Beta function with
% respect to the height of the film (h f).
% 
% 
% Inputs
%   f1
%       base frequency of the QCMD (Hz)
%   harmonic_index
%       harmonic index (harmonic = 2N-1)
%   inputs: 1 x 6 vector of thin film and fluid properties (real, positive)
%       film thickness (m)
%       film density (kg m^-3)
%       film viscosity (Pa s)
%       film shear modulus (Pa)
%       fluid density (kg m^-3)
%       fluid viscosity (Pa s)

% Loading values for the function
% below this comment f stands for bulk fluid and 1 stands for film
h1 = inputs(1);
rho_1 = inputs(2);
eta_1 = inputs(3);
mu_1 = inputs(4);
rho_f = inputs(5);
eta_f = inputs(6);
N = harmonic_index*2-1;

% calculating the differential result
result=2.*f1.^3.*N.^3.*pi.*rho_1.*((-1i).*mu_1.*rho_1+2.*f1.*N.* ...
    pi.*(eta_1.*rho_1+(-1).*eta_f.*rho_f)).*(1i.*f1.*N.*rho_1.*((-1).*(( ...
    2i).*f1.*N.*pi.*eta_1+mu_1).^(-1).*rho_1).^(-1/2).*cos(2.*f1.* ...
    h1.*N.*pi.*((2i).*f1.*N.*pi.*eta_1+mu_1).^(-1/2).*rho_1.^( ...
    1/2))+(1+1i).*pi.^(1/2).*(f1.^3.*N.^3.*eta_f.*rho_f).^(1/2).* ...
    sinh(2.*f1.*h1.*N.*pi.*((-1).*((2i).*f1.*N.*pi.*eta_1+ ...
    mu_1).^(-1).*rho_1).^(1/2))).^(-2);