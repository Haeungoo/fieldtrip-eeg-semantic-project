# Day 2 Preprocessing Notes

## Dataset
- Dataset: subj2.vhdr
- Sampling rate: 500 Hz
- Number of channels: 64

## Conditions
- condition1: Sxx1 triggers
- condition2: Sxx2 triggers
- condition3: Sxx3 triggers

## Epoch
- Prestim: 0.2 sec
- Poststim: 0.8 sec
- Baseline: -0.2 to 0 sec

## Preprocessing settings
- High-pass filter: 0.5 Hz
- Low-pass filter: 40 Hz
- Band-stop filter: 59-61 Hz
- Reference: average reference
- Demean: yes
- Baseline window: -0.2 to 0 sec

## Output files
- data_condition1_preproc.mat
- data_condition2_preproc.mat
- data_condition3_preproc.mat
 
