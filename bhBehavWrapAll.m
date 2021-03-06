function [eventFpStruc] = bhBehavWrapAll()

% Clay Oct 20, 2017
% This is a wrapper script that processes data for Becker-Hickl fiber photometry
% data along with GUI output behavior for Sam Clark (Sulzer lab).

% First, run the event selection GUI ("tcspcEventSelectGUI"), then run this
% script on the output, tcBehStruc.

[filename, path] = uigetfile('.mat', 'Select tcBehStruc.mat to process');
load([path filename]);

% Copy some info to output struc
eventFpStruc.txtName = tcBehStruc.filename;
eventFpStruc.tcbName = filename;
eventFpStruc.procDate = date;
eventFpStruc.behavType = tcBehStruc.behavType;


% Load in fields for processing
evTypeCell = tcBehStruc.evTypeCell;
evTimes = tcBehStruc.evTimes;
evTypeArr = tcBehStruc.evTypeArr;
ca = tcBehStruc.ca;


% compute event triggered average for desired event

for i = 1:length(evTypeCell)
    eventName = evTypeCell{i};
    disp(['Processing: ' eventName]);
    thisEvTimes = evTimes(find(evTypeArr==i));
    newEvName = [eventName 'Times'];
    eventFpStruc.(newEvName) = thisEvTimes;
    
%     if ~isempty(strfind(eventName, 'Trial'))
        try
        [eventCa] = calcEventTrigBHsig(ca, thisEvTimes, 0);
        eventFpStruc.([eventName 'Ca']) = eventCa;
        catch
           disp(['No events of type: ' eventName]); 
        end
%     end
    
end

fields = fieldnames(eventFpStruc);
k=0;
figure;
for j = 1:length(fields)
    if ~isempty(strfind(fields{j}, 'Ca'))
%         try
            k = k +1;
            subplot(3,3,k);
            %plotMeanSEM(eventFpStruc.(fields{j}), 'b');
            plotBHeventShade(eventFpStruc.(fields{j})); %, [-4 10]);
            title(fields{j});
            xlim([-5 10]);
%         catch
%             disp(['Problem with ' fields{j}]);
%         end
    end
end
