%% Task 2a - Randomized Line case
 
clear 
close all
 
RGB = imread('corridor.png');
gray = rgb2gray(RGB);
 
figure(100);
subplot(221), imshow(RGB), title('Original');
 
h1 = fspecial('sobel');
h2 = h1';
igh = imfilter(gray, h1);
igv = imfilter(gray, h2);
sobel_thresholded = abs(igh) + abs(igv);
subplot(222), imshow(sobel_thresholded, []), title('Sobel thresholded');
 
sobel_thresholded = sobel_thresholded > 170;
 
tic;
line_threshold = 20;
max_iterations = 1000;
[lines_matrix, rho_theta_matrix, theta_max, theta_range, rho_max, rho_range] = RandomHough(sobel_thresholded, line_threshold, max_iterations);
toc;

ax1 = subplot(223); 
imagesc(theta_range,rho_range,rho_theta_matrix);
xlabel('\theta');
ylabel('\rho');
colormap(ax1, 'jet'); 
title('Rho-Theta Matrix');

subplot(224); imshow(sobel_thresholded, []), title('Randomized Hough - lines');
hold on
 
[rows, cols] = find(lines_matrix>0);
for i = 1:numel(rows)
    rho = rho_range(rows(i));
    theta = theta_range(cols(i));
    x = 1:size(sobel_thresholded, 2);
    y = round((rho - x * cosd(theta)) / sind(theta));
    plot(x, y, 'r-');
end

%% Naive version

clear 
close all

%Reading image
original_image=imread('corridor.png');
grayscale_image=double(rgb2gray(original_image));

% Lets filter the original image with a Sobel filter to find the Sobel
% magnitude
h1=fspecial('sobel');
h2=h1';
igh=imfilter(grayscale_image,h1);
igv=imfilter(grayscale_image,h2);
igs=abs(igh)+abs(igv);

%Lets treshold the Sobel image
%And lets skip the border
thresholded_image=igs(5:end-5,5:end-5)>170;

%Using the tresholded Sobel magnitude of the corridor from earlier
[rows, cols] = size(thresholded_image);

theta_maximum = 90;
rho_maximum = floor(sqrt(rows^2 + cols^2)) - 1;
theta_range = -theta_maximum:theta_maximum - 1;
rho_range = -rho_maximum:rho_maximum;

lines_matrix = zeros(length(rho_range), length(theta_range));

wb = waitbar(0, 'Naive Hough Transform');

for row = 1:rows
    waitbar(row/rows, wb);
    for col = 1:cols
        if thresholded_image(row, col) > 0
            x = col - 1;
            y = row - 1;
            for theta = theta_range
                rho_ = round((x * cosd(theta)) + (y * sind(theta)));
                rho_index = rho_ + rho_maximum + 1;
                theta_index = theta + theta_maximum + 1;
                lines_matrix(rho_index, theta_index) = lines_matrix(rho_index, theta_index) + 1;
            end
        end
    end
end

figure(200)
ax1 = subplot(211); imshow(thresholded_image); title('Thresholded Sobel Image')

ax2 = subplot(212); 
imagesc(theta_range,rho_range,lines_matrix);
xlabel('\theta');
ylabel('\rho');
colormap(ax2, 'jet'); 
title('Rho-Theta Matrix');

close(wb);