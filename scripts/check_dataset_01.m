%% check_dataset_01.m
% Purpose: Check EEG dataset header and event markers

clear;
clc;

%% Run setup

run('setup_paths_00.m');

%% Check whether dataset exists

if ~isfile(dataset)
    error(['Dataset not found: ', dataset, newline, ...
        'Please put subj2.vhdr, subj2.eeg, subj2.vmrk into data_raw folder.']);
end

%% Read header information

hdr = ft_read_header(dataset);

disp(' ');
disp('===== HEADER INFO =====');
disp(['Number of channels: ', num2str(hdr.nChans)]);
disp(['Sampling rate: ', num2str(hdr.Fs), 'Hz']);
disp(['Number of samples: ', num2str(hdr.nSamples)]);

event = ft_read_event(dataset);

disp(' ');
disp('===== Event INFO =====');
disp(['Number of events: ', num2str(length(event))]);

disp(' ');
disp('First 30 events: ');

for i = 1:min(30, length(event))
    fprintf('%d: type=%s, value=%s, sample=%d\n', ...
        i, string(event(i).type), string(event(i).value), event(i).sample);
end

%% Count event values

disp(' ');
disp('===== EVENT VALUE SUMMARY =====');

event_values = {};

for i = 1:length(event)
    if isfield(event(i), 'value') && ~isempty(event(i).value)
        event_values{end+1} = char(string(event(i).value));

    end
end

unique_values = unique(event_values);

for i = 1:length(unique_values)
    count_value = sum(strcmp(event_values, unique_values{i}));
    fprintf('%s: %d events\n', unique_values{i}, count_value);
end

disp(' ');
disp('Dataset check complete.');