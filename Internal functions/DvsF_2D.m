function DvsF_2D(frequency, dissipation)
% Plots the D vs F plot with everything formatted correctly
%  frequency -----> vector of x data
%  dissipation ---> vector of y data

% Create figure
figure1 = figure('Name','D vd F plot',...
    'Color',[1 0.968627452850342 0.921568632125854]);

% Create axes
axes1 = axes('Parent',figure1,'ZColor',[1 0 1],'YColor',[0 0 1],...
    'XDir','reverse',...
    'XColor',[1 0 0]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');

% Create plot
plot(frequency,dissipation);

% Create title
title('D vs F','FontSize',12);

% Create ylabel
ylabel('Dissipation / ppm','Color',[0 0 1]);

% Create xlabel
xlabel('Frequency / Hz','Color',[1 0 0]);

