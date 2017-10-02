function [eventFpStruc, fpStruc, behavStruc] = fpBehavWrapAll()

% Clay April 20, 2017
% This is a wrapper script that processes data for TDT fiber photometry
% data along with operant behavior for the Ansorge lab.

% process fiber photometry data
[fpStruc] = procFPdata();

% process behavior
[behavStruc] = procFPbehavMedAssoc();

% extract corr/incorr trial times
[behavStruc] = findIncorrTrials(behavStruc);

% compute event triggered average for desired event
behavFields = fieldnames(behavStruc);
%figure; hold on;
for i = 1:length(behavFields)
    eventName = behavFields{i};
    if ~isempty(strfind(eventName, 'Trial'))
        try
        eventCa = calcEventTrigFPsig(fpStruc, behavStruc, eventName, 0);
        eventFpStruc.([eventName 'Ca']) = eventCa;
        catch
           disp(['No events of type: ' eventName]); 
        end
    end
    
end

fields = fieldnames(eventFpStruc);
figure;
for j = 1:length(fields)
    subplot(2,2,j);
    %plotMeanSEM(eventFpStruc.(fields{j}), 'b');
    plotFPeventShade(eventFpStruc.(fields{j}), [-10 30]);
    title(fields{j});
    
end
