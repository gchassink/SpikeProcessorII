vid = videoinput('winvideo', 1, 'YUY2_640x480');  % Check via imaqhwinfo
vid.FramesPerTrigger = Inf;
vid.ReturnedColorspace = 'rgb';
vid.FrameGrabInterval = 2;

% Start capturing
start(vid)
disp('Filmen gestart...');
pause(10);  % 10 seconden opnemen
stop(vid)
disp('Gestopt.');

% Video opslaan
frames = getdata(vid);
videoFile = 'output.avi';
v = VideoWriter(videoFile, 'Motion JPEG AVI');
open(v);
for k = 1:size(frames,4)
    writeVideo(v, frames(:,:,:,k));
end
close(v);
clear vid;
