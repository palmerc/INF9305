%% Exercise 02 - GLCM

% Task 1
% First, try to implement your own GLCM function that takes as input an 
% image window and number of image greyscales and outputs a co-occurence
% matrix. Derive variance, contrast and entropy from the GLCM of a sliding
% window at a suitable size.

%% Perform Sliding GLCM Processing
clear
close all

zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('images/zebra_%d.tif', zebra_number);
    fprintf('Processing %s\n', filename);
    zebra = imread(filename);

    window_size = 15;
    gray_levels = 8;
    offset = [1 0];

    zebra_histeq_gl = histeq(zebra, gray_levels);
    zebra_buckets = uint8(round(double(zebra_histeq_gl) * (gray_levels - 1) / double(max(zebra_histeq_gl(:)))));
    gray_limits = [min(zebra_buckets(:)), max(zebra_buckets(:))];
    
    tic;
    [results, ZI] = SlidingGLCM(zebra_buckets, ...
        'WindowSize', window_size, ...
        'GrayLimits', gray_limits, ...
        'Offset', offset, ...
        'NumLevels', gray_levels, ...
        'Symmetric', true);
    toc;

    output_file = sprintf('zebra_%d.mat', zebra_number);
    save(output_file, 'results', 'window_size', 'gray_levels', 'offset', 'zebra', 'ZI');
end

%% Display Images and Requantization
clear
close all

zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('zebra_%d.mat', zebra_number);
    load(filename);
    
    zebra_histeq_gl = histeq(zebra, gray_levels);
    zebra_buckets = uint8(round(double(zebra_histeq_gl) * (gray_levels - 1) / double(max(zebra_histeq_gl(:)))));
    zebra_imhist = double(imhist(zebra)).';
    zebra_imhist_buckets = double(imhist(zebra_buckets)).';
    
    % Display the histogram and image before and after requantization
    figure(100 + zebra_number);
    subplot(221); imshow(zebra, []);
    title_text = sprintf('Original - %s', strrep(filename, '_', '\_'));
    title(title_text);
    subplot(222); plot(0:255, zebra_imhist/sum(zebra_imhist), 'linewidth', 2);
    title('Original Histogram');
    xlim([0 255]);
    subplot(223); imshow(zebra_buckets, [0 gray_levels - 1]);
    title('Requantized');
    subplot(224); plot(0:255, zebra_imhist_buckets/sum(zebra_imhist_buckets), 'linewidth', 2);
    title('Requantized Histogram');
    xlim([0 gray_levels-1]);
end

%% Task 1 Result = Display GLCM Weighting Functions
clear
close all

zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('zebra_%d.mat', zebra_number);
    load(filename);
    
    figure(200 + zebra_number);
    subplot(221); imshow(zebra, []);
    title_text = sprintf('Original - %s', strrep(filename, '_', '\_'));
    title(title_text);
    subplot(222); imshow(results.variance, []);
    title('Variance');
    subplot(223); imshow(results.contrast, []);
    title('Contrast');
    subplot(224); imshow(results.entropy, []);
    title('Entropy');
end

%% Task 2 Result - Simple Thresholding of Features
clear
close all

zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('zebra_%d.mat', zebra_number);
    load(filename);
    
    figure(300 + zebra_number);
    subplot(221); imshow(zebra, []);
    title_text = sprintf('Original - %s', strrep(filename, '_', '\_'));
    title(title_text);
    variance = results.variance;
    variance_thresholded = zebra .* uint8(variance > (max(variance(:)) * 0.5));
    subplot(222); imshow(variance_thresholded, []);
    title('Variance');
    contrast = results.contrast;
    contrast_thresholded = zebra .* uint8(contrast > (max(contrast(:)) * 0.2));
    subplot(223); imshow(contrast_thresholded, []);
    title('Contrast');
    entropy = results.entropy;
    entropy_thresholded = zebra .* uint8(entropy > (max(entropy(:)) * 0.6));
    subplot(224); imshow(entropy_thresholded, []);
    title('Entropy');
end


