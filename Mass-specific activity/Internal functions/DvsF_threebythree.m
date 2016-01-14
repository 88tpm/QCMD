function DvsF_threebythree(x_lower, x_mid, x_upper, y_lower, y_mid, y_upper, f1, d1, f2, d2, f3, d3, f4, d4, f5, d5, f6, d6, f7, d7, f8, d8, f9, d9, text_1, text_2, text_3, text_4, text_5, text_6, text_7)
% 
% Plots a 3 by 3 grid of the F vs D traces based upon the 9 matracies as
% inputs.
% 
% f1 --> f values for subplot 1 etc.
% d1 --> d values for subplot 1 etc.
% x ---> how the graphs are changing on the x axsis [string].
% y ---> how the graphs are changing on the y axis [string}.
% A ledgend is created along with rings around the starting data values.
% x and are coloured wtih x reversed and harmonics have a logical colour change.


% Converting from matrix block into vector strings for script and creating start points

% Matrix 1
X1 = f1(:,1);
X2 = f1(:,2);
X3 = f1(:,3);
X4 = f1(:,4);
X5 = f1(:,5);
X6 = f1(:,6);
X7 = f1(:,7);
Y1 = d1(:,1);
Y2 = d1(:,2);
Y3 = d1(:,3);
Y4 = d1(:,4);
Y5 = d1(:,5);
Y6 = d1(:,6);
Y7 = d1(:,7);
x_1(1,:) = f1(1,:);
y_1(1,:) = d1(1,:);

% Matrix 2
X8 = f2(:,1);
X9 = f2(:,2);
X10 = f2(:,3);
X11 = f2(:,4);
X12 = f2(:,5);
X13 = f2(:,6);
X14 = f2(:,7);
Y8 = d2(:,1);
Y9 = d2(:,2);
Y10 = d2(:,3);
Y11 = d2(:,4);
Y12 = d2(:,5);
Y13 = d2(:,6);
Y14 = d2(:,7);
x_2(:,:) = f2(1,:);
y_2(:,:) = d2(1,:);

% Matrix 3
X15 = f3(:,1);
X16 = f3(:,2);
X17 = f3(:,3);
X18 = f3(:,4);
X19 = f3(:,5);
X20 = f3(:,6);
X21 = f3(:,7);
Y15 = d3(:,1);
Y16 = d3(:,2);
Y17 = d3(:,3);
Y18 = d3(:,4);
Y19 = d3(:,5);
Y20 = d3(:,6);
Y21 = d3(:,7);
x_3(:,:) = f3(1,:);
y_3(:,:) = d3(1,:);

% Matrix 4
X22 = f4(:,1);
X23 = f4(:,2);
X24 = f4(:,3);
X25 = f4(:,4);
X26 = f4(:,5);
X27 = f4(:,6);
X28 = f4(:,7);
Y22 = d4(:,1);
Y23 = d4(:,2);
Y24 = d4(:,3);
Y25 = d4(:,4);
Y26 = d4(:,5);
Y27 = d4(:,6);
Y28 = d4(:,7);
x_4(:,:) = f4(1,:);
y_4(:,:) = d4(1,:);

% Matrix 5
X29 = f5(:,1);
X30 = f5(:,2);
X31 = f5(:,3);
X32 = f5(:,4);
X33 = f5(:,5);
X34 = f5(:,6);
X35 = f5(:,7);
Y29 = d5(:,1);
Y30 = d5(:,2);
Y31 = d5(:,3);
Y32 = d5(:,4);
Y33 = d5(:,5);
Y34 = d5(:,6);
Y35 = d5(:,7);
x_5(:,:) = f5(1,:);
y_5(:,:) = d5(1,:);

% Matrix 6
X36 = f6(:,1);
X37 = f6(:,2);
X38 = f6(:,3);
X39 = f6(:,4);
X40 = f6(:,5);
X41 = f6(:,6);
X42 = f6(:,7);
Y36 = d6(:,1);
Y37 = d6(:,2);
Y38 = d6(:,3);
Y39 = d6(:,4);
Y40 = d6(:,5);
Y41 = d6(:,6);
Y42 = d6(:,7);
x_6(:,:) = f6(1,:);
y_6(:,:) = d6(1,:);

% Matrix 7
X43 = f7(:,1);
X44 = f7(:,2);
X45 = f7(:,3);
X46 = f7(:,4);
X47 = f7(:,5);
X48 = f7(:,6);
X49 = f7(:,7);
Y43 = d7(:,1);
Y44 = d7(:,2);
Y45 = d7(:,3);
Y46 = d7(:,4);
Y47 = d7(:,5);
Y48 = d7(:,6);
Y49 = d7(:,7);
x_7(:,:) = f7(1,:);
y_7(:,:) = d7(1,:);

