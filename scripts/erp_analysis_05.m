%% erp_analysis_05.m
% Purpose: ERP analysis for condition1, condition2, and condition3

clear;
clc;

%% Run setup

run('setup_paths_00.m');

%% Load condition1 data
% Prefer clean data if available

condition1_clean_file = fullfile(prep_dir, 'data_condition1_clean.mat');
condition1_preproc_file = fullfile(prep_dir, 'data_condition1_preproc.mat');

if isfile(condition1_clean_file)
    load(condition1_clean_file);
    data_condition1 = data_clean;
    disp('Loaded condition1 clean data.');
elseif isfile(condition1_preproc_file)
    load(condition1_preproc_file);
    data_condition1 = data_preproc;
    disp('Loaded condition1 preprocessed data.');
else
    error('Condition1 data not found.');
end

%% Load condition2 data

condition2_file = fullfile(prep_dir, 'data_condition2_preproc.mat');

if isfile(condition2_file)
    load(condition2_file);
    data_condition2 = data_preproc;
    disp('Loaded condition2 preprocessed data.');
else
    error('Condition2 data not found.');
end

%% Load condition3 data

condition3_file = fullfile(prep_dir, 'data_condition3_preproc.mat');

if isfile(condition3_file)
    load(condition3_file);
    data_condition3 = data_preproc;
    disp('Loaded condition3 preprocessed data.');
else
    error('Condition3 data not found.');
end

%% Check trial numbers

fprintf('Condition1 trials: %d\n', length(data_condition1.trial));
fprintf('Condition2 trials: %d\n', length(data_condition2.trial));
fprintf('Condition3 trials: %d\n', length(data_condition3.trial));

%% ERP analysis
% ERP = average across trials

cfg = [];

erp_condition1 = ft_timelockanalysis(cfg, data_condition1);
erp_condition2 = ft_timelockanalysis(cfg, data_condition2);
erp_condition3 = ft_timelockanalysis(cfg, data_condition3);

disp('ERP computation complete.');

%% Baseline correction
% Baseline: -0.2 to 0 sec

cfg = [];
cfg.baseline = [-0.2 0];

erp_condition1_bl = ft_timelockbaseline(cfg, erp_condition1);
erp_condition2_bl = ft_timelockbaseline(cfg, erp_condition2);
erp_condition3_bl = ft_timelockbaseline(cfg, erp_condition3);

disp('Baseline correction complete.');

%% Save ERP results

save(fullfile(result_dir, 'erp_condition1.mat'), 'erp_condition1_bl');
save(fullfile(result_dir, 'erp_condition2.mat'), 'erp_condition2_bl');
save(fullfile(result_dir, 'erp_condition3.mat'), 'erp_condition3_bl');

disp('ERP results saved.');

%% Plot ERP comparison - channel 1

cfg = [];
cfg.channel = erp_condition1_bl.label{1};
cfg.linewidth = 2;
cfg.graphcolor = ['b' 'r' 'g'];

figure;

ft_singleplotER(cfg, ...
    erp_condition1_bl, ...
    erp_condition2_bl, ...
    erp_condition3_bl);

legend({'Condition 1', 'Condition 2', 'Condition 3'});

title(['ERP comparison at channel ' ...
    erp_condition1_bl.label{1}]);

xlabel('Time (s)');
ylabel('Amplitude');

%% Plot ERP comparison - channel 2

cfg = [];
cfg.channel = erp_condition1_bl.label{2};
cfg.linewidth = 2;
cfg.graphcolor = ['b' 'r' 'g'];

figure;

ft_singleplotER(cfg, ...
    erp_condition1_bl, ...
    erp_condition2_bl, ...
    erp_condition3_bl);

legend({'Condition 1', 'Condition 2', 'Condition 3'});

title(['ERP comparison at channel ' ...
    erp_condition1_bl.label{2}]);

xlabel('Time (s)');
ylabel('Amplitude');

%% Skip topography for now

disp('-----------------------------------');
disp('Skipping topography plotting.');
disp('Reason: numeric channel labels do not');
disp('match standard EEG layouts.');
disp('-----------------------------------');

%% Check ERP structure

disp('ERP structure check:');
disp('Size of erp_condition1_bl.avg:');
disp(size(erp_condition1_bl.avg));

disp('First 10 channel labels:');
disp(erp_condition1_bl.label(1:min(10, length(erp_condition1_bl.label))));

disp('Time range:');
disp([erp_condition1_bl.time(1), erp_condition1_bl.time(end)]);

disp('Day 5 ERP analysis complete.');