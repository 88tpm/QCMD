function [figure_count] = sketch(x_data,y_data,z_data,title_text,figure_number,z_start,z_fin,colour,publication)

% This creates the standard 3D surface mesh plot for the voinova plot. It
% takes the x, y, z data first followed by the title and then figure number.
% It will plot the graph and then pass back a new figure number to be used
% in the parent piece of code.
% The final two variables can be left at zero if not needed. 

% x_data --------->     x axsis as a vector
% y_data --------->     y axsis as a vector
% z_data --------->     z mesh data as a square matrix
% title_text ----->     string for the title
% figure_number -->     number of current figure in parent programme
% z_start -------->     if needed fixed z start value
% z_fin ---------->     if needed fixed z end value

% Selecting which type of graph to plot
if publication
    % Create figure
    this_figure = figure(figure_number);
    this_figure = figure('Color',[1 1 1]);
    % Create axes
    axes1 = axes('Parent',this_figure,'YScale','log','YMinorTick','on','YMinorGrid','on',...
        'XScale','log','XMinorTick','on','XMinorGrid','on','Position',[0.18 0.12 0.732 0.815],'FontSize',20);
%     view(axes1,[-37.5 30]); % Comment alpha (standard view) 1 of 3
    view(axes1,[-205.5 30]); % Comment beta (fig 1 view) 1 of 3
    grid(axes1,'on');
    hold(axes1,'all');
    % Create mesh
    if strcmp('b',colour)
        z_data = z_data*1e6;
    end
    mesh(x_data,y_data,z_data,'Parent',axes1);
    set(0,'DefaultAxesFontName', 'Helvetica')
    if strcmp('auto',colour)
    else
        if strcmp('r',colour)
            colormap([0 0 1;0.0126984128728509 0.0126984128728509 0.996825397014618;0.0253968257457018 0.0253968257457018 0.993650794029236;0.0380952395498753 0.0380952395498753 0.990476191043854;0.0507936514914036 0.0507936514914036 0.987301588058472;0.0634920671582222 0.0634920671582222 0.98412698507309;0.0761904790997505 0.0761904790997505 0.980952382087708;0.0888888910412788 0.0888888910412788 0.977777779102325;0.101587302982807 0.101587302982807 0.974603176116943;0.114285714924335 0.114285714924335 0.971428573131561;0.126984134316444 0.126984134316444 0.968253970146179;0.139682546257973 0.139682546257973 0.965079367160797;0.152380958199501 0.152380958199501 0.961904764175415;0.165079370141029 0.165079370141029 0.958730161190033;0.177777782082558 0.177777782082558 0.955555558204651;0.190476194024086 0.190476194024086 0.952380955219269;0.203174605965614 0.203174605965614 0.949206352233887;0.215873017907143 0.215873017907143 0.946031749248505;0.228571429848671 0.228571429848671 0.942857146263123;0.241269841790199 0.241269841790199 0.93968254327774;0.253968268632889 0.253968268632889 0.936507940292358;0.266666680574417 0.266666680574417 0.933333337306976;0.279365092515945 0.279365092515945 0.930158734321594;0.292063504457474 0.292063504457474 0.926984131336212;0.304761916399002 0.304761916399002 0.92380952835083;0.31746032834053 0.31746032834053 0.920634925365448;0.330158740282059 0.330158740282059 0.917460322380066;0.342857152223587 0.342857152223587 0.914285719394684;0.355555564165115 0.355555564165115 0.911111116409302;0.368253976106644 0.368253976106644 0.90793651342392;0.380952388048172 0.380952388048172 0.904761910438538;0.3936507999897 0.3936507999897 0.901587307453156;0.406349211931229 0.406349211931229 0.898412704467773;0.419047623872757 0.419047623872757 0.895238101482391;0.431746035814285 0.431746035814285 0.892063498497009;0.444444447755814 0.444444447755814 0.888888895511627;0.457142859697342 0.457142859697342 0.885714292526245;0.46984127163887 0.46984127163887 0.882539689540863;0.482539683580399 0.482539683580399 0.879365086555481;0.495238095521927 0.495238095521927 0.876190483570099;0.507936537265778 0.507936537265778 0.873015880584717;0.520634949207306 0.520634949207306 0.869841277599335;0.533333361148834 0.533333361148834 0.866666674613953;0.546031773090363 0.546031773090363 0.863492071628571;0.558730185031891 0.558730185031891 0.860317468643188;0.571428596973419 0.571428596973419 0.857142865657806;0.584127008914948 0.584127008914948 0.853968262672424;0.596825420856476 0.596825420856476 0.850793659687042;0.609523832798004 0.609523832798004 0.84761905670166;0.622222244739532 0.622222244739532 0.844444453716278;0.634920656681061 0.634920656681061 0.841269850730896;0.647619068622589 0.647619068622589 0.838095247745514;0.660317480564117 0.660317480564117 0.834920644760132;0.673015892505646 0.673015892505646 0.83174604177475;0.685714304447174 0.685714304447174 0.828571438789368;0.698412716388702 0.698412716388702 0.825396835803986;0.711111128330231 0.711111128330231 0.822222232818604;0.723809540271759 0.723809540271759 0.819047629833221;0.736507952213287 0.736507952213287 0.815873026847839;0.749206364154816 0.749206364154816 0.812698423862457;0.761904776096344 0.761904776096344 0.809523820877075;0.774603188037872 0.774603188037872 0.806349217891693;0.787301599979401 0.787301599979401 0.803174614906311;0.800000011920929 0.800000011920929 0.800000011920929]);
            zlabel('\Deltaf / Hz','FontSize',22.5);
        elseif strcmp('b',colour)
            colormap([0.800000011920929 0.800000011920929 0.800000011920929;0.803174614906311 0.787301599979401 0.787301599979401;0.806349217891693 0.774603188037872 0.774603188037872;0.809523820877075 0.761904776096344 0.761904776096344;0.812698423862457 0.749206364154816 0.749206364154816;0.815873026847839 0.736507952213287 0.736507952213287;0.819047629833221 0.723809540271759 0.723809540271759;0.822222232818604 0.711111128330231 0.711111128330231;0.825396835803986 0.698412716388702 0.698412716388702;0.828571438789368 0.685714304447174 0.685714304447174;0.83174604177475 0.673015892505646 0.673015892505646;0.834920644760132 0.660317480564117 0.660317480564117;0.838095247745514 0.647619068622589 0.647619068622589;0.841269850730896 0.634920656681061 0.634920656681061;0.844444453716278 0.622222244739532 0.622222244739532;0.84761905670166 0.609523832798004 0.609523832798004;0.850793659687042 0.596825420856476 0.596825420856476;0.853968262672424 0.584127008914948 0.584127008914948;0.857142865657806 0.571428596973419 0.571428596973419;0.860317468643188 0.558730185031891 0.558730185031891;0.863492071628571 0.546031773090363 0.546031773090363;0.866666674613953 0.533333361148834 0.533333361148834;0.869841277599335 0.520634949207306 0.520634949207306;0.873015880584717 0.507936537265778 0.507936537265778;0.876190483570099 0.495238095521927 0.495238095521927;0.879365086555481 0.482539683580399 0.482539683580399;0.882539689540863 0.46984127163887 0.46984127163887;0.885714292526245 0.457142859697342 0.457142859697342;0.888888895511627 0.444444447755814 0.444444447755814;0.892063498497009 0.431746035814285 0.431746035814285;0.895238101482391 0.419047623872757 0.419047623872757;0.898412704467773 0.406349211931229 0.406349211931229;0.901587307453156 0.3936507999897 0.3936507999897;0.904761910438538 0.380952388048172 0.380952388048172;0.90793651342392 0.368253976106644 0.368253976106644;0.911111116409302 0.355555564165115 0.355555564165115;0.914285719394684 0.342857152223587 0.342857152223587;0.917460322380066 0.330158740282059 0.330158740282059;0.920634925365448 0.31746032834053 0.31746032834053;0.92380952835083 0.304761916399002 0.304761916399002;0.926984131336212 0.292063504457474 0.292063504457474;0.930158734321594 0.279365092515945 0.279365092515945;0.933333337306976 0.266666680574417 0.266666680574417;0.936507940292358 0.253968268632889 0.253968268632889;0.93968254327774 0.241269841790199 0.241269841790199;0.942857146263123 0.228571429848671 0.228571429848671;0.946031749248505 0.215873017907143 0.215873017907143;0.949206352233887 0.203174605965614 0.203174605965614;0.952380955219269 0.190476194024086 0.190476194024086;0.955555558204651 0.177777782082558 0.177777782082558;0.958730161190033 0.165079370141029 0.165079370141029;0.961904764175415 0.152380958199501 0.152380958199501;0.965079367160797 0.139682546257973 0.139682546257973;0.968253970146179 0.126984134316444 0.126984134316444;0.971428573131561 0.114285714924335 0.114285714924335;0.974603176116943 0.101587302982807 0.101587302982807;0.977777779102325 0.0888888910412788 0.0888888910412788;0.980952382087708 0.0761904790997505 0.0761904790997505;0.98412698507309 0.0634920671582222 0.0634920671582222;0.987301588058472 0.0507936514914036 0.0507936514914036;0.990476191043854 0.0380952395498753 0.0380952395498753;0.993650794029236 0.0253968257457018 0.0253968257457018;0.996825397014618 0.0126984128728509 0.0126984128728509;1 0 0]);
            zlabel('\Deltad / ppm','FontSize',22.5);
        elseif strcmp('g',colour)
            colormap([0.800000011920929 0.800000011920929 0.800000011920929;0.787301599979401 0.799190819263458 0.787363827228546;0.774603188037872 0.798381567001343 0.774727702140808;0.761904776096344 0.797572374343872 0.762091517448425;0.749206364154816 0.796763181686401 0.749455332756042;0.736507952213287 0.795953929424286 0.736819207668304;0.723809540271759 0.795144736766815 0.724183022975922;0.711111128330231 0.794335544109344 0.711546838283539;0.698412716388702 0.793526291847229 0.698910713195801;0.685714304447174 0.792717099189758 0.686274528503418;0.673015892505646 0.791907906532288 0.673638343811035;0.660317480564117 0.791098654270172 0.661002159118652;0.647619068622589 0.790289461612701 0.648366034030914;0.634920656681061 0.789480268955231 0.635729849338531;0.622222244739532 0.788671016693115 0.623093664646149;0.609523832798004 0.787861824035645 0.610457539558411;0.596825420856476 0.787052631378174 0.597821354866028;0.584127008914948 0.786243379116058 0.585185170173645;0.571428596973419 0.785434186458588 0.572549045085907;0.558730185031891 0.784624993801117 0.559912860393524;0.546031773090363 0.783815741539001 0.547276675701141;0.533333361148834 0.783006548881531 0.534640550613403;0.520634949207306 0.78219735622406 0.522004365921021;0.507936537265778 0.781388103961945 0.509368181228638;0.495238095521927 0.780578911304474 0.496732026338577;0.482539683580399 0.779769718647003 0.484095871448517;0.46984127163887 0.778960466384888 0.471459716558456;0.457142859697342 0.778151273727417 0.458823531866074;0.444444447755814 0.777342081069946 0.446187376976013;0.431746035814285 0.776532828807831 0.43355119228363;0.419047623872757 0.77572363615036 0.42091503739357;0.406349211931229 0.774914443492889 0.40827888250351;0.3936507999897 0.774105191230774 0.395642697811127;0.380952388048172 0.773295998573303 0.383006542921066;0.368253976106644 0.772486805915833 0.370370388031006;0.355555564165115 0.771677553653717 0.357734203338623;0.342857152223587 0.770868360996246 0.345098048448563;0.330158740282059 0.770059168338776 0.332461893558502;0.31746032834053 0.76924991607666 0.319825708866119;0.304761916399002 0.768440723419189 0.307189553976059;0.292063504457474 0.767631530761719 0.294553369283676;0.279365092515945 0.766822278499603 0.281917214393616;0.266666680574417 0.766013085842133 0.269281059503555;0.253968268632889 0.765203893184662 0.256644874811172;0.241269841790199 0.764394640922546 0.244008719921112;0.228571429848671 0.763585448265076 0.23137255012989;0.215873017907143 0.762776255607605 0.218736380338669;0.203174605965614 0.76196700334549 0.206100225448608;0.190476194024086 0.761157810688019 0.193464055657387;0.177777782082558 0.760348618030548 0.180827885866165;0.165079370141029 0.759539365768433 0.168191730976105;0.152380958199501 0.758730173110962 0.155555561184883;0.139682546257973 0.757920980453491 0.142919391393662;0.126984134316444 0.757111728191376 0.13028322160244;0.114285714924335 0.756302535533905 0.117647059261799;0.101587302982807 0.755493342876434 0.105010896921158;0.0888888910412788 0.754684090614319 0.0923747271299362;0.0761904790997505 0.753874897956848 0.0797385647892952;0.0634920671582222 0.753065705299377 0.0671023949980736;0.0507936514914036 0.752256453037262 0.0544662326574326;0.0380952395498753 0.751447260379791 0.0418300665915012;0.0253968257457018 0.750638067722321 0.0291939005255699;0.0126984128728509 0.749828815460205 0.0165577344596386;0 0.749019622802734 0.00392156885936856]);
            zlabel({'TPM-sensitivity'},'FontSize',22.5);
        elseif strcmp('mm',colour)
            colormap([0.800000011920929 0.800000011920929 0.800000011920929;0.803174614906311 0.787301599979401 0.803174614906311;0.806349217891693 0.774603188037872 0.806349217891693;0.809523820877075 0.761904776096344 0.809523820877075;0.812698423862457 0.749206364154816 0.812698423862457;0.815873026847839 0.736507952213287 0.815873026847839;0.819047629833221 0.723809540271759 0.819047629833221;0.822222232818604 0.711111128330231 0.822222232818604;0.825396835803986 0.698412716388702 0.825396835803986;0.828571438789368 0.685714304447174 0.828571438789368;0.83174604177475 0.673015892505646 0.83174604177475;0.834920644760132 0.660317480564117 0.834920644760132;0.838095247745514 0.647619068622589 0.838095247745514;0.841269850730896 0.634920656681061 0.841269850730896;0.844444453716278 0.622222244739532 0.844444453716278;0.84761905670166 0.609523832798004 0.84761905670166;0.850793659687042 0.596825420856476 0.850793659687042;0.853968262672424 0.584127008914948 0.853968262672424;0.857142865657806 0.571428596973419 0.857142865657806;0.860317468643188 0.558730185031891 0.860317468643188;0.863492071628571 0.546031773090363 0.863492071628571;0.866666674613953 0.533333361148834 0.866666674613953;0.869841277599335 0.520634949207306 0.869841277599335;0.873015880584717 0.507936537265778 0.873015880584717;0.876190483570099 0.495238095521927 0.876190483570099;0.879365086555481 0.482539683580399 0.879365086555481;0.882539689540863 0.46984127163887 0.882539689540863;0.885714292526245 0.457142859697342 0.885714292526245;0.888888895511627 0.444444447755814 0.888888895511627;0.892063498497009 0.431746035814285 0.892063498497009;0.895238101482391 0.419047623872757 0.895238101482391;0.898412704467773 0.406349211931229 0.898412704467773;0.901587307453156 0.3936507999897 0.901587307453156;0.904761910438538 0.380952388048172 0.904761910438538;0.90793651342392 0.368253976106644 0.90793651342392;0.911111116409302 0.355555564165115 0.911111116409302;0.914285719394684 0.342857152223587 0.914285719394684;0.917460322380066 0.330158740282059 0.917460322380066;0.920634925365448 0.31746032834053 0.920634925365448;0.92380952835083 0.304761916399002 0.92380952835083;0.926984131336212 0.292063504457474 0.926984131336212;0.930158734321594 0.279365092515945 0.930158734321594;0.933333337306976 0.266666680574417 0.933333337306976;0.936507940292358 0.253968268632889 0.936507940292358;0.93968254327774 0.241269841790199 0.93968254327774;0.942857146263123 0.228571429848671 0.942857146263123;0.946031749248505 0.215873017907143 0.946031749248505;0.949206352233887 0.203174605965614 0.949206352233887;0.952380955219269 0.190476194024086 0.952380955219269;0.955555558204651 0.177777782082558 0.955555558204651;0.958730161190033 0.165079370141029 0.958730161190033;0.961904764175415 0.152380958199501 0.961904764175415;0.965079367160797 0.139682546257973 0.965079367160797;0.968253970146179 0.126984134316444 0.968253970146179;0.971428573131561 0.114285714924335 0.971428573131561;0.974603176116943 0.101587302982807 0.974603176116943;0.977777779102325 0.0888888910412788 0.977777779102325;0.980952382087708 0.0761904790997505 0.980952382087708;0.98412698507309 0.0634920671582222 0.98412698507309;0.987301588058472 0.0507936514914036 0.987301588058472;0.990476191043854 0.0380952395498753 0.990476191043854;0.993650794029236 0.0253968257457018 0.993650794029236;0.996825397014618 0.0126984128728509 0.996825397014618;1 0 1]);
            zlabel({'Missing Mass / %'},'FontSize',22.5);
        else
            error('Colour selection must be r, b, g, or auto for auto colour assignment')
        end
    end

    % xlabel('Shear / Pa','FontSize',22.5);
    %  ylabel('Viscosity / Pa s','FontSize',22.5);
