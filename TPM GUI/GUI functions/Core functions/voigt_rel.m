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
density0 = 2648; % quartz density, kg m-3
shear0 = 2.904e10; % piezoelectrically stiffened shear modulus for AT-cut quartz, Pa (this will match QTools output; 2.947e10 Pa is more commonly seen)
vt0 = 3322; % transverse wave velocity, m s-1 (Interface Circuits for QCM Sensors, Springer Ser Chem Sens Biosens (2007) 5: 3–47, in Piezoelectric Sensors, edited by Claudia Steinem and Andreas Janshoff) QTools match would be 3.312e3 m/s
thickness0 = sqrt(shear0/density0)/2/f0; % resonator thickness, m
% thickness0 = vt0/2/f0; % resonator thickness, m

% arrays
harmonics = (1:2:13);
omega = 2*pi*f0*harmonics;

% Equation 14
kappa1 = viscosity1-1i*shear1./omega;
kappa3 = viscositybulk;

% Equation 13
xi1 = sqrt(-density1.*omega.^2.*(shear1+1i.*omega*viscosity1).^-1);
xi3 = sqrt(1i*densitybulk.*omega/viscositybulk);

% Equation 11, simplified because h1 = h2 and h3 = Infinity
A = (kappa1.*xi1+kappa3.*xi3).*(kappa1.*xi1-kappa3.*xi3).^-1;

% Equation 16
beta = kappa1.*xi1.*(1-A.*exp(2*xi1.*thickness1)).*(1+A.*exp(2*xi1*thickness1)).^-1;
beta0 = kappa1.*xi1.*(1-A).*(1+A).^-1;

% Equation 15
frequency = imag((beta-beta0)/(2*pi*density0*thickness0));
dissipation = -real(2*(beta-beta0)./(omega*density0*thickness0));

end