%% Task 3 - Matlab 1. Order Texture Measures
% Then compare your result with the first order texture measures: variance 
% and entropy by using the Matlab functions: stdfilt and entropyfilt.
% Remember that the variance is the square of the standard deviation

clear
close all

zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('zebra_%d.mat', zebra_number);
    load(filename);
    
    figure(400 + zebra_number);

    window_size = 31;
    std_var = stdfilt(zebra, ones(window_size)).^2;
    subplot(321), imshow(std_var, []), title('stdfilt - Variance');
    subplot(322), imshow(zebra .* uint8(std_var > (max(std_var(:)) * 0.25)), [])
    title('stdfilt - Thresholded Variance');

    % See page 532 in Gonzales and woods for a definition on entropy ("average
    % information")
    std_ent = entropyfilt(zebra, ones(window_size));
    subplot(323), imshow(std_ent, []), title('entropyfilt - Entropy');
    subplot(324), imshow(zebra .* uint8(std_ent > (max(std_ent(:)) * 0.6)), [])
    title('entropyfilt - Thresholded Entropy');

    % Variance on image after histeq
    gray_levels = 8;
    zebra_he = histeq(zebra, gray_levels);
    zebra_hen = uint8(round(double(zebra_he) * (gray_levels - 1) / double(max(zebra_he(:)))));
    std_var_of_img_std = stdfilt(zebra_hen, ones(window_size)).^2;
    subplot(325), imshow(results.variance, []), title('GLCM Variance');
    subplot(326), imshow(std_var_of_img_std, []), title('histeq/stdfilt - Variance');
end

%% Task 4 - Law's Energy
% If you have time, try to use Laws texture masks to analyze the image with
% a suitable mask or two. Remember to average energy over windows. Laws 
% masks can be built and applied with conv2 function in Matlab.

clear
close all

% "Building blocks" for Laws 3x3 texture masks
L3 = [ 1  2  1];
E3 = [-1  0  1];
S3 = [-1  2 -1];

% "Building blocks" for Laws 5x5 texture masks are made from the X3 masks
L5 = conv2(L3, L3, 'full'); % Level
E5 = conv2(L3, E3, 'full'); % Edge
S5 = conv2(L3, S3, 'full'); % Spot
W5 = conv2(E3, S3, 'full'); % Wave
R5 = conv2(S3, S3, 'full'); % Ripple

% We are deciding to use this 5x5 mask
% mask = conv2(W5', W5, 'full'); mask_name = 'W5W5 Mask';
% mask = conv2(E5', E5, 'full'); mask_name = 'E5E5 Mask';
mask = conv2(L5', L5, 'full'); mask_name = 'L5L5 Mask';
% mask = conv2(S5', S5, 'full'); mask_name = 'S5S5 Mask';
% mask = conv2(R5', R5, 'full'); mask_name = 'R5R5 Mask';


zebra_files = 1:6;
for zebra_number = zebra_files
    filename = sprintf('images/zebra_%d.tif', zebra_number);
    zebra = imread(filename);

    figure(500 + zebra_number);
    
    % Filter the image with the 5x5 mask
    laws_energy = imfilter(double(zebra), mask, 'symmetric', 'conv');
    title_text = sprintf('%s, Laws Energy', mask_name);
    subplot(321), imshow(laws_energy, []), title(title_text);

    % Using a mean filter on laws energy
    mean_laws = imfilter(abs(laws_energy), ones(35), 'symmetric');
    thresholded_mean = zebra .* uint8(mean_laws > (max(mean_laws(:)) * 0.3));

    subplot(323), imshow(mean_laws, []), title('Mean, Laws Energy');
    subplot(324), imshow(thresholded_mean, []), title('Thresholded');

    % Finding the standard deviation of Laws energy
    std_dev_laws  = stdfilt(laws_energy, ones(35));
    thresholded_std_dev = zebra .* uint8(std_dev_laws > (max(std_dev_laws(:)) * 0.3));

    subplot(325), imshow(std_dev_laws, []), title('Standard Deviation, Laws Energy');
    subplot(326), imshow(thresholded_std_dev, []), title('Thresholded');
end
