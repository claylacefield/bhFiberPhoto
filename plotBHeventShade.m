function plotBHeventShade(eventCa) %, firstLastTime)

% Requirements:
% - shadedErrorBar (MATLAB exchange)

%x = linspace(firstLastTime(1), firstLastTime(2), size(ca,1)); 
%figure;
% x = firstLastTime(1):0.001:firstLastTime(2);
x = -5:0.001:10;

avgCa = mean(eventCa,2);
sem = nanstd(eventCa,0,2)/sqrt(size(eventCa,2));

maxVal = max(avgCa+sem)+0.5;
minVal = min(avgCa-sem)-0.5;

shadedErrorBar(x, avgCa, sem, 'b', 1);

line([0 0], [minVal maxVal]);

ylim([minVal maxVal]);

xlabel('sec');