%%%% Copyright Kristen Severson 2018 %%%%

clear; close all; clc
addpath('./Code_Utils')

%% Used in setting the colormap
max_Q = log10(2300);
min_Q = log10(100);
CM = colormap('jet');

%% Download these data from https://data.matr.io/1/
load('./Data/2018-04-03_varcharge_batchdata_updated_struct_errorcorrect.mat')
add_batch = batch;
load('./Data/2018-02-20_batchdata_updated_struct_errorcorrect.mat')
load('./Data/Diagnostic cycling data/initialdata_all.mat')
load('./Data/Diagnostic cycling data/finaldata_6and8.mat')
load('./Data/Diagnostic cycling data/finaldata_4.mat')
data = {charge_4C,charge_6C,charge_8C};

%% Preinitialization
n = 3;
idx_slownegI = cell(n,1);
idx1 = cell(n,1);
idx100 = cell(n,1);
Q1 = cell(n,1);
Q100 = cell(n,1);
V1 = cell(n,1);
V100 = cell(n,1);
V1x = cell(n,1);
V100x = cell(n,1);
dQdV1 = cell(n,1);
dQdV100 = cell(n,1);
f1 = cell(n,1);
f100 = cell(n,1);


Cover10 = -0.11;
%%
fs = 7.5;
plot_bat = [24,36,37];
bat_label7 = zeros(length(plot_bat),1);
for i = 1:length(plot_bat)
    
    if isempty(find(batch(plot_bat(i)).summary.QDischarge < 0.88,1))
        bat_label7(i) = size(batch(plot_bat(i)).summary.QDischarge,1);
    else
        bat_label7(i) = find(batch(plot_bat(i)).summary.QDischarge < 0.88,1);
    end
end

bat_label7(1) = 1399;


for i = 1:3
    idx_slownegI{i} = find(abs(data{i}.I - Cover10) < 0.1 & data{i}.V > 2.001);
    [~,idx_mid] = max(diff(idx_slownegI{i}));
    idx1{i}   = idx_slownegI{i}(2:idx_mid-2);
    idx100{i} = idx_slownegI{i}(idx_mid+2:end);
    if i == 3
        idx1{i}   = idx_slownegI{i}(2:idx_mid);
        idx100{i} = idx_slownegI{i}(idx_mid+2:end-1);
    end
    Q1{i}   = data{i}.Q(idx1{i}); Q1{i} = Q1{i} - Q1{i}(1);
    Q100{i} = data{i}.Q(idx100{i});
    V1{i}   = data{i}.V(idx1{i});
    V100{i} = data{i}.V(idx100{i});

    
end

Qend{1} = final_4C.Q-final_4C.Q(1);
Qend{2} = final_6C.Q-final_6C.Q(1);
Qend{3} = final_8C.Q-final_8C.Q(1);
Vend{1} = final_4C.V;
Vend{2} = final_6C.V;
Vend{3} = final_8C.V;

bat_label7 = log10(bat_label7);

