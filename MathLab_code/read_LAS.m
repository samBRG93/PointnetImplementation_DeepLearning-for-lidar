%function outfile = all_matlab (infilename,outfilename,reduction)
% LASREAD reads in files in LAS 1.1 format and outputs comma delimited text files
%
% INPUT
% infilename:   input file name in LAS 1.1 format 
%               (for example, 'myinfile.las') 
% outfilename:  output file name in text format 
%               (for example, 'myoutfile.txt')
% nFields:      default value of 1 outputs X, Y and Z coordinates of the 
%               point - [X Y Z]. 
%               A value of 2 gives Intensity as an additional attribute - [X Y Z I].
%               A value of 3 gives the Return number and the Number of returns 
%               in addition to the above - [X Y Z I R N].                
%           
% OUTPUT
% outfile:      the output matrix
% 
% EXAMPLEf
% A = LASRead ('infile.las', 'outfile.txt', 3)
%
% Cici Alexander
% September 2008 (updated 26.09.2008)

% Open the file

function [data] = read_LAS(infilename)

% D=16;%+8;

% clear all

%infilename='20007.las';    %%%DA CAMBIRE A SECONDA DEI DATI
row_offset=1;
data_TOT=0;


lasHeaderInfo = read_las_header(infilename);

record_lenght=lasHeaderInfo{18,2};
if record_lenght==20
    D=16;
else D=24;
end

fid =fopen(infilename);

% Check whether the file is valid
if fid == -1
    error('Error opening file')
end

% Check whether the LAS format is 1.1
fseek(fid, 24, 'bof');
%    Vers
ionMajor = fread(fid,1,'uchar');
VersionMinor = fread(fid,1,'uchar');

% if VersionMajor ~= 1 || VersionMinor ~= 1
%     error('LAS format is not 1.1')
% end

% Read in the offset to point data
fseek(fid, 96, 'bof');
OffsetToPointData = fread(fid,1,'uint32');

% Read in the scale factors and offsets required to calculate the coordinates
fseek(fid, 131, 'bof');
XScaleFactor = fread(fid,1,'double');
YScaleFactor = fread(fid,1,'double');
ZScaleFactor = fread(fid,1,'double');
XOffset = fread(fid,1,'double');
YOffset = fread(fid,1,'double');
ZOffset = fread(fid,1,'double');

% The number of bytes from the beginning of the file to the first point record
% data field is used to access the attributes of the point data
%
c = OffsetToPointData;

% If nfields is not given, the default value is taken as 1
%
if nargin == 2
    nFields = 1; %%1
end

fseek(fid, c+14, 'bof');
R=int8(fread(fid,inf,'char',D+3));
R=dec2bin(R,8);
R=bin2dec(R(:,6:8));

% Read in the X coordinates of the points
%
% Reads in the X coordinates of the points making use of the
% XScaleFactor and XOffset values in the header.
fseek(fid, c, 'bof');
X1=fread(fid,inf,'int32',D);
X=X1*XScaleFactor+XOffset;
clear X1

% Read in the Y coordinates of the points
fseek(fid, c+4, 'bof');
Y1=fread(fid,inf,'int32',D);
Y=Y1*YScaleFactor+YOffset;
clear Y1

% Read in the Z coordinates of the points
fseek(fid, c+8, 'bof');
Z1=fread(fid,inf,'int32',D);
Z=Z1*ZScaleFactor+ZOffset;
clear Z1

fseek(fid, c+12, 'bof');
I=fread(fid,inf,'int16',D+2);

fseek(fid,c+15, 'bof');
C=fread(fid,inf, 'uchar',D+3);

fseek(fid,c+18, 'bof');
S=fread(fid,inf, 'uchar',D+3);

data=[X Y Z R I C S];

clear X
clear Y
clear Z
clear I
clear R
clear C
clear S

fclose(fid);
