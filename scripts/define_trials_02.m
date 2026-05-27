%% define_trials_02.m
% Purpose: Define trials for picture, visual word, and auditory word
% conditions

clear;
clc;

%% Run setup
run('setup_paths_00.m');

%% Check dataset

if ~isfile(dataset)
    error(['Dataset not found: ', dataset]);
end

%% Condition settings
% IMPORTANT:
% Change these trigger values based on EVENT VALUE SUMMARY from
% check_dataset_01.m

conditions = {
  'condition1', {'S111', 'S121', 'S131', 'S141', 'S151', 'S161', 'S171', 'S181'};
  'condition2', {'S112', 'S122', 'S132', 'S142', 'S152', 'S162', 'S172', 'S182'},;
  'condition3', {'S113', 'S123', 'S133', 'S143', 'S153', 'S163', 'S173', 'S183'},
};

%% Epoch settings

prestim = 0.2;  % 200 ms before stimulus onset
poststim = 0.8; % 800 ms after stimulus onset

%% Define trials for each condition

for c = 1:size(conditions, 1)

    cond_name = conditions{c, 1};
    trig_values = conditions{c, 2};

    fprintf('\n===== Condition: %s =====\n', cond_name);
    disp('Trigger value:');
    disp(trig_values);

    cfg = [];
    cfg.dataset = dataset;
    cfg.representation = 'table';

    cfg.trialdef.eventtype = 'Stimulus';
    cfg.trialdef.eventvalue = trig_values;
    cfg.trialdef.prestim = prestim;
    cfg.trialdef.poststim = poststim;

    try
        cfg = ft_definetrial(cfg);
        
        nTrials = size(cfg.trl, 1);
        fprintf('Number of trials: %d\n', nTrials);

        if nTrials > 0
            disp('First 5 rows of cfg.trl:');
            disp(cfg.trl(1:min(5, nTrials), :));
        end

        save_name = fullfile(result_dir, ['trl_', cond_name, '.mat']);
        save(save_name, 'cfg');

        fprintf('Saved trial definition: %s\n', save_name);

    catch ME
        warning('Could not define trials for %s', cond_name);
        disp(ME.message);
    end
end

disp('Trial definition complete.');