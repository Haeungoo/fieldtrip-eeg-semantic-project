%% preprocess_all_conditions_03.m
% Purpose: Preprocess EEG data for condition1, condition2, and condition3
clear;
clc;

%% Run setup
run('setup_paths_00.m');

%% Condition settings
% Must match define_trials_02.m

conditions = {
    'condition1', {'S111', 'S121', 'S131', 'S141', 'S151', 'S161', 'S171', 'S181'};
    'condition2', {'S112', 'S122', 'S132', 'S142', 'S152', 'S162', 'S172', 'S182'},;
    'condition3', {'S113', 'S123', 'S133', 'S143', 'S153', 'S163', 'S173', 'S183'},
    };

%% Epoch settings

prestim = 0.2;  % 200 ms before stimulus onset
poststim = 0.8; % 800 ms after stimulus onset

%% Preprocess each condition

for c = 1:size(conditions, 1)

    cond_name = conditions{c, 1};
    trig_values = conditions{c, 2};

    fprintf('\n===== Preprocessing: %s =====\n', cond_name);
    
    %% 1. Define trials
    
    cfg = [];
    cfg.dataset = dataset;
    cfg.representation = 'table';

    cfg.trialdef.eventtype = 'Stimulus';
    cfg.trialdef.eventvalue = trig_values;
    cfg.trialdef.prestim = prestim;
    cfg.trialdef.poststim = poststim;

    cfg = ft_definetrial(cfg);

    fprintf('Number of trials before preprocessing: %d\n', size(cfg.trl, 1));

    %% 2. Preprocessing settings

    % High-pass filter: remove slow drift
    cfg.hpfilter = 'yes';
    cfg.hpfreq = 0.5;

    % Low-pass filter: remove high-frequency noise
    cfg.lpfilter = 'yes';
    cfg.lpfreq = 40;  

    % Band-stop filter for 60 Hz line noise
    cfg.bsfilter = 'yes';
    cfg.bsfreq = [59 61];

    % Average reference
    cfg.reref = 'yes';
    cfg.refchannel = 'all';

    % Baseline correction / demean
    cfg.demean = 'yes';
    cfg.baselinewindow = [-0.2 0];

    %% 3. Run preprocessing
    data_preproc = ft_preprocessing(cfg);

    %% 4. Check output

    fprintf('Number of trials after preprocessing: %d\n', length(data_preproc.trial));
    fprintf('Number of channels: %d\n', length(data_preproc.label));
    fprintf('Sampling rate: %.1f Hz\n', data_preproc.fsample);

    fprintf('Size of first trial: ');
    disp(size(data_preproc.trial{1}));

    %% 5. Save preprocessed data

    save_name = fullfile(prep_dir, ['data_', cond_name, '_preproc.mat']);
    save(save_name, 'data_preproc', '-v7.3');

    fprintf('Saved preprocessed data: %s\n', save_name);
end

disp('All conditions preprocessed.');