function [FtotalSleep,FtotalNREM,FtotalREM] = compute_total_power(featureMatrix, sleepMask,nremMask,remMask)

FtotalSleep = mean(featureMatrix(:,sleepMask),2);
FtotalNREM = mean(featureMatrix(:,nremMask),2);
FtotalREM = mean(featureMatrix(:,remMask),2);
