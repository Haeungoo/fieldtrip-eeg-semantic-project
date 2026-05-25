%% setup_paths_00.m
% Purpose: Set project paths and initialize FieldTrip

clear;
clc;

% Add FieldTrip path
fieldtrip_dir = fullfile(getenv('HOME'), 'Documents', 'MATLAB', 'fieldtrip');

if ~isfolder(fieldtrip_dir)
    error('FieldTrip folder not found. Check fieldtrip_dir path.');
end

addpath(fieldtrip_dir);
ft_defaults;

%% 2. Define project folders
project_dir = fullfile(getenv('HOME'), 'Documents', 'MATLAB', 'fieldtrip_semantic_project');

raw_dir = fullfile(project_dir, 'data_raw');
prep_dir = fullfile(project_dir, 'data_preprocessed');
result_dir = fullfile(project_dir, 'results');
fig_dir = fullfile(project_dir, 'figures');
note_dir = fullfile(project_dir, 'notes');
script_dir = fullfile(project_dir, 'scripts');

%% 3. Define possible real dataset path
dataset = fullfile(raw_dir, 'subj2.vhdr');

%% 4. Check FieldTrip

disp('==== FieldTrip Setup ====');
disp(['FieldTrip folder: ', fieldtrip_dir]);
disp(['Project folder: ', project_dir]);
disp(['Dataset path: ', dataset]);

disp('Checking FieldTrip functions...');
which ft_defaults
which ft_preprocessing
which ft_timelockanalysis
which ft_freqanalysis

disp('Setup complete.');
