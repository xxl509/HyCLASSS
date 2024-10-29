function [featureMatrix,featureLabel] = FeaturesJinAdd(signalData,signalLabel,epochWidth, noverlap,BinWidth,SR)

if strcmp(signalLabel,'HRate') % Heart Rate
    disp(['    Extracting features from ECG. Algorithms from Jing.']);
    % epochWith = 2 min, overlapWidth = 30s
    % totally, 84 features from ECG
    epochWidth = 120;
    noverlap = 30;
    BinWidth = 1;
    warning off;
    xStart = 1:SR*noverlap:length(signalData)-SR*epochWidth+1;
    xEnd   = xStart+SR*epochWidth-1;
    disp(['ECG epoch:']);
    for s = 1: length(xStart)
        if length(unique(signalData(xStart(s):xEnd(s)))) == 1
            featvec(:,s) = [0];
        else
            [featvec(:,s), featnames] = aubt_extractFeatECG(signalData(xStart(s):xEnd(s)), SR);
        end
        
        fprintf('%d ',s);
    end
    featureMatrix = featvec;
    featureLabel = featnames';
    
    
    
    
elseif findstr(signalLabel,'C') % EEG
    disp(['    Extracting features from EEG. Algorithms from Jing.']);
    
    
    % epochWidth = 30s, BinWidth = 5s
    numPtsPer30secEpoch = SR*epochWidth;
    returnedNum30SecEpochs = length(signalData)/numPtsPer30secEpoch;
    
    signalData = reshape(signalData, 1, ...
        numPtsPer30secEpoch, returnedNum30SecEpochs);
    
    % Feature 1: C0 Complexity
    c0complexF = @(x)c0complex((signalData(:,:,x)),...
        SR,BinWidth,0);
    c0complexCell = cell2mat(arrayfun(c0complexF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    % Feature 2: Hjorth
    hjorthF = @(x)HjorthFea((signalData(:,:,x)),...
        SR,BinWidth);
    hjorthCell = cell2mat(arrayfun(hjorthF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    % the first line: Activity
    % the second line: Mobility
    % the third line: Complexity
    
    % Feature 3: lyapunov_Rosentein
    disp(['          epoch index in lyapunov_Rosentein: ']);
    lyapunovF = @(x)lyapunov_Rosentein((signalData(:,:,x)),...
        SR,BinWidth,x);
    lyapunovCell = cell2mat(arrayfun(lyapunovF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    % Feature 4: Shannon Entropy
    shannonF = @(x)shannon_entropy((signalData(:,:,x)),...
        SR,BinWidth,0);
    shannonCell = cell2mat(arrayfun(shannonF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    % Feature 5: Spectral Entropy
    spectralF = @(x)spectral_entropy((signalData(:,:,x)),...
        SR,BinWidth,0);
    spectralCell = cell2mat(arrayfun(spectralF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    % Feature 6: Kolmgolov Entropy
    disp(['        epoch index in Kolmgolov Entropy: ']);
    kolmgolovF = @(x)kolmgolov_entropy((signalData(:,:,x)),...
        SR,BinWidth,0,x);
    kolmgolovCell = cell2mat(arrayfun(kolmgolovF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    % Feature 7 : Skew£ºÆ«Ð±¶È
    % Feature 8: kurtosis ÇÍ¶È
    % Feature 9: mean
    xStart = 1:SR*BinWidth:numPtsPer30secEpoch;
    xEnd   = xStart+SR*BinWidth-1;
    StatisticsF = @(x)StatisticsFea((signalData(:,:,x)),...
        xStart,xEnd);
    StatisticsCell = cell2mat(arrayfun(StatisticsF, ...
        [1:returnedNum30SecEpochs],'UniformOutput', 0));
    
    StatName = {'Skew';'Kurt';'Mean'};
    
    featureMatrix = [c0complexCell;hjorthCell;lyapunovCell;shannonCell;spectralCell;kolmgolovCell;StatisticsCell];
    featureLabel = {'C0';'Activity';'Mobility';'Complexity';'Lyapunov';'Shannon';'Spectral';'Kolmgolov';StatName{1};StatName{2};StatName{3}};
    
    
    
end