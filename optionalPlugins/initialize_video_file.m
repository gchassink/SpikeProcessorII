%% System = initialize_raw_file(rawName, System, FileInfo)
% inititiates a file for storing raw data formatted as Level 4 MAtfile (Matlab V4.2)
% 
% A MAT-file may contain one or more matrices. The matrices are written sequentially on disk, with the
% bytes forming a continuous stream. Each matrix starts with a fixed-length 20-byte header that
% contains information describing certain attributes of the Matrix. The 20-byte header consists of fiv
% long (4-byte) integers:
% for RAW data stream this means:
% System.type (MOPT) = 0030
%   M=0 IEEE Little Endian (PC, 386, 486, DEC Risc))
%   O=0 is always 0 (zero) and is reserved for future use.
%   P=3 16-bit signed integers;[-32767:32767]
%   T=0 Numeric (Full) matrix
% mrows(System.totalchannels) The row dimension contains an integer with the number of rows in the matrix.
% System.mcols The column dimension contains an integer with the number of columns in the matrix.
% System.imagf = 0 The imaginary flag is an integer whose value is either 0 or 1. 
%   If 1, then the matrix has an imaginary part. 
%   If 0, there is only real data.
% System.namlen The name length contains an integer with 1 plus the length of the matrix name. 
%   The level 4 matlab format allows only 100.000.000 bytes per variable
%   which is ~64*60*25000 data points.
%   So either store multiple variables or multiple files, the latter is more
%   easy to concatenate in reading operations so for now we chose seperate
%   files.
function System = initialize_video_file(rawName, System, FileInfo)

% Controleer beschikbare camera's
clear System.cam;
close(System.v);
camList = webcamlist;
%disp('Beschikbare camera''s:');
%disp(camList);

% Selecteer je camera (pas index aan indien nodig)
System.cam = webcam(1);  % Of gebruik naam bijv. webcam('Logitech HD Webcam C270')

% Stel opname-instellingen in
System.cam.Resolution = '640x480';  % Pas aan indien nodig

% Stel video-opslagbestand in
System.rawName=rawName;
videoFile = 'output_video.avi';
System.v = VideoWriter([System.rawName ], 'Motion JPEG AVI');
System.v.FrameRate = 30;  % Frames per seconde
open(System.v);

% Opnameparameters
duration = 60;  % aantal seconden opnemen
numFrames = System.v.FrameRate * duration;
% 
% System.rawName=rawName;
% fid = fopen([System.rawName '.avi'],'w');
% System.mcols= System.rawFileLength * FileInfo.Samplerate;
% fwrite(fid,System.type, 'long');% 'integer*4'
% fwrite(fid,System.ChannelsUsed, 'long');
% fwrite(fid,System.mcols, 'long');
% fwrite(fid,System.imagf, 'long');
% fwrite(fid,System.namlen, 'long');
% fwrite(fid,System.var, 'char');%'\0'
% System.rawsize=ftell(fid);
% fclose(fid);
end