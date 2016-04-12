function [derivative_vector] = beta_derivative(properties,fixed_properties,harmonic_index,f0)

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

derivative_vector=zeros(length(fixed_properties)-sum(fixed_properties),1);

index = 1;

% d(beta)/d(film height)
if ~fixed_properties(1)
    derivative_vector(index) = d_Beta_wrt_d_h_f(f0,harmonic_index,properties);
    index = index + 1;
end

% d(beta)/d(film density)
if ~fixed_properties(2)
    derivative_vector(index) = d_Beta_wrt_d_rho_f(f0,harmonic_index,properties);
    index = index + 1;
end

% d(beta)/d(film viscosity)
if ~fixed_properties(3)
    derivative_vector(index) = d_Beta_wrt_d_eta_f(f0,harmonic_index,properties);
    index = index + 1;
end

% d(beta)/d(film shear)
if ~fixed_properties(4)
    derivative_vector(index) = d_Beta_wrt_d_mu_f(f0,harmonic_index,properties);
    index = index + 1;
end

% d(beta)/d(bulk fluid density)
if ~fixed_properties(5)
    derivative_vector(index) = d_Beta_wrt_d_rho_b(f0,harmonic_index,properties);
    index = index + 1;
end

% d(beta)/d(bulk fluid viscosity)
if ~fixed_properties(6)
    derivative_vector(index) = d_Beta_wrt_d_eta_b(f0,harmonic_index,properties);
end

end

