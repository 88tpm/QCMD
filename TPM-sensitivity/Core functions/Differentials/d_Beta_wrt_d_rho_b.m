function [result]=d_Beta_wrt_d_rho_b(f1,harmonic_index,inputs)

% Calculates the value of the differential of the Beta function with
% respect to the density of the fluid (rho b).
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
result=(1i*(-1)).*f1.*N.*((1/2).*pi).^(1/2).*(1i.*f1.* ...
    N.*eta_f.^(-1).*rho_f).^(-1/2).*(cos(2.*f1.*h1.*N.*pi.*((1i* ...
    2).*f1.*N.*pi.*eta_1+mu_1).^(-1/2).*rho_1.^(1/2))+((-1)+1i).*f1.* ...
    N.*pi.^(1/2).*eta_f.*rho_f.*(f1.*N.*eta_f.*((2i).*f1.*N.* ...
    pi.*eta_1+mu_1).*rho_1.*rho_f).^(-1/2).*sin(2.*f1.*h1.*N.*pi.*((1i* ...
    2).*f1.*N.*pi.*eta_1+mu_1).^(-1/2).*rho_1.^(1/2))).^(-2);