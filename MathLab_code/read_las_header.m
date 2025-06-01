function lasHeaderInfo = read_las_header(lasFilename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Reads and displays the header information from a lidar data file in    %
%  the American Society for Photogrammetry & Remote Sensing (ASPRS) LAS   %
%  format, as specified in the following document: "LAS Specification     %
%  Version 1.2" ASPRS, April 29, 2008.  It should be backwards-           %
%  compatible, with respect to the LAS version (i.e., header information  %
%  from lidar files in LAS 1.0 and 1.1 formats should display fine).      %
%                                                                         %
%  Input:                                                                 %
%     lasFilename: Path and filename of LAS file                          %
%                  Example of calling this function:                      %
%                  headerInfo = read_las_header('C:\my_lidar_file.las');  %
%                                                                         %
%  Output:                                                                %
%     lasHeaderInfo: 37x2 cell arrray containing all the info read in     %
%                    from the LAS file header. If coordinate system info  %
%                    is missing, then lasHeaderInfo will be a 36x2 cell   %
%                    array.                                               %
%                                                                         %
%  Chris Parrish                                                          %
%  Created:  5/13/2008                                                    %
%  Modified: 2/26/2009: Minor edits in preparation to post on MATLAB      %
%                       Central. Tested in MATLAB v7.0.1.15 (R14) and     %
%                       Octave v3.0.3.                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Open the LAS file
fid=fopen(lasFilename);
if fid == -1 
    error('LAS file could not be opened; check filename and path.')
end

% Read the header info. Numeric data is always read in as a double because 
% built-in MATLAB funtions typically expect doubles.
lasHeaderInfo(1,1:2) = [{'File Signature'}; ...
    {sscanf(char(fread(fid,4,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(2,1:2) = [{'File Source ID'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(3,1:2) = [{'Global Encoding'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(4,1:2) = [{'Project ID - GUID data 1'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(5,1:2) = [{'Project ID - GUID data 2'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(6,1:2) = [{'Project ID - GUID data 3'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(7,1:2) = [{'Project ID - GUID data 4'}; ...
    {sscanf(char(fread(fid,8,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(8,1:2) = [{'Version Major'}; ...
    {sscanf(char(fread(fid,1,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(9,1:2) = [{'Version Minor'}; ...
    {sscanf(char(fread(fid,1,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(10,1:2) = [{'System Identifier'}; ...
    {sscanf(char(fread(fid,32,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(11,1:2) = [{'Generating Software'}; ...
    {sscanf(char(fread(fid,32,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(12,1:2) = [{'File Creation Day of Year'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(13,1:2) = [{'File Creation Year'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(14,1:2) = [{'Header Size'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(15,1:2) = [{'Offset to point data'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(16,1:2) = [{'Number of variable length records'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(17,1:2) = [{'Point Data Format ID'}; ...
    {sscanf(char(fread(fid,1,'uchar=>uchar')'),'%c')}];
lasHeaderInfo(18,1:2) = [{'Point Data Record Length'}; ...
    {fread(fid,1,'uint16=>double')}];
lasHeaderInfo(19,1:2) = [{'Number of point records'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(20,1:2) = [{'Number of points return 1'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(21,1:2) = [{'Number of points return 2'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(22,1:2) = [{'Number of points return 3'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(23,1:2) = [{'Number of points return 4'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(24,1:2) = [{'Number of points return 5'}; ...
    {fread(fid,1,'uint32=>double')}];
lasHeaderInfo(25,1:2) = [{'X scale factor'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(26,1:2) = [{'Y scale factor'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(27,1:2) = [{'Z scale factor'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(28,1:2) = [{'X offset'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(29,1:2) = [{'Y offset'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(30,1:2) = [{'Z offset'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(31,1:2) = [{'Max X'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(32,1:2) = [{'Min X'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(33,1:2) = [{'Max Y'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(34,1:2) = [{'Min Y'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(35,1:2) = [{'Max Z'}; ...
    {fread(fid,1,'double=>double')}];
lasHeaderInfo(36,1:2) = [{'Min Z'}; ...
    {fread(fid,1,'double=>double')}];

% Display the header info to the screen in a nice format
%disp(['Header information from: ' lasFilename])
for i = 1:length(lasHeaderInfo)
    if isnumeric(lasHeaderInfo{i,2})
        screenOut = [lasHeaderInfo{i,1} ': ' num2str(lasHeaderInfo{i,2})];
    elseif isempty(lasHeaderInfo(i,2))
        screenOut = [lasHeaderInfo{i,1} ': 0'];
    else
        screenOut = [lasHeaderInfo{i,1} ': ' lasHeaderInfo{i,2}];
    end
    %disp(screenOut)
end

% Read and display the coordinate system from the variable length
% records, if available
filePos = lasHeaderInfo{14,2};  % Set file position based on header size
nVarRec = lasHeaderInfo{16,2};  % Number of variable length records
if nVarRec > 0
    if ~exist('projection_codes.mat')
        disp(['Cannot display coordinate system because projection_' ...
            'codes.mat file was not found.'])
        return
    else
        load('-mat', 'projection_codes')
    end
end
for i = 1:nVarRec
    fseek(fid, filePos, 'bof');
    rsvd = fread(fid,1,'uint16=>double');
    userId = sscanf(char(fread(fid,16,'uchar=>uchar')'),'%c');
    recId = fread(fid,1,'uint16=>double');
    lenRec = fread(fid,1,'uint16=>double');
    desc = sscanf(char(fread(fid,32,'uchar=>uchar')'),'%c');
    filePos = filePos + lenRec + i*54;
    % If the current variable length record contains the
    % GeoKeyDirectoryTag, then display the georeferencing info
    if strcmp(userId,'LASF_Projection') && recId == 34735
        nTags = floor(lenRec/2);
        % Jump to the correct position in the file
        newFilePos = filePos - lenRec;
        fseek(fid, newFilePos, 'bof');
        for j = 1:nTags
            tag = fread(fid,1,'uint16=>double');
            % Read through the projection codes and see if the tag
            % matches a CS Type; if so display it
            index = find(projectionCodes == tag);
            if ~isempty(index)
                disp(['Coordinate System: ' projectionNames{index}])
                lasHeaderInfo(37,1:2) = [{'Coordinate System'}; ...
                    {projectionNames{index}}];
            end
        end
    end  
end 

% Close the LAS file
fclose(fid);


