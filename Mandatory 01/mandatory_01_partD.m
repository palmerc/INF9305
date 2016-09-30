%% Mandatory 1 - Part D
close all
clear

%% Mosaic 1, Top-left
figure(300);
mosaic1 = imread('textures/mosaic1.png');
subplot(221); imshow(mosaic1, []); title('Original')

load('partD/partD-mosaic1-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic1 .* uint8(homogeneity < 0.40);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(<0.40) 90\circ');
 
load('partD/partD-mosaic1-s3-angle45.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia < 13);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(<13) 45\circ');
print('partD-mosaic1-segmentation-top-left.png', '-dpng');

%% Mosaic 1, Top-right
figure(301);
mosaic1 = imread('textures/mosaic1.png');
subplot(221); imshow(mosaic1, []); title('Original')

load('partD/partD-mosaic1-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic1 .* uint8(homogeneity > 0.40);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(>0.40) 90\circ');
 
cluster_shade = results.cluster_shade;
cluster_shade_thresholded = homogeneity_thresholded .* uint8(cluster_shade > -400);
subplot(223); imshow(cluster_shade_thresholded, []); title('Step 2: Cluster Shade(>-400) 90\circ');
print('partD-mosaic1-segmentation-top-right.png', '-dpng');

%% Mosaic 1, Bottom-left
figure(302);
mosaic1 = imread('textures/mosaic1.png');
subplot(221); imshow(mosaic1, []); title('Original')

load('partD/partD-mosaic1-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic1 .* uint8(homogeneity > 0.40);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(>0.40) 90\circ');
 
cluster_shade = results.cluster_shade;
cluster_shade_thresholded = homogeneity_thresholded .* uint8(cluster_shade < -400);
subplot(223); imshow(cluster_shade_thresholded, []); title('Step 2: Cluster Shade(<-400) 90\circ');
print('partD-mosaic1-segmentation-bottom-left.png', '-dpng');

%% Mosaic 1, Bottom-right
figure(303);
mosaic1 = imread('textures/mosaic1.png');
subplot(221); imshow(mosaic1, []); title('Original')

load('partD/partD-mosaic1-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic1 .* uint8(homogeneity < 0.40);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(<0.40) 90\circ');
 
load('partD/partD-mosaic1-s3-angle45.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia > 13);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(>13) 45\circ');
print('partD-mosaic1-segmentation-bottom-right.png', '-dpng');

%% Mosaic 2, Top-left
figure(400);
mosaic2 = imread('textures/mosaic2.png');
subplot(221); imshow(mosaic2, []); title('Original')

load('partD/partD-mosaic2-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic2 .* uint8(homogeneity < 0.36);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(<0.36) 90\circ');
 
load('partD/partD-mosaic2-s2-angle0.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia > 22);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(>22) 0\circ');
print('partD-mosaic2-segmentation-top-left.png', '-dpng');


%% Mosaic 2, Top-right
figure(401);
mosaic2 = imread('textures/mosaic2.png');
subplot(221); imshow(mosaic2, []); title('Original')

load('partD/partD-mosaic2-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic2 .* uint8(homogeneity > 0.36);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(>0.36) 90\circ');
 
load('partD/partD-mosaic2-s2-angle0.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia < 22);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(<22) 0\circ');
print('partD-mosaic2-segmentation-top-right.png', '-dpng');

%% Mosaic 2, Bottom-left
figure(402);
mosaic2 = imread('textures/mosaic2.png');
subplot(221); imshow(mosaic2, []); title('Original')

load('partD/partD-mosaic2-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic2 .* uint8(homogeneity > 0.36);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(>0.36) 90\circ');
 
load('partD/partD-mosaic2-s2-angle0.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia > 22);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(>22) 0\circ');
print('partD-mosaic2-segmentation-bottom-left.png', '-dpng');

%% Mosaic 2, Bottom-right
figure(403);
mosaic2 = imread('textures/mosaic2.png');
subplot(221); imshow(mosaic2, []); title('Original')

load('partD/partD-mosaic2-s1-angle90.mat');
homogeneity = results.homogeneity;
homogeneity_thresholded = mosaic2 .* uint8(homogeneity < 0.36);
subplot(222); imshow(homogeneity_thresholded, []); title('Step 1: Homogeneity(<0.36) 90\circ');
 
load('partD/partD-mosaic2-s2-angle0.mat');
intertia = results.inertia;
inertia_thresholded = homogeneity_thresholded .* uint8(intertia < 24);
subplot(223); imshow(inertia_thresholded, []); title('Step 2: Inertia(<24) 0\circ');
print('partD-mosaic2-segmentation-bottom-right.png', '-dpng');