% Matrix 8
X50 = f8(:,1);
X51 = f8(:,2);
X52 = f8(:,3);
X53 = f8(:,4);
X54 = f8(:,5);
X55 = f8(:,6);
X56 = f8(:,7);
Y50 = d8(:,1);
Y51 = d8(:,2);
Y52 = d8(:,3);
Y53 = d8(:,4);
Y54 = d8(:,5);
Y55 = d8(:,6);
Y56 = d8(:,7);
x_8(:,:) = f8(1,:);
y_8(:,:) = d8(1,:);

% Matrix 9
X57 = f9(:,1);
X58 = f9(:,2);
X59 = f9(:,3);
X60 = f9(:,4);
X61 = f9(:,5);
X62 = f9(:,6);
X63 = f9(:,7);
Y57 = d9(:,1);
Y58 = d9(:,2);
Y59 = d9(:,3);
Y60 = d9(:,4);
Y61 = d9(:,5);
Y62 = d9(:,6);
Y63 = d9(:,7);
x_9(:,:) = f9(1,:);
y_9(:,:) = d9(1,:);

% Create figure
figure1 = figure('Name','Overall D vs F trends',...
    'Color',[1 0.968627452850342 0.921568632125854]);

% Create subplot
subplot1 = subplot(3,3,1,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot1,'on');
grid(subplot1,'on');
hold(subplot1,'all');

% Create plot
plot(X1,Y1,'Parent',subplot1,'Color',[1 0 0]);

% Create plot
plot(X2,Y2,'Parent',subplot1,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X3,Y3,'Parent',subplot1,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X4,Y4,'Parent',subplot1,'LineWidth',2,'Color',[0 0.498039215803146 0]);

% Create plot
plot(X5,Y5,'Parent',subplot1,'Color',[0 0 1]);

% Create plot
plot(X6,Y6,'Parent',subplot1,'Color',[1 0 1]);

% Create plot
plot(X7,Y7,'Parent',subplot1,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot2 = subplot(3,3,2,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0],...
    'ColorOrder',[1 0 0;1 0.600000023841858 0;1 1 0;0 0.498039215803146 0;0 0 1;1 0 1;0.501960813999176 0 0.501960813999176]);
box(subplot2,'on');
grid(subplot2,'on');
hold(subplot2,'all');

% Create plot
plot(X8,Y8,'Parent',subplot2,'Color',[1 0 0]);

% Create plot
plot(X9,Y9,'Parent',subplot2,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X10,Y10,'Parent',subplot2,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X11,Y11,'Parent',subplot2,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X12,Y12,'Parent',subplot2,'Color',[0 0 1]);

% Create plot
plot(X13,Y13,'Parent',subplot2,'Color',[1 0 1]);

