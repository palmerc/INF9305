%% Hough lines - Naive version

clear 
close all

%Reading image
original_image=imread('corridor.png');
grayscale_image=double(rgb2gray(original_image));

% Lets filter the original image with a Sobel filter to find the Sobel
% magnitude
horizontal_sobel_filter=fspecial('sobel');
vertical_sobel_filter=horizontal_sobel_filter';
horizontal_filtered_image=imfilter(grayscale_image,horizontal_sobel_filter);
vertical_filtered_image=imfilter(grayscale_image,vertical_sobel_filter);
igs=abs(horizontal_filtered_image)+abs(vertical_filtered_image);

%Lets treshold the Sobel image
%And lets skip the border
thresholded_image=igs(5:end-5,5:end-5)>170;

%Using the tresholded Sobel magnitude of the corridor from earlier
[rows, cols] = size(thresholded_image);

theta_maximum = 90;
rho_maximum = floor(sqrt(rows^2 + cols^2)) - 1;
theta_range = -theta_maximum:theta_maximum - 1;
rho_range = -rho_maximum:rho_maximum;

rho_theta_matrix = zeros(length(rho_range), length(theta_range));

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
                rho_theta_matrix(rho_index, theta_index) = rho_theta_matrix(rho_index, theta_index) + 1;
            end
        end
    end
end

figure(100)
ax1 = subplot(221); imshow(thresholded_image); title('Thresholded Sobel Image')

ax2 = subplot(222); 
imagesc(theta_range,rho_range,rho_theta_matrix);
xlabel('\theta');
ylabel('\rho');
colormap(ax2, 'jet'); colorbar;
title('Rho-Theta Matrix');

close(wb);

lines_matrix = rho_theta_matrix > 150;
subplot(224); imshow(grayscale_image, []), title('Naive Hough - lines');
hold on
 
[rows, cols] = find(lines_matrix>0);
for i = 1:numel(rows)
    rho = rho_range(rows(i));
    theta = theta_range(cols(i));
    x = 1:size(grayscale_image, 2);
    y = round((rho - x * cosd(theta)) / sind(theta));
    plot(x, y, 'r-');
end

%% Task 2a - Randomized Line case
 
clear 
close all
 
RGB = imread('corridor.png');
gray = rgb2gray(RGB);
 
figure(200);
subplot(221), imshow(RGB), title('Original');
 
horizontal_sobel_filter = fspecial('sobel');
vertical_sobel_filter = horizontal_sobel_filter';
horizontal_filtered_image = imfilter(gray, horizontal_sobel_filter);
vertical_filtered_image = imfilter(gray, vertical_sobel_filter);
sobel_thresholded = abs(horizontal_filtered_image) + abs(vertical_filtered_image);
sobel_thresholded = sobel_thresholded > 170;
subplot(222), imshow(sobel_thresholded, []), title('Sobel thresholded');
 
tic;
line_threshold = 20;
max_iterations = 1000;
[lines_matrix, rho_theta_matrix, theta_max, theta_range, rho_max, rho_range] = RandomHough(sobel_thresholded, line_threshold, max_iterations);
toc;

ax1 = subplot(223); 
imagesc(theta_range, rho_range,rho_theta_matrix);
xlabel('\theta');
ylabel('\rho');
colormap(ax1, 'jet'); 
title('Rho-Theta Matrix');

subplot(224); imshow(sobel_thresholded, []), title('Randomized Hough - lines');
hold on
 
[rho_index, col_index] = find(lines_matrix>0);
for i = 1:numel(rho_index)
    rho = rho_range(rho_index(i));
    theta = theta_range(col_index(i));
    x = 1:size(sobel_thresholded, 2);
    y = round((rho - x * cosd(theta)) / sind(theta));
    plot(x, y, 'r-');
end

%% Hough Circles

clear
close all
 
RGB = imread('coins2.jpg');
gray = double(rgb2gray(RGB));
 
figure(1);
subplot(211), imshow(RGB), title('Original');
 
horizontal_sobel_filter = fspecial('sobel');
vertical_sobel_filter = horizontal_sobel_filter';
horizontal_filtered_image = imfilter(gray, horizontal_sobel_filter);
vertical_filtered_image = imfilter(gray, vertical_sobel_filter);
sobel_image = abs(horizontal_filtered_image) + abs(vertical_filtered_image);
subplot(212), imshow(sobel_image, []), title('Sobel');
 
sobel_thresholded = sobel_image(5:end - 5, 5:end - 5) > 170;
circle_threshold = 4;
maximum_iterations = 200000;
[MI, xy, R] = RandomHoughCircles(sobel_thresholded, circle_threshold, maximum_iterations, [15 25]);
 
figure(2);
imshow(sobel_thresholded, []), title('Sobel thresholded');
hold on
points = 100;
t = linspace(0, 2 * pi, points);
for i = 1:size(xy, 2)
    x = xy(1, i);
    y = xy(2, i);
    r = R(i);
    x_unit = r * cos(t) + x;
    y_unit = r * sin(t) + y;
    plot(y_unit, x_unit, 'ro');
end
hold off
axis equal
 
figure(3);
imshow(MI, []), title('Erased points');

