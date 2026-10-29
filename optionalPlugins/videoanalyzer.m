clear all
close all
%uiwait(msgbox('Interface board not connected,...starting in read mode'));
[file,path]= uigetfile('C:\Users\HassinkGC\OneDrive - University of Twente\Desktop\temp\mixed_Hypoxia_001_mwd.h5', 'Select a  Hdf5 or raw*mat file');
        DirRawNeffile=dir([path '\' '*.nef']); 
        DirRawNeffile2=struct2table(DirRawNeffile);
        DirRawNeffile3=sortrows(DirRawNeffile2,'datenum', 'ascend');
        DirRawNeffile=table2struct(DirRawNeffile3);

folder = 'C:\DATA\test\casper\';  % pas dit aan
outputVideo = VideoWriter([folder 'green.mp4'], 'MPEG-4');  % output videobestand
outputVideo.FrameRate = 10;  % pas aan indien gewenst (frames per seconde)
open(outputVideo);     
for k=1:size(DirRawNeffile,1)
    k
    imgPath = fullfile(path, DirRawNeffile(k).name);
    img = imread(imgPath);
    f = figure('Visible', 'on');  % of 'on' als je het wil zien
    imagesc(img(:,:,2));
    axis off; axis image;  % netjes kadreren
    colormap(parula);      % of 'jet', 'hot', etc.
    colorbar;              % optio
    frame = getframe(gca);           % alleen de axes, of gebruik gcf voor hele figuur
    [falsecolor, ~] = frame2im(frame);
    writeVideo(outputVideo, falsecolor);
    close
end
outputVideo = VideoWriter([folder 'red.mp4'], 'MPEG-4');  % output videobestand
outputVideo.FrameRate = 10;  % pas aan indien gewenst (frames per seconde)
open(outputVideo);     
for k=1:size(DirRawNeffile,1)
    k
    imgPath = fullfile(path, DirRawNeffile(k).name);
    img = imread(imgPath);
    f = figure('Visible', 'on');  % of 'on' als je het wil zien
    imagesc(img(:,:,1));
    axis off; axis image;  % netjes kadreren
    colormap(parula);      % of 'jet', 'hot', etc.
    colorbar;              % optio
    frame = getframe(gca);           % alleen de axes, of gebruik gcf voor hele figuur
    [falsecolor, ~] = frame2im(frame);
    writeVideo(outputVideo, falsecolor);
    close
end
%%
outputVideo = VideoWriter([ folder 'ratio.mp4'] , 'MPEG-4');  % output videobestand
outputVideo.FrameRate = 10;  % pas aan indien gewenst (frames per seconde)
open(outputVideo);     
for k=1:size(DirRawNeffile,1)
    k
    imgPath = fullfile(path, DirRawNeffile(k).name);
    img = imread(imgPath);
    f = figure('Visible', 'on');  % of 'on' als je het wil zien
    green=img(:,:,2);
    red=img(:,:,1);
    ratio=double(red-green)./double(green+red);
    imagesc(ratio);
    axis off; axis image;  % netjes kadreren
    colormap(parula);      % of 'jet', 'hot', etc.
    colorbar;              % optio
    frame = getframe(gca);           % alleen de axes, of gebruik gcf voor hele figuur
    [falsecolor, ~] = frame2im(frame);
    writeVideo(outputVideo, falsecolor);
    close
     
writeVideo(outputVideo, falsecolor);
end
close(outputVideo);