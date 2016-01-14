function [frequency,dissipation]=voigt_rel(density1,shear1,viscosity1,thickness1,densitybulk,viscositybulk,f0)

% voigt
%   Solves for Delta f and Delta d of thin adlayer on quartz resonator.
%   Differs from voight because calculates relative to unloaded resonator.
%   Based on Voinova et al. Phys. Scr. 1999 59 391-396
%   © 2014 Christopher F. Blanford
%
%   Input
%       density1
%           density of adlayer in kg m-3
%       shear1
%           elastic shear modulus of adlayer in Pa
%       viscosity1
%           dynamic viscosity of adlayer in Pa s
%       thickness1
%           thickness of adlayer in m
%       densitybulk
%           density of bulk Newtonian fluid in kg m-3
%       viscositybulk
%           dynamic viscosity of bulk Newtonian fluid in kg m-3
%       f0
%           resonator fundamental frequency in s-1
%
%   Output
%       frequency
%           frequency change of resonator, array of odd harmonics 1-13
%       dissipation
%           dissipation change of resonator, array of odd harmonics 1-13
%

% Constants
density0 = 2643; % quartz density, kg m-3
shear0 = 2.947e10; % shear modulus for AT-cut quartz, Pa
thickness0 = sqrt(shear0/density0)/2/f0; % resonator thickness, m

% arrays
harmonics = (1:2:13);
omega = 2*pi*f0*harmonics;

% Equation 14
kappa1 = viscosity1-1i*shear1./omega; %dervaiation
kappa3 = viscositybulk; % written out

% Equation 13
xi1 = sqrt(-density1.*omega.^2./(shear1+1i.*omega*viscosity1));
xi3 = sqrt(1i*densitybulk.*omega/viscositybulk);

% Equation 11, simplified because h1 = h2 and h3 = Infinity
A = (kappa1.*xi1+kappa3.*xi3)./(kappa1.*xi1-kappa3.*xi3);

% Equation 16
beta = kappa1.*xi1.*(1-A.*exp(2*xi1.*thickness1))./(1+A.*exp(2.*xi1*thickness1)); %witten out
beta0 = kappa1.*xi1.*(1-A)./(1+A);

% Equation 15
frequency = imag((beta-beta0)/(2*pi*density0*thickness0));
dissipation = -real(2*(beta-beta0)./(omega*density0*thickness0));

end