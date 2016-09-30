%% Setup
clear

source_filename = 'mosaic1-rocky';
gray_levels = 16;
window_size = 31;
offset = [4 0];
matfile = sprintf('%s-%dgray-%dws.mat', source_filename, gray_levels, window_size);

%% Histogram
close all

figure(1)
image = imread(strcat(source_filename, '.png'));
subplot(211), imshow(image, []), title('Original')

image_he = histeq(image, gray_levels);
image_hen = uint8(round(double(image_he) * (gray_levels - 1) / double(max(image_he(:)))));
subplot(212), imshow(image_hen, [0 gray_levels - 1]), title('Histogram equalization - normalized');

figure(2);
h = imhist(image);
subplot(211), plot((0:255), h/sum(h), 'linewidth', 2), xlim([0 15]), title('Normalized histogram of original image');

h = imhist(image_hen);
subplot(212), plot((0:255), h/sum(h), 'linewidth', 2), xlim([0 15]), title('Normalized histogram of image after histeq');

disp('Original image consists of these values:');
disp(unique(image)');
disp('Image after histeq and normalization has these values:');
disp(unique(image_hen)');

%% Task 1
% First, try to implement your own GLCM function that takes as input an 
% image window and number of image greyscales and outputs a co-occurence 
% matrix. Derive variance, contrast and entropy from the GLCM of a sliding
% window at a suitable size.
image_hen = imread(strcat(source_filename, '.png'));

gray_limits = [min(image_hen(:)), max(image_hen(:))];

% Beware sliding window versions of these calculations take FOR-EV-ER
% The MatLab version of sliding window handling 'nlfilter' is here for
% reference.
% glcmfunc = @(x)glcm_contrast(x);
% gray_limits = [min(zebra(:)), max(zebra(:))];
% tic;
% B = nlfilter(zebra, [window_size, window_size], glcmfunc);
% toc;
tic;
[results, ZI] = SlidingGLCM(image_hen, ...
    'WindowSize', window_size, ...
    'GrayLimits', gray_limits, ...
    'Offset', offset, ...
    'NumLevels', gray_levels, ...
    'Symmetric', true);
toc;

save(matfile, 'results', 'window_size', 'gray_levels');

%% Task B
close all

figure_count = 1;
corners = {'top-left', 'top-right', 'bottom-right', 'bottom-left'};
for mosaic = 1:2
    for i = 1:length(corners)
        corner = corners{i};

        filename = sprintf('mosaic%d-subimage-%s.png', mosaic, corner);
        fprintf('%s', filename);
        I = imread(filename);
        tic;
        [results] = ExtendedGLCM(I, ...
            'GrayLimits', gray_limits, ...
            'Offset', offset, ...
            'NumLevels', gray_levels, ...
            'Symmetric', true);
        toc;

        output_texture = sprintf('mosaic%d-texture-%s.png', mosaic, corner);

        figure(figure_count);
        imagesc(I); colormap gray;
        print(output_texture, '-dpng');
        
        output_glcm = sprintf('mosaic%d-glcm-%s.png', mosaic, corner);

        figure(figure_count + 1);
        imagesc(results.P); colormap jet; colorbar;
        print(output_glcm, '-dpng');

        figure_count = figure_count + 2;
    end
end


%% Task C
% Computing GLCM feature images in local windows

close all
load(matfile);

homogeneity = mat2gray(results.homogeneity);
output_filename = sprintf('%s-homogeneity.png', source_filename);
imwrite(homogeneity, output_filename);

inertia = mat2gray(results.inertia);
output_filename = sprintf('%s-inertia.png', source_filename);
imwrite(inertia, output_filename);

cluster_shade = mat2gray(results.cluster_shade);
output_filename = sprintf('%s-cluster_shade.png', source_filename);
imwrite(cluster_shade, output_filename);


%% Task D
% Try to use a simple tresholding of these features to mask out the zebras 
% in the images.
close all

load(matfile);
image = imread(strcat(source_filename, '.png'));

variance = results.variance;
figure(1)
subplot(211), imshow(variance, []), title('GLCM Variance');
variance_thresholded = image .* uint8(variance > (max(variance(:)) * 0.3));
subplot(212), imshow(variance_thresholded, []), title('GLCM Variance thresholded');

contrast = results.contrast;
figure(2)
subplot(211), imshow(contrast, []), title('GLCM Contrast');
contrast_thresholded = image .* uint8(contrast > (max(contrast(:)) * 0.2));
subplot(212), imshow(contrast_thresholded, []), title('GLCM Contrast thresholded');

% gray_levels = 8;
% window_size = 15;
% offset = [2 0];
% gray_limits = [min(i(:)), max(contrast_thresholded(:))];
% [results2, ZI] = SlidingGLCM(contrast_thresholded, ...
%     'WindowSize', window_size, ...
%     'GrayLimits', gray_limits, ...
%     'Offset', offset, ...
%     'NumLevels', gray_levels, ...
%     'Symmetric', true);
% 
% figure(4)
% imshow(results2.variance, []), title('GLCM Variance double down');
% contrast_variance2 = image .* uint8(results2.variance > (max(results2.variance(:)) * 0.2));
% imshow(contrast_variance2, []), title('GLCM Variance double down thresholded');

cluster_shade = results.cluster_shade;
cluster_shade_thresholded = image .* uint8(cluster_shade < max(cluster_shade(:) * 0.5));

figure(3)
subplot(211), imshow(cluster_shade, []), title('GLCM Cluster Shade');
subplot(212), imshow(cluster_shade_thresholded, []), title('GLCM Cluster Shade tresholded');

homogeneity = results.homogeneity;
homogeneity_thresholded = image .* uint8(homogeneity > (max(homogeneity(:)) * 0.36));

figure(4)
subplot(211), imshow(homogeneity, []), title('GLCM Homogeneity');
subplot(212), imshow(homogeneity_thresholded, []), title('GLCM Homogeneity thresholded');

inertia = results.inertia;
inertia_thresholded = image .* uint8(inertia < (max(inertia(:)) * 0.40));

figure(5)
subplot(211), imshow(inertia, []), title('GLCM Inertia');
subplot(212), imshow(inertia_thresholded, []), title('GLCM Inertia thresholded');

entropy = results.entropy;
entropy_thresholded = image .* uint8(entropy < (max(entropy(:)) * 0.95));

figure(6)
subplot(211), imshow(entropy, []), title('GLCM Entropy');
subplot(212), imshow(entropy_thresholded, []), title('GLCM Entropy thresholded');

