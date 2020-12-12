clear;clc;

addpath('tools')
%=======================================================================
% Load LiDAR Data
%=======================================================================

%% file = dir([InputPath '*.las']);
% file(1).name

raster_param = 0.3;
OutputPath = 'Temp/';
InputPath = [cd('.') '\Dataset_50_trees\ab\'];
NameFile = '000415_elli_0039';
%infilename = [InputPath NameFile '.las'] ; 
P = read_LAS([InputPath NameFile '.las']);

%P = imnoise(P,'gaussian',0,0.5);
%P = P + 5*randn(size(P));
%=======================================================================
% Plot Data
%=======================================================================

hFig=figure(1);
set(hFig, 'Position', [250 250 700 700])
sel_p = randperm(length(P));
n_p = min(length(P),10000);
scatter3(P(sel_p(1:n_p),1),P(sel_p(1:n_p),2),P(sel_p(1:n_p),3),30,P(sel_p(1:n_p),3),'filled')
view([-13 1])

%=======================================================================
% Remove Terrain
%=======================================================================

system(['lasground -i ' InputPath NameFile '.las -o '  NameFile 'Ground.las -verbose -step 1  -spike 0.5  -offset 0.1']);
system(['lasheight -i *.las -replace_z -o ' NameFile  'Height.las' ]);

Terrain = read_LAS([ NameFile 'Ground.las']);

CHM_Tree = read_LAS([  NameFile 'Height.las']);
  
prob = CheckGround(OutputPath,Terrain,P (:,1:7),CHM_Tree,NameFile);
delete([NameFile '*.las'])
delete([NameFile '*.txt'])

%=======================================================================
% Plot Result
%=======================================================================

P = read_LAS([OutputPath NameFile '.las']);
hFig=figure(10);
set(hFig, 'Position', [250 250 700 700])
sel_p = randperm(length(P));
n_p = min(length(P),10000);
scatter3(P(sel_p(1:n_p),1),P(sel_p(1:n_p),2),P(sel_p(1:n_p),3),30,P(sel_p(1:n_p),3),'filled')
view([-13 1])

%=======================================================================
% Rastering
%=======================================================================

system(['las2envi -d ' OutputPath NameFile '.las -r ' num2str(raster_param) ' -i 0.30 -p M']);
movefile(['max_image_r'  num2str(raster_param) '_i0'],['Images/' NameFile])
movefile(['max_image_r'  num2str(raster_param) '_i0.hdr'],['Images/' NameFile '.hdr'])

%=======================================================================
% Load Image
%=======================================================================
info = envihdrread(['TestImg/' NameFile '.hdr']);
img = envidataread(['TestImg/' NameFile ],info);
img(img~=0)= img(img~=0) - min(img(img~=0)); %-1590;

figure(30), imagesc(img);colorbar

