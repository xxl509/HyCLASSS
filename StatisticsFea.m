function [Statistics] = StatisticsFea(signalData,Start, End)

for s =  1: length(Start)
    Skew(s) = skewness(signalData(Start(s):End(s)));
    Kurt(s) =kurtosis(signalData(Start(s):End(s)));
    Aver(s) = mean(signalData(Start(s):End(s)));
end
SkewMean = mean(Skew);
KurtMean = mean(Kurt);
AverMean = mean(Aver);
Statistics = [SkewMean;KurtMean;AverMean];
% StatName = {'Skew';'Kurt','Mean'};