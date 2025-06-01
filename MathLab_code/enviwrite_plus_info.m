function i=enviwrite_plus_info(image,fname,info)

% enviwrite          	- write ENVI image from MATLAB array (V. Guissard, Apr 29 2004)
%
% 				Write a MATLAB array to a file in ENVI standard format
%				from a [col x line x band] array
%
% SYNTAX
%
% image=freadenvi(fname)
% [image,p]=freadenvi(fname)
% [image,p,t]=freadenvi(fname)
%
% INPUT :
%
%
% image	c by l by b	name of the MATLAB variable containing the array to export
%				to an ENVI image, with c = cols, l the lines and b the bands
% fname	string	full pathname of the ENVI image to write.
%
% OUTPUT :
%
% i		integer	i = -1 if process fail
%
% NOTE : 			
%
%%%%%%%%%%%%%

% Parameters initialization
image=image';
im_size=size(image);
im_size(3)=size(image,3);
elements={'samples =' 'lines   =' 'bands   =' 'data type =' 'header offset =' 'byte order =' 'x start =' 'y start =' 'map info = '};

map_info = ['{UTM, 1.000, 1.000, ',num2str(info.map_info.mapx),', ', num2str(info.map_info.mapy),', ',num2str(info.map_info.dx),', ', num2str(info.map_info.dy),', 32, North, WGS-84, units=Meters}'];


d=[4 1 2 3 12 13];
% Check user input
if ~ischar(fname)
    error('fname should be a char string');
end

cl1=class(image);

% CHECK MODIFIED BY ADAMO FERRO
if strcmp(cl1,'double')
    img=single(image);
else
    img=image;
end
cl=class(img);

% ADDITIONAL CHECK BY ADAMO FERRO
% for writing unsigned char images
switch cl
    case 'uint8'
        t = d(2);
    case 'single'
        t = d(1);
    case 'int8'
        t = d(2);
    case 'int16'
        t = d(3);
    case 'int32'
        t = d(4);
    case 'uint16'
        t = d(6);
    case 'uint32'
        t = d(7);
    otherwise
        error('Data type not recognized');
end
wfid = fopen(fname,'w');
if wfid == -1
    i=-1;
end
disp([('Writing ENVI image ...')]);
fwrite(wfid,img,cl);
fclose(wfid);

% Write header file

fid = fopen(strcat(fname,'.hdr'),'w');
if fid == -1
    i=-1;
end
if (exist ('info.x_start','var'))==0
    info.x_start=0;
end
if (exist ('info.y_start','var'))==0
    info.y_start=0;
end

fprintf(fid,'%s \n','ENVI');
fprintf(fid,'%s \n','description = {');
fprintf(fid,'%s \n','Exported from MATLAB}');
fprintf(fid,'%s %i \n',elements{1,1},im_size(1));
fprintf(fid,'%s %i \n',elements{1,2},im_size(2));
fprintf(fid,'%s %i \n',elements{1,3},im_size(3));
fprintf(fid,'%s %i \n',elements{1,5},0);
fprintf(fid,'%s %i \n',elements{1,4},t);
fprintf(fid,'%s %i \n',elements{1,6},0);
fprintf(fid,'%s \n','interleave = bsq');
fprintf(fid,'%s %i \n',elements{1,7},info.x_start);
fprintf(fid,'%s %i \n',elements{1,8},info.y_start);
fprintf(fid,'%s %s \n',elements{1,9},map_info);
fclose(fid);