%     annotation(this_figure,'textbox',[0.08 0 0.05 0.1],'String',{'Viscosity / Pa s'},'FitBoxToText','off','LineStyle','none','FontSize',22.5); % Comment alpha 2 of 3
%     annotation(this_figure,'textbox',[0.52 0 0.3 0.1],'String',{'Shear / Pa'},'FitBoxToText','off','LineStyle','none','FontSize',22.5); % Comment alpha 3 of 3
    annotation(this_figure,'textbox',[0.02 0 0.2 0.2],'String',{'Viscosity / Pa s'},'FitBoxToText','off','LineStyle','none','FontSize',22.5,'HorizontalAlignment','center'); % Comment beta 2 of 3
    annotation(this_figure,'textbox',[0.64 0 0.3 0.1],'String',{'Shear / Pa'},'FitBoxToText','off','LineStyle','none','FontSize',22.5); % Comment beta 3 of 3
    % title(title_text,'FontSize',27.5);
    % Create colorbar
    box on
    hold off
    a = size(x_data);
    xlim(axes1,[x_data(1),x_data(a(1))])
    a = size(y_data);
    ylim(axes1,[y_data(1),y_data(a(1))])
    if or((z_start ~= 0),(z_fin ~= 0))
        zlim(axes1,[z_start,z_fin])
        caxis([z_start,z_fin])
    end

