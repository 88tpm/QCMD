function plot_3D(frequency, dissipation, z_axsis)
% This creates a 3D plot of a D vs F plot with a z axsis and everything
% properly coloured and scaled.
%  frequency ------> vector of x data
%  dissipation ----> vector of y data
%  z_axsis --------> vector of z data
% 
%  © 2014 Tom P McNamara

% Create figure
figure1 = figure('Color',...
    [0.960784316062927 0.921568632125854 0.921568632125854]);

% Create axes
axes1 = axes('Parent',figure1,'ZColor',[1 0 1],'YColor',[0 0 1],...
    'XDir','reverse',...
    'XColor',[1 0 0]);
view(axes1,[32.5 18]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');
xlabel('Frequency / Hz')
ylabel('Dissipation / ppm')
zlabel('Time / s')
% Create plot3
plot3(frequency,dissipation,z_axsis);

