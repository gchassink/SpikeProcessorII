%% System=write_raw( Raw, System)
% requires inititialize_raw
% writes a formatted Level 4 MAtfile (Matlab V4.2)
% Adapted from Level 4 MATfile documentation:
%       A MAT-file may contain one or more matrices. The matrices are written sequentially on disk, with the
%       bytes forming a continuous stream. Each matrix starts with a fixed-length 20-byte header that
%       contains information describing certain attributes of the Matrix. The 20-byte header consists of fiv
%       long (4-byte) integers:
%       for RAW data stream this means:
%       System.type (MOPT) = 0030
%           M=0 (IEEE Little Endian (PC, 386, 486, DEC Risc))
%           O=0 (is always 0 (zero) and is reserved for future use.)
%           P=3 (16-bit signed integers;[-32767:32767])
%           T=0 (Numeric (Full) matrix)
%       mrows(System.totalchannels) (The row dimension contains an integer with the number of rows in the matrix.)
%       System.mcols (The column dimension contains an integer with the number of columns in the matrix.)
%       System.imagf = 0(The imaginary flag is an integer whose value is either 0 or 1. If 1, then the matrix has an imaginary part. If 0, there is only real data.)
%       System.namlen (The name length contains an integer with 1 plus the length of the matrix name.) 
%
% The level 4 matlab format allows only
%       100.000.000 bytes per variable which is
%       ~64*60*25000 data points
%       so either store multiple variables or,
%       write a new version of MAT_read to read the extended format (python reads it no problem anyway) or,
%       save multiple sequential files.
%       Since the latter is more easy to concatenate in we opted for this option.


function System=write_video( Raw, System)
    
fid = fopen([System.rawName '.mat'],'a');
    if System.type==10
        fwrite(fid, Raw(:),'single');
    else
        fwrite(fid, Raw(:),'integer*2');
    end
    System.rawsize=ftell(fid);
    rawsize = System.rawsize;
    fclose(fid);

end