%%
% Figure 5
fs = 10;
lw = 1;
figure()
for i = 1:length(plot_bat)

    idx = plot_bat(i);
    
    Q10_1 = batch(idx).cycles(10).Qdlin;
    
    color_ind = ceil((bat_label7(i) - min_Q)./(max_Q - min_Q)*64);
    
    subplot(4,length(plot_bat),i)
    [V1x{i}, dQdV1{i}] = EC_dQdV(Q1{i},smooth(V1{i}),Q1{i}(end));
    
    [V100x{i}, dQdV100{i}] = EC_dQdV(Q100{i},smooth(V100{i}),Q1{i}(end));
    if i == 1
        [Vendx, dQdVend] = EC_dQdV(final_4C.Q-final_4C.Q(1),smooth(final_4C.V),Q1{i}(end));
        
    elseif i == 2
        [Vendx, dQdVend] = EC_dQdV(final_6C.Q-final_6C.Q(1),smooth(final_6C.V),Q1{i}(end));
        
    elseif i == 3
        [Vendx, dQdVend] = EC_dQdV(final_8C.Q-final_8C.Q(1),smooth(final_8C.V),Q1{i}(end));

    end
    
    hold on
    plot(V100x{i},dQdV100{i},':','LineWidth',3.5,'Color',[0.66, 0.66, 0.66])
    plot(V1x{i},dQdV1{i},'k','LineWidth',lw)
    plot(Vendx, dQdVend,'Color',CM(color_ind,:),'LineWidth',2)
    text(3.16,-32,'C/10')
    ylabel('d%Q/dV (%/V)')
    xlabel('Voltage (V)')
    xlim([3.15 3.41])
    ylim([-35,0])
    
    if i == 1
        ylabel({'C/10 Discharge dQ/dV','d%Q/dV (%/V)'})
        title({'4C Charge / 4C Discharge'})
    end
        if i == 2
        title({'6C Charge / 4C Discharge'})
        end
        if i == 3
        title({'8C Charge / 4C Discharge'})
    end
    box on
    set(gca,'fontsize',fs)
    
    %dVdQ
    subplot(4,length(plot_bat),3+i)
    [Q1x{i}, dVdQ1{i}] = EC_dVdQ(Q1{i},smooth(V1{i}),Q1{i}(end));
    
    [Q100x{i}, dVdQ100{i}] = EC_dVdQ(Q100{i},smooth(V100{i}),Q1{i}(end));

    if i == 1
        [Qendx, dVdQend] = EC_dVdQ(final_4C.Q-final_4C.Q(1),smooth(final_4C.V),Q1{i}(end));
        
    elseif i== 2
        [Qendx, dVdQend] = EC_dVdQ(final_6C.Q-final_6C.Q(1),smooth(final_6C.V),Q1{i}(end));
        
    elseif i == 3
        [Qendx, dVdQend] = EC_dVdQ(final_8C.Q-final_8C.Q(1),smooth(final_8C.V),Q1{i}(end));

    end
    
    hold on
    plot(Q100x{i}(1:end-1).*100,dVdQ100{i},':','LineWidth',3.5,'Color',[0.66, 0.66, 0.66])
    plot(Q1x{i}(1:end-1).*100,dVdQ1{i},'k','LineWidth',1)
    plot(Qendx(1:end-1).*100, dVdQend,'Color',CM(color_ind,:),'LineWidth',2)
    text(3,0.1,'C/10')
    xlabel('Normalized Capacity (%)')
    ylabel('dV/d%Q (V/%)')
    ylim([0,1])
    box on
    
    if i == 1
        ylabel({'C/10 Discharge dV/dQ','dV/d%Q (V/%)'})
    end
    set(gca,'fontsize',fs)
    
    %fast dQdV
    subplot(4,length(plot_bat),6+i)
    hold on
   
    plot(batch(idx).Vdlin,batch(idx).cycles(100).discharge_dQdV,':',...
        'LineWidth',3.5,'Color',[0.66, 0.66, 0.66])
     plot(batch(idx).Vdlin, ...
        batch(idx).cycles(10).discharge_dQdV,'k','LineWidth',1)
    if i == 1
        plot(batch(idx).Vdlin, ...
            add_batch(2).cycles(240).discharge_dQdV,...
            'Color',CM(color_ind,:),'LineWidth',2)
    else
        plot(batch(idx).Vdlin, ...
        batch(idx).cycles(round(10.^bat_label7(i))).discharge_dQdV,...
        'Color',CM(color_ind,:),'LineWidth',2)
    end
    text(2.05,-7.25,'4C')
    xlim([2.0,3.5])
    ylabel('dQ/dV (Ah/V)')
    if i == 1
        ylabel({'4C Discharge dQ/dV','dQ/dV (Ah/V)'})
    end
    ylim([-8,0])
    xlabel('Voltage (V)')
    box on
    set(gca,'fontsize',fs)
    mean(batch(idx).cycles(100).discharge_dQdV - batch(idx).cycles(10).discharge_dQdV)
    
    subplot(4,length(plot_bat),9+i)
    hold on
    
    Q100_1 = batch(idx).cycles(100).Qdlin;
    plot(batch(idx).Vdlin,Q100_1 - Q10_1,':','LineWidth',3.5,'Color',[0.66, 0.66, 0.66])
    plot(batch(idx).Vdlin,Q10_1 - Q10_1,'k','LineWidth',1)
    for ii = 200:100:10.^bat_label7(i)
        if ii > length(batch(idx).cycles)
            Q100_1 = add_batch(i+1).cycles(ii - length(batch(idx).cycles)).Qdlin;
            plot(add_batch(i+1).Vdlin,Q100_1 - Q10_1,'--','LineWidth',0.5,'Color',[0.66, 0.66, 0.66])
        else
            Q100_1 = batch(idx).cycles(ii).Qdlin;
            plot(batch(idx).Vdlin,Q100_1 - Q10_1,'--','LineWidth',0.5,'Color',[0.66, 0.66, 0.66])
        end
    end
    
    
    if i == 1
        Q100_1 = add_batch(i+1).cycles(240).Qdlin;
        plot(batch(idx).Vdlin,Q100_1 - Q10_1,'Color',CM(color_ind,:),'LineWidth',2)
    elseif i > 1
        Q100_1 = batch(idx).cycles(round(10.^bat_label7(i))).Qdlin;
        plot(batch(idx).Vdlin,Q100_1 - Q10_1,'Color',CM(color_ind,:),'LineWidth',2)
    end
    text(2.05,-0.4,'4C')
    ylim([-0.45,0.2])
    xlabel('Voltage (V)')
    ylabel('Q_{101}(V) - Q_{10}(V) (Ah)')
    if i == 1
        ylabel({'4C Discharge \DeltaQ(V)','Q_{101}(V) - Q_{10}(V) (Ah)'})
        text(2.05,0.15,'Observed Cycle Life = 1399','fontsize',fs-3)
        text(2.05,0.1,'Predicted Cycle Life = 1198','fontsize',fs-3)
    end
    if i == 2
        text(2.05,0.15,'Observed Cycle Life = 425','fontsize',fs-3)
        text(2.05,0.1,'Predicted Cycle Life = 404','fontsize',fs-3)
    end
    if i == 3
                text(2.05,0.15,'Observed Cycle Life = 282','fontsize',fs-3)
        text(2.05,0.1,'Predicted Cycle Life = 255','fontsize',fs-3)

    end
    xlim([2,3.5])
    box on
    set(gca,'fontsize',fs)
    
    
    
end
set(gcf,'units','inches','PaperPosition',[0 0 8 10])
print(gcf,'.\Figures\Fig5','-dpng')
savefig(gcf,'.\Figures\Fig5.fig')

%%

figure()
plot(ones(100,1),'k','LineWidth',1)
hold on
plot(ones(100,1),':','LineWidth',3.5,'Color',[0.66, 0.66, 0.66])
plot(ones(100,1),'k','LineWidth',0.5)
legend('Cycle 1/10','Cycle 100/101','End of Life','Orientation','Horizontal',...
    'Location','SouthOutside')
set(gca,'fontsize',10)
set(gcf,'units','inches','PaperPosition',[0 0 4 4])
print(gcf,'.\Figures\Fig5_legend','-dpng')
savefig(gcf,'.\Figures\Fig5_legend.fig')
