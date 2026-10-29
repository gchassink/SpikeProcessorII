%% SPIKE_PROCESSOR_II()
% Generates an interface to connect to MultiChannelsystems MCS-IFB & MEA-2100.
%   
% In the SETUP_DEVICE screen you can set program defaults, INITALIZE_FILTER, GROUND_ELECTRODE
% grounded and channels to be stimulated, either using a random generator
% (STIMULATE_ELECTRODE) or stimulations can be read from file (STIMULATE_ELECTRODE_REPEATEDLY).
%
% When done, the the DAQ can be started in the next screen. The CORE loop 
% will then be started. Spike (WRITEDATA) and raw data (WRITE_RAW) can be saved, and several types of live 
% information graphs (UPDATE_RASTER, UPDATE_STIM_RESP_PLOT, UPDATE_WAVEPLOT, WRITE_RAW, WRITEDATA) can be selected.
%
% See also acquire_data, activate_electrode, cleanup_recording, core,
% crashresponse, detect_spikes, disp_error, estimate_noise, fastfindpeaks,
% ground_electrode, initialize_filter, initialize_file, initialize_raw_file,
% mea_cleanup, plot_spikes, plot_data, random_stimulation, setup_device,
% startup, stimulate, stimulate_from_list, stimulate_electrode, stimulate_burst
% stimulate_electrode_repeatedly, update_buttons, update_filetable, update_raster,
% update_stim_resp_plot, update_waveplot, write_raw, writedata
%
% Please alter appVersion in intialize_variables when altering the program
% Please download, install, and locate your version of McsFilterConfig.exe and
% adapt McsFilterConfig.lnk accordingly if necessary 
%
% Written in MATLAB R2019b
% profile on
warning('off', 'MATLAB:MatFile:OlderFormat')
 addpath(fullfile(pwd,'SPII_incubator_integration'));
 addpath(fullfile(pwd,'Callbacks'));
cleanupPreviousSession; % cleans up possible remnants of previous runs
global  Devices test  System FileInfo Figures Tmr ; % All variables structs that will be used eventually
System=struct; % contains all variabels used in programm for easy passing
FileInfo=struct; % contains all variabels used in programm that need to be saved 
FileInfo.AppVersion='3.0.0';% set your appVersion here as reference

initialize_variables; % intitialize variables

Figures.fig_init=SETUP_DEVICE; % loads the setup screen

[Figures.fig, btn_channel]=draw_main_GUI; % draws the main gui

cleanupObj = onCleanup(@()mea_cleanup(Devices)); % Makes sure that on any kind of communication error, the stg and dacq are stopped and disconnected.

START_MAIN_LOOP % starts the main loop, performs experiment until stopped by user

% end session
% close (Figures.fig_init);
% close (Figures.fig);%close (Figures.fig);
close all force
close_session
if System.criticalError==0
    clear all;
else
    clear all;
    %recordingIsOff
    SPIKE_PROCESSOR_II
end
    % comment out for debugging
% end
    



















