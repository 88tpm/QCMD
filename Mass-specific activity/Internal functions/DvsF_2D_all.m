function DvsF_2D_all(f1, d1, f3, d3, f5, d5, f7, d7, f9, d9, f11, d11, f13, d13)

% Plots the D vs F plot for all harmonics with everything formatted correctly
%  frequencies ----> vectors of x data
%  dissipations ---> vectors of y data

% Create figure
figure1 = figure('Name','D vd F plot, all harmonics',...
    'Color',[1 0.968627452850342 0.921568632125854]);
colormap('cool');

% Create axes
axes1 = axes('Parent',figure1,'ZColor',[1 0 1],'YGrid','on',...
    'YColor',[0 0 1],...
    'XGrid','on',...
    'XDir','reverse',...
    'XColor',[1 0 0]);
box(axes1,'on');
hold(axes1,'all');

% Create plot
plot(f1,d1,'Parent',axes1,'Color',[1 0 0],'DisplayName','H 1');

% Create plot
plot(f3,d3,'Parent',axes1,'Color',[0.600000023841858 0.200000002980232 0],...
    'DisplayName','H 3');

% Create plot
plot(f5,d5,'Parent',axes1,'Color',[1 0.694117665290833 0.39215686917305],...
    'DisplayName','H 5');

% Create plot
plot(f7,d7,'Parent',axes1,'LineWidth',2,'Color',[0 0.498039215803146 0],...
    'DisplayName','H 7');

% Create plot
plot(f9,d9,'Parent',axes1,'Color',[0 0 1],'DisplayName','H 9');

% Create plot
plot(f11,d11,'Parent',axes1,'Color',[1 0 1],'DisplayName','H 11');

% Create plot
plot(f13,d13,'Parent',axes1,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904],...
    'DisplayName','H 13');

% Create xlabel
xlabel('Frequency / Hz','Color',[1 0 0]);

% Create ylabel
ylabel('Dissipation / ppm','Color',[0 0 1]);

% Create title
title({'D vs F plot for all harmonics'},'FontSize',12);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Location','EastOutside');

