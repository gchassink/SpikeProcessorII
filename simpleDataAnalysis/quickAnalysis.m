
clear all

[file,path]= uigetfile
Ts_tot=[];Cs_tot=[];Ns_tot=[];Us_tot=[];
files= dir (fullfile(path , '*.mat'));
for i= 1:size (files,1)
load ([files(i).folder '\' files(i).name]);
Ts_tot=[Ts_tot; Ts];Cs_tot=[Cs_tot; Cs];Ns_tot=[Ns_tot; Ns];Us_tot=[Us_tot; Us]; firingRate=[];

end
figure;plot(Ts_tot);

% Identify the artifacts according to artifacts definition paper
disp('Detecting artifacts...');
[normalWaveforms, artifactWaveforms, artifactFlags] = detect_artifacts_fs_var(Cs_tot, Ts_tot, Us_tot, FileInfo.Samplerate);
%% determine types of artefacts
    % Check if the waveform holds true for the following thresholds
    % 1. There should be no peak in either negative or positive direction
    %   that is equal or larger than peak
    % 2. There should be no peak in a +- 1ms window of 90% strength
    % 3. There should be no peak in a +- 1ms window of 50% 
        % gerco 22-8-2018: must be more steep before the peak compared to after so
        % 0.5ms pre- till 1ms post-peak
    % 4. There should not be two identical timestamps
    % 5. There should not be a peak thats width is smaller than 2/16 ms at 50%
    % of original peak.

 Cs=Cs_tot(normalWaveforms);
Ts=Ts_tot(normalWaveforms);
Us=s_tot(normalWaveforms,:);
Ns=Ns_tot(normalWaveforms);




