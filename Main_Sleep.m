function a = Main_Sleep(dataFolder,resultFolder)
% [edfFilePath,edfFileNum] = getcell(dataFolder,'.edf');
% [xmlFilePath,xmlFileNum] = getcell(dataFolder,'.xml');

analysisSignals = {'EEG'};
referenceSignals = {};
% analysisSignals = {'C3','C4'};%{'HRate'};
% referenceSignals = {'A1','A2'};%{};
referenceMethod = 3;
compute_coherence = 1; % perform Coherence Estimate
pm_analysis_spectral_settings = 2; % Spectral parameters
band_setting_fn_selected = 0;
analysisDescription = 'Sleep Data Features';
startFile = 1;
deltaTh = 2.5; % delta:0.6-4.6 Hz
betaTh = 2; % beta:40-60 Hz
monitorID = [0 0 1025 769]; % position to display
outputFilePrefix = '031_032_SleepData';

% Define GUI variables
folderSeperator = '/'; % Used on Mac

% folderSeperator = '\'; % used on Windows
% handles.data_folder_path = results_folder;
% handles.data_folder_path_is_selected = 0;
% handles.result_folder_path = results_folder;
% handles.result_folder_path_is_selected = 0;
% handles.edfFileListName = '';
% handles.splitFileListCellwLabels = {};
% Define Band Summary files
band_setting_fn = '';
band_setting_pn = strcat(resultFolder, folderSeperator);
% handles.band_setting_fn_selected = 0;


% for file_i = 1:edfFileNum
%     [edfSubFileString] = regexp(edfFilePath{file_i}, '\', 'split');
% dataFolder = file_path{file_i};
%     outputFilePrefix = strrep(edfSubFileString{end}, '.edf', '');

% Create spectral analysis structure
% variables:
stcStruct.analysisDescription = analysisDescription;
stcStruct.StudyEdfFileListResultsFn = strcat(outputFilePrefix,'_FileList.xls');
stcStruct.StudyEdfDir = strcat(dataFolder,folderSeperator);
stcStruct.StudyEdfResultDir = strcat(resultFolder,folderSeperator);
stcStruct.xlsFileContentCheckSummaryOut =  strcat(outputFilePrefix,'_FileLisWithCheck.xls');
stcStruct.analysisSignals = analysisSignals;
stcStruct.referenceSignals = referenceSignals;
stcStruct.requiredSignals = [analysisSignals referenceSignals];
stcStruct.StudySpectrumSummary = strcat(outputFilePrefix, '_SpectralSummary.xls');
stcStruct.StudyBandSummary = strcat(outputFilePrefix, '_BandSummary.xls');
stcStruct.checkFile = strcat(stcStruct.StudyEdfResultDir,stcStruct.StudyEdfFileListResultsFn);

% Create class object
stcObj = SpectralTrainClass(stcStruct);


% Define options for minimum reccomendedoutput
stcObj.referenceMethodIndex = referenceMethod;
stcObj.SUMMARIZE_BANDS = 1;
stcObj.EXPORT_BAND_SUMMARY = 1;
stcObj.PLOT_CALIBRATION_TEST = 0;
stcObj.PLOT_COMPREHENSIVE_SPECTRAL_SUMMARY = 1;
stcObj.PLOT_HYPNOGRAM = 0;
stcObj.PLOT_ARTIFACT_SUMMARY = 0;
stcObj.PLOT_SPECTRAL_SUMMARY = 0;
stcObj.PLOT_NREM_REM_SPECTRUM = 1;
stcObj.OUTPUT_AVERAGE_SPECTROGRAMS = 1;
stcObj.PLOT_BAND_ACTIVITY = 0;
stcObj.artifactTH = [deltaTh betaTh];
stcObj.figPos = monitorID;
stcObj.GENERATE_FILE_LIST = 1;
stcObj.CREATE_POWER_POINT_SUMMARY = 1;
stcObj.EXPORT_SPECTRAL_DETAILS = 1;
stcObj.COMPUTE_TOTAL_POWER = 1;
stcObj.EXPORT_TOTAL_POWER = 1;

% Set file identification parameters
%     [xmlSubFileString] = regexp(xmlFilePath{file_i}, '\', 'split');
%     xmlName =  strrep(xmlSubFileString{end}, '.xml', '');
xmlSuffix = '-profusion.xml';
stcObj.xmlSuffix = xmlSuffix;

% Spectral parameters
if (pm_analysis_spectral_settings == 2)
    % Switch to SHHS settings
    stcObj.noverlap = 6;
    stcObj.spectralBinWidth = 5;
    stcObj.windowFunctionIndex = 3; % Hanning
    stcObj.AVERAGE_ADJACENT_BANDS = 0;
end
% Band settings
if band_setting_fn_selected == 1
    % Load band structure
    bandFn = strcat(band_setting_pn, band_setting_fn);
    bandStruct = stcObj.LoadBandSettings(bandFn);
    
    % Set band variables
    stcObj.bandsOfInterest = bandStruct.bandsOfInterest;
    stcObj.bandsOfInterestLabels = bandStruct.bandsOfInterestLabels;
    stcObj.bandsOfInterestLatex = bandStruct.bandsOfInterestLatex;
    stcObj.bandColors = bandStruct.bandColors;
end
% Coherence Parametes
stcObj.COHERENCE_COMPUTE_COHERENCE = compute_coherence;
% Set start iterion
stcObj.startFile = startFile;

% Execute analysis
stcObj = stcObj.computeSpectralTrain;

clear subFileString outputFilePrefix stcStruct;
% end



