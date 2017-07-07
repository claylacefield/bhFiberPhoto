function [tcStruc] = tcspcAnalysis(varargin)

%% USAGE: [tcStruc] = tcspcAnalysis(filename);
% Simple script for processing Sam's TCSPC data
% clay 2016

%% Select file to process
if nargin == 0
    [filename, path] = uigetfile('.txt', 'Select TCSPC .txt file (samples only)');
else
    filename = varargin{1};
    path = [pwd '\'];
end

%% Import data 
disp(['Importing data from: ' filename]); tic;
headerLines = 10;
delimiter = ' ';
dataStruc = importdata([path filename], delimiter, headerLines);
%frTimes = dataStruc.data(:,1);
ca = dataStruc.data(:,1);
toc;


%% Process the data
ca2 = runmean(ca, 20);  % smooth in 20ms bins
ca3 = ca2-runmean(ca2,8000);     % subtract slow component

sd3 = std(ca3)*0.5;    % event threshold

pks = LocalMinima(-ca3, 1000, -sd3);  % find events

evRateHz = 1000/mean(diff(pks));    % event rate

ac = xcorr(ca,ca, 10000);   % autocorrelation


%% save to output struc
tcStruc.filename = filename;
tcStruc.frTimes = 0:0.001:length(ca2); %frTimes;
tcStruc.ca = ca2;
tcStruc.caPks = pks;
tcStruc.evRateHz = evRateHz;
tcStruc.caAutoCorr = ac;

%% plotting

figure; 
subplot(2,1,1);
t = 1:length(ca2);
plot(ca2, 'g'); hold on;
xlim([1 length(ca2)]);
plot(t(pks), ca2(pks), 'r.', 'MarkerSize', 14); hold off;
title([filename ' calcium signal w. detected pks']);

subplot(2,1,2);
plot(ac);
xlim([1 length(ac)]);
title('autocorrelation');

