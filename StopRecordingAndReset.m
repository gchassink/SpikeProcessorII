%% cleans up recording remnants
    disp ('recording stopped');
    delete ('recording_on.mat'); 
    movefile('startup.m','startup.txt', 'f');
    delete(timerfind);