% Create plot
plot(X14,Y14,'Parent',subplot2,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot3 = subplot(3,3,3,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot3,'on');
grid(subplot3,'on');
hold(subplot3,'all');

% Create plot
plot(X15,Y15,'Parent',subplot3,'Color',[1 0 0]);


% Create plot
plot(X16,Y16,'Parent',subplot3,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X17,Y17,'Parent',subplot3,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X18,Y18,'Parent',subplot3,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X19,Y19,'Parent',subplot3,'Color',[0 0 1]);

% Create plot
plot(X20,Y20,'Parent',subplot3,'Color',[1 0 1]);

% Create plot
plot(X21,Y21,'Parent',subplot3,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot4 = subplot(3,3,4,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot4,'on');
grid(subplot4,'on');
hold(subplot4,'all');

% Create plot
plot(X22,Y22,'Parent',subplot4,'Color',[1 0 0]);

% Create plot
plot(X23,Y23,'Parent',subplot4,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X24,Y24,'Parent',subplot4,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X25,Y25,'Parent',subplot4,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X26,Y26,'Parent',subplot4,'Color',[0 0 1]);

% Create plot
plot(X27,Y27,'Parent',subplot4,'Color',[1 0 1]);

% Create plot
plot(X28,Y28,'Parent',subplot4,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot5 = subplot(3,3,5,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot5,'on');
grid(subplot5,'on');
hold(subplot5,'all');

% Create plot
plot(X29,Y29,'Parent',subplot5,'Color',[1 0 0]);

% Create plot
plot(X30,Y30,'Parent',subplot5,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X31,Y31,'Parent',subplot5,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X32,Y32,'Parent',subplot5,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X33,Y33,'Parent',subplot5,'Color',[0 0 1]);

% Create plot
plot(X34,Y34,'Parent',subplot5,'Color',[1 0 1]);

% Create plot
plot(X35,Y35,'Parent',subplot5,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create axes
axes1 = axes('Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0],...
    'Position',[0.691594202898551 0.409632352941176 0.213405797101449 0.215735294117647]);
box(axes1,'on');
grid(axes1,'on');
hold(axes1,'all');

% Create plot
plot(X36,Y36,'Parent',axes1,'Color',[1 0 0],'DisplayName','H 1');

% Create plot
plot(X37,Y37,'Parent',axes1,'Color',[0.600000023841858 0.200000002980232 0],...
    'DisplayName','H 3');

% Create plot
plot(X38,Y38,'Parent',axes1,'Color',[0.749019622802734 0.749019622802734 0],...
    'DisplayName','H 5');

% Create plot
plot(X39,Y39,'Parent',axes1,'LineWidth',2,'Color',[0 0.498039215803146 0],...
    'DisplayName','H 7');

% Create plot
plot(X40,Y40,'Parent',axes1,'Color',[0 0 1],'DisplayName','H 9');

% Create plot
plot(X41,Y41,'Parent',axes1,'Color',[1 0 1],'DisplayName','H 11');

% Create plot
plot(X42,Y42,'Parent',axes1,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904],...
    'DisplayName','H 13');

% Create subplot
subplot6 = subplot(3,3,7,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot6,'on');
grid(subplot6,'on');
hold(subplot6,'all');

% Create plot
plot(X43,Y43,'Parent',subplot6,'Color',[1 0 0]);

% Create plot
plot(X44,Y44,'Parent',subplot6,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X45,Y45,'Parent',subplot6,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X46,Y46,'Parent',subplot6,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X47,Y47,'Parent',subplot6,'Color',[0 0 1]);

% Create plot
plot(X48,Y48,'Parent',subplot6,'Color',[1 0 1]);

% Create plot
plot(X49,Y49,'Parent',subplot6,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot7 = subplot(3,3,8,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot7,'on');
grid(subplot7,'on');
hold(subplot7,'all');

% Create plot
plot(X50,Y50,'Parent',subplot7,'Color',[1 0 0]);

% Create plot
plot(X51,Y51,'Parent',subplot7,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X52,Y52,'Parent',subplot7,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X53,Y53,'Parent',subplot7,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X54,Y54,'Parent',subplot7,'Color',[0 0 1]);

% Create plot
plot(X55,Y55,'Parent',subplot7,'Color',[1 0 1]);

% Create plot
plot(X56,Y56,'Parent',subplot7,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create subplot
subplot8 = subplot(3,3,9,'Parent',figure1,'YColor',[0 0 1],'XDir','reverse',...
    'XColor',[1 0 0]);
box(subplot8,'on');
grid(subplot8,'on');
hold(subplot8,'all');

% Create plot
plot(X57,Y57,'Parent',subplot8,'Color',[1 0 0]);

% Create plot
plot(X58,Y58,'Parent',subplot8,...
    'Color',[0.600000023841858 0.200000002980232 0]);

% Create plot
plot(X59,Y59,'Parent',subplot8,...
    'Color',[0.749019622802734 0.749019622802734 0]);

% Create plot
plot(X60,Y60,'Parent',subplot8,'LineWidth',2,...
    'Color',[0 0.498039215803146 0]);

% Create plot
plot(X61,Y61,'Parent',subplot8,'Color',[0 0 1]);

% Create plot
plot(X62,Y62,'Parent',subplot8,'Color',[1 0 1]);

% Create plot
plot(X63,Y63,'Parent',subplot8,...
    'Color',[0.47843137383461 0.062745101749897 0.894117653369904]);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.925793650793654 0.417401960784314 0.0535714285714286 0.199019607843137]);

% Create textbox
annotation(figure1,'textbox',...
    [0.913095238095238 0.113286713286713 0.0803571428571427 0.208503019029336],...
    'String',{'Starting conditions:',text_1, text_2, text_3,text_4,text_5, text_6, text_7,},...
    'FitBoxToText','off','FontSize', 7.45,...
    'BackgroundColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.0333333333333333 0.190227272727273 0.0860714285714289 0.0482954545454545],...
    'String',{y_lower},...
    'HorizontalAlignment','right',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.0333333333333333 0.789772727272727 0.0857142857142861 0.0482954545454545],...
    'String',{y_upper},...
    'HorizontalAlignment','right',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.0348809523809525 0.492936569080637 0.0857142857142861 0.0482954545454545],...
    'String',{y_mid},...
    'HorizontalAlignment','right',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.12797619047619 0.920397085259373 0.217261904761905 0.0482954545454545],...
    'String',{x_lower},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.409880952380954 0.920171096558808 0.217261904761905 0.0482954545454545],...
    'String',{x_mid},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create textbox
annotation(figure1,'textbox',...
    [0.689285714285715 0.920283448895737 0.217857142857143 0.0482954545454545],...
    'String',{x_upper},...
    'HorizontalAlignment','center',...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Creating the start point plots
plot(x_1,y_1,'Parent',subplot1,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_2,y_2,'Parent',subplot2,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_3,y_3,'Parent',subplot3,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_4,y_4,'Parent',subplot4,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_5,y_5,'Parent',subplot5,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_6,y_6,'Parent',axes1,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_7,y_7,'Parent',subplot6,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_8,y_8,'Parent',subplot7,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

plot(x_9,y_9,'Parent',subplot8,'Marker','o','LineStyle','none',...
    'Color',[0 0 0]);

