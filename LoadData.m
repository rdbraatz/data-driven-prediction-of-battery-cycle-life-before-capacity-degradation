%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to show an example of loading the dataset associated with      %
% K.A. Severson, P.M. Attia et al. Data Driven Prediction of Battery    %
% Cycle Life Before Capacity Degradation (2019) Nature Energy           %
% This code assumes the data is in a subdirectory named 'Data'          %
% The structs include information on the 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear; close all; clc

load('.\Data\2017-05-12_batchdata_updated_struct_errorcorrect')

batch1 = batch; 
numBat1 = size(batch1,2);

load('.\Data\2017-06-30_batchdata_updated_struct_errorcorrect')

%Some batteries continued from the first run into the second. We append 
%those to the first batch before continuing.
add_len = [661, 980, 1059, 207, 481];
summary_var_list = {'cycle','QDischarge','QCharge','IR','Tmax','Tavg',...
    'Tmin','chargetime'};
batch2_idx = [8:10,16:17];
for i=1:5
    batch1(i).cycles(end+1:end+add_len(i)+1) = batch(batch2_idx(i)).cycles;
    batch1(i).summary.cycle(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.cycle;
    batch1(i).summary.QDischarge(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.QDischarge;
    batch1(i).summary.QCharge(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.QCharge;
    batch1(i).summary.IR(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.IR;
    batch1(i).summary.Tmax(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tmax;
    batch1(i).summary.Tavg(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tavg;
    batch1(i).summary.Tmin(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.Tmin;
    batch1(i).summary.chargetime(end+1:end+add_len(i)+1) = ...
        batch(batch2_idx(i)).summary.chargetime;
end

batch([8:10,16:17]) = [];
batch2 = batch;
numBat2 = size(batch2,2);
clearvars batch

load('.\Data\2018-04-12_batchdata_updated_struct_errorcorrect')
batch3 = batch;
batch3(38) = []; %remove channel 46 upfront; there was a problem with 
%the data collection for this channel
numBat3 = size(batch3,2);
endcap3 = zeros(numBat3,1);
clearvars batch
for i = 1:numBat3
    endcap3(i) = batch3(i).summary.QDischarge(end);
end
rind = find(endcap3 > 0.885);
batch3(rind) = [];

%remove the noisy Batch 8 batteries
nind = [3, 40:41];
batch3(nind) = [];
numBat3 = size(batch3,2);

batch_combined = [batch1, batch2, batch3];
numBat = numBat1 + numBat2 + numBat3;

%optionally remove the batteries that do not finish in Batch 1; depending
%on the modeling goal, you may not want to do this step
batch_combined([9,11,13,14,23]) = [];
numBat = numBat - 5;
numBat1 = numBat1 - 5; 

clearvars -except batch_combined numBat1 numBat2 numBat3 numBat

%% Output variable
%Extract the number of cycles to 0.88; this is the output variable used in
%modeling for the paper

bat_label = zeros(numBat,1);
for i = 1:numBat
    if batch_combined(i).summary.QDischarge(end) < 0.88
        bat_label(i) = find(batch_combined(i).summary.QDischarge < 0.88,1);
        
    else
        bat_label(i) = size(batch_combined(i).cycles,2) + 1;
    end
end

figure()
hold on
for i = 1:numBat
    plot(batch_combined(i).summary.QDischarge,'.-')
end

%% Train and Test Split
% If you are interested in using the same train/test split as the paper,
% use the indices specified below

test_ind = [1:2:(numBat1+numBat2),84];
train_ind = 1:(numBat1+numBat2);
train_ind(test_ind) = [];
secondary_test_ind = numBat-numBat3+1:numBat;


