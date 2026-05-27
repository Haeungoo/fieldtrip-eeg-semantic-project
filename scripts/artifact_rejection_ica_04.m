%% artifact_rejection_ica_04.m
% Purpose: Artifact rejection and ICA for condition1 EEG data
clear;
clc;

%% Run setup
run('setup_paths_00.m');

%% Load preprocessed data
preproc_file = fullfile(prep_dir, 'data_condition1_preproc.mat');

if ~isfile(preproc_file)
    error('Preprocssed file not found. Run preprocsee_all_conditions_03.m first.');
end

load(preproc_file);
% This should load variable: data_preproc

disp('Loaded preprocessed data.');
fprintf('Number of trials before visual rejection: %d\n', length(data_preproc.trial));
fprintf('Number of channels: %d\n', length(data_preproc.label));
fprintf('Sampling rate: %.1f Hz\n', data_preproc.fsample);

%% 1. Visual artifact rejection
cfg = [];
cfg.method = 'summary';

disp('Opening visual artifact rejection window...');
data_visual_clean = ft_rejectvisual(cfg, data_preproc);

fprintf('Number of trials after visual rejection: %d\n', length(data_visual_clean.trial));

%% 2. ICA

cfg = [];
cfg.method = 'runica';

disp('Running ICA...');
comp = ft_componentanalysis(cfg, data_visual_clean);

disp('ICA complete');

%% 3. Inspect ICA component topographies

cfg = [];
cfg.component = 1:min(20, length(comp.label));
cfg.layout = 'easycapM1.lay';

figure;
ft_topoplotIC(cfg, comp);
title('ICA component topographies');

%% 4. Inspect ICA component time courses

cfg = [];
cfg.viewmode = 'component';
cfg.layout = 'easycapM1.lay';

disp('Opening component browser...');
ft_databrowser(cfg, comp);

%% 5. Select artifact components
disp('Look at the ICA topography and time course.');
disp('Eye blink components often show strong frontal activity.');
disp('Muscle components often show noisy/high-frequency activity.');

artifact_components = input('Enter artifact components to remove, e.g., [1 3], or [] if none: ');

if isempty(artifact_components)
    disp('No components removed.');
    data_clean = data_visual_clean;
else
    cfg = [];
    cfg.component = artifact_components;

    data_clean = ft_rejectcomponent(cfg, comp, data_visual_clean);
    fprintf('Removed components:');
    disp(artifact_components);
end

%% 6. Save clean data

save_name = fullfile(prep_dir, 'data_condition1_clean.mat');
save(save_name, 'data_clean', '-v7.3');

fprintf('Saved clean data: %s\n', save_name);

disp('Artifact rejection and ICA complete.');