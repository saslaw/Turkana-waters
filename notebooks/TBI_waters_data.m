close all
clear all

%import water isotope data csv file
all_data = readtable('TBI_waters_data_GH1.csv');
precip = all_data(1:28,:);
river = all_data(29:35,:);
lake = all_data(36:84,:);
rlake = all_data(85:89,:);
evap = all_data(90:101,:);
dground = all_data(102:110,:);
sground = all_data(111:115,:);

%statistics
ave_18O = [mean(precip.d18O)
mean(river.d18O)
mean(lake.d18O)
mean(rlake.d18O)
mean(evap.d18O)
mean(dground.d18O)
mean(sground.d18O)];

sd_18O = [std(precip.d18O)
std(river.d18O)
std(lake.d18O)
std(rlake.d18O)
std(evap.d18O)
std(dground.d18O)
std(sground.d18O)];

ave_D = [mean(precip.dD)
mean(river.dD)
mean(lake.dD)
mean(rlake.dD)
mean(evap.dD)
mean(dground.dD)
mean(sground.dD)];

sd_D = [std(precip.dD)
std(river.dD)
std(lake.dD)
std(rlake.dD)
std(evap.dD)
std(dground.dD)
std(sground.dD)];

max_18O = [max(precip.d18O)
max(river.d18O)
max(lake.d18O)
max(rlake.d18O)
max(evap.d18O)
max(dground.d18O)
max(sground.d18O)];

min_18O = [min(precip.d18O)
min(river.d18O)
min(lake.d18O)
min(rlake.d18O)
min(evap.d18O)
min(dground.d18O)
min(sground.d18O)];

max_D = [max(precip.dD)
max(river.dD)
max(lake.dD)
max(rlake.dD)
max(evap.dD)
max(dground.dD)
max(sground.dD)];

min_D = [min(precip.dD)
min(river.dD)
min(lake.dD)
min(rlake.dD)
min(evap.dD)
min(dground.dD)
min(sground.dD)];

%Calculate D-excess


%specify the global meteoric water line (or any other reference line)
gmwlX = linspace(-5,15);
gmwlY = (8*gmwlX)+10;

%generate figures
figure(1)
GMWL = plot(gmwlX,gmwlY,'k');
GMWL.LineWidth = 2.5;
hold on
s1 = scatter(lake.d18O,lake.dD,'filled');
s1.Marker = 'o';
s1.SizeData = 65;
s1.LineWidth = 1.5;
s1.MarkerEdgeColor = [0 0.42 0.31];
s1.MarkerFaceColor = [0 0.8 0.6];
s2 = scatter(river.d18O,river.dD,'filled');
s2.Marker = 'o';
s2.SizeData = 65;
s2.LineWidth = 1.5;
s2.MarkerEdgeColor = [0 0.09 0.66];
s2.MarkerFaceColor = [0.01 0.28 1];
s3 = scatter(precip.d18O,precip.dD,'filled');
s3.Marker = 'o';
s3.SizeData = 65;
s3.LineWidth = 1.5;
s3.MarkerEdgeColor = [0 0.45 0.73];
s3.MarkerFaceColor = [0.34 0.63 0.83];
s4 = scatter(rlake.d18O,rlake.dD,'filled');
s4.Marker = 'o';
s4.SizeData = 65;
s4.LineWidth = 1.5;
s4.MarkerEdgeColor = [0.62 0.66 0.12];
s4.MarkerFaceColor = [0.69 0.75 0.10];
s5 = scatter(sground.d18O,sground.dD,'filled');
s5.Marker = 'o';
s5.SizeData = 65;
s5.LineWidth = 1.5;
s5.MarkerEdgeColor = [0.51 0.38 0.24];
s5.MarkerFaceColor = [0.88 0.66 0.37];
s6 = scatter(dground.d18O,dground.dD,'filled');
s6.Marker = 'o';
s6.SizeData = 65;
s6.LineWidth = 1.5;
s6.MarkerEdgeColor = [0.67 0.22 0.12];
s6.MarkerFaceColor = [0.91 0.45 0.32];
xlim([-5 10])
ylim([-30 60])
hold off

figure(2)
%simple linear regression of lake water data
mdl = fitlm(lake.d18O,lake.dD);
Xnew = linspace(-3.05, 10, 1000)';
[ypred,yci] = predict(mdl, Xnew);
hold on
l1 = plot(Xnew, ypred,'k-');
l1.LineWidth = 1;
l2 = plot(Xnew, yci, 'k--');
hold off
hold on
GMWL = plot(gmwlX,gmwlY,'k');
GMWL.LineWidth = 2.5;
hold off
hold on
s7 = scatter(lake.d18O,lake.dD,'filled');
s7.Marker = 'o';
s7.SizeData = 65;
s7.LineWidth = 1.5;
s7.MarkerEdgeColor = [0 0.42 0.31];
s7.MarkerFaceColor = [0 0.8 0.6];
s8 = scatter(river.d18O,river.dD,'filled');
s8.Marker = 'o';
s8.SizeData = 65;
s8.LineWidth = 1.5;
s8.MarkerEdgeColor = [0 0.09 0.66];
s8.MarkerFaceColor = [0.01 0.28 1];
xlim([-5 10])
ylim([-30 50])
hold off

%slope and intercept of lake d18O vs. dD linear regression
Xpadded = [ones(length(Xnew),1) Xnew];
levap = Xpadded\ypred; %levap contains intercept and slope of regression

% %Lowess smoothing of lake d18O time series
% slake = fit([lake.Date,lake.d18O], 'lowess');

figure(3)
s9 = scatter(lake.Date,lake.d18O,'filled');
s9.Marker = 'o';
s9.SizeData = 65;
s9.LineWidth = 1.5;
s9.MarkerEdgeColor = [0 0.42 0.31];
s9.MarkerFaceColor = [0 0.8 0.6];
ylim([4 7])

figure(4)
s9 = scatter(lake.Date,lake.dD,'filled');
s9.Marker = 'o';
s9.SizeData = 65;
s9.LineWidth = 1.5;
s9.MarkerEdgeColor = [0 0.42 0.31];
s9.MarkerFaceColor = [0 0.8 0.6];
