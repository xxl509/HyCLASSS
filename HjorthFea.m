function  [actMobCom] = HjorthFea(signalData,SR,BinWidth)

% Segment data for using function 'F_hjorth'

L = length(signalData);
xStart = 1:SR*BinWidth:L;
xEnd   = xStart+SR*BinWidth-1;

for s = 1: length(xStart)
    [ACTIVITY(s), MOBILITY(s), COMPLEXITY(s)] = F_hjorth(signalData(xStart(s):xEnd(s)));
end

activity = mean(ACTIVITY);
mobility = mean(MOBILITY);
complexity = mean(COMPLEXITY);
actMobCom = [activity;mobility;complexity];