%     annotation(this_figure,'textbox',[0.315 0.03 0.1 0.1],'String',{'10^-^3'},'FitBoxToText','off','LineStyle','none','FontSize',20);
%      annotation(this_figure,'textbox',[0.419285714285715 0.034 0.0821428571428572 0.0761904761904762],'String',{'10^9'},'FitBoxToText','off','LineStyle','none','FontSize',20);
%     x = [1e4 1e5 1e6 1e7]; set(gca,'XTick',x);
    x = [1e5 1e6 1e7 1e8 1e9]; set(gca,'XTick',x);
    y = [1e-3 1e-2 1e-1 1]; set(gca,'YTick',y);
    disp('WARNING x and y axis labels are set in the code and do not change automatically, to autoformat the axis turn off "publication" in controls')
elseif publication == 0
    % x_data --------->     x axis as a vector
    % y_data --------->     y axis as a vector
    % z_data --------->     z mesh data as a square matrix
    % title_text ----->     string for the title
    % figure_number -->     number of current figure in parent programme
    % z_start -------->     if needed fixed z start value
    % z_fin ---------->     if needed fixed z end value

    % Create figure
    this_figure = figure(figure_number);
    this_figure = figure('Color',[1 1 1]);
    % Create axes
    axes1 = axes('Parent',this_figure,'YScale','log','YMinorTick','on','YMinorGrid','on',...
        'XScale','log','XMinorTick','on','XMinorGrid','on','Position',[0.083 0.11 0.7 0.815]);
    % view(axes1,[-37.5 30]); % Standard view
    view(axes1,[-205.5 30]); % Figure 1 view
    grid(axes1,'on');
    hold(axes1,'all');
    % Create mesh
    mesh(x_data,y_data,z_data,'Parent',axes1);
    xlabel('Shear / Pa','FontSize',12);
    ylabel('Viscosity / Pa s','FontSize',12);
    title(title_text,'FontSize',14);
    % Create colorbar
    box on
%     colorbar('peer',axes1);
    colorbar('peer',axes1,'Position',[0.85 0.11 0.02 0.815],'FontSize',12);
    hold off
    if or((z_start ~= 0),(z_fin ~= 0))
        zlim(axes1,[z_start,z_fin])
        caxis([z_start,z_fin])
    end
else
    error('publication setting must be either 1 or 0')
end
figure_count = figure_number+1;

% ----------------------------------------------------------

% % Create title
% title('Sauerbrey deviation for harmonic 13','FontSize',14);
% 
% % Create colorbar
% colorbar('peer',axes1,'Position',...
%     [0.89769009272816 0.11 0.0195217179111762 0.815]);


