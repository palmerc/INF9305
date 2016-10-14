%% Univariate Gaussian Classifier
% A suggested "solution" to classification exercise 1 the univariate
% Gaussian classifier. This week I will not provide the actual solution, it
% is hidden in the UnivariateGauss function. Since it is a point that you
% should implement this yourself. Anyway, I have provided some results so
% that you have something to compare your code with. If you have large
% differences from my result, please let me know and we'll check it out.

%% The feature images
clear all
close all
% We are provided with a Landsat satellite imagery containing 6 image
% "bands". We will use each of these bands as a feature image. Lets load
% them, I'm saving them in a so called cell array.
tm = cell(6, 1);
tm{1} = imread('tm1.png');
tm{2} = imread('tm2.png');
tm{3} = imread('tm3.png');
tm{4} = imread('tm4.png');
tm{5} = imread('tm5.png');
tm{6} = imread('tm6.png');
% We are also going to need these training and test masks. These masks
% indicate what pixels are known to belong to each class. Thus indicating
% what pixels we should use for training, and what pixels we can use to
% validate the result (test).
training_mask = imread('tm_train.png');
test_mask = imread('tm_test.png');

figure(100)
subplot(321); imshow(tm{1},[]);
colorbar
title('Landsat 1')
% print('Landsat1.png', '-dpng');

subplot(322); imshow(tm{2},[]);
colorbar
title('Landsat 2')
% print('Landsat2.png', '-dpng');

subplot(323); imshow(tm{3},[]);
colorbar
title('Landsat 3')
% print('Landsat3.png', '-dpng');

subplot(324); imshow(tm{4},[]);
colorbar
title('Landsat 4')
% print('Landsat4.png', '-dpng');

subplot(325); imshow(tm{5},[]);
colorbar
title('Landsat 5')
% print('Landsat5.png', '-dpng');

subplot(326); imshow(tm{6},[]);
colorbar
title('Landsat 6')
% print('Landsat6.png', '-dpng');

figure(101)
subplot(211); imagesc(training_mask)
colorbar
axis image
title('Training Mask')
% print('TrainingMask.png', '-dpng');

subplot(212); imagesc(test_mask);
colorbar
axis image
title('Test Mask')
% print('TestMask.png', '-dpng');

%% Classification
% We are going to use the univariate gaussian classifier, meaning that we
% are only using one feature at a time and classify the image with just
% one feature. The goal of this exercise is to evaluate each feature and
% figure out which seems to be the best.
close all

number_of_features = size(tm,1);     %Number of features
k = double(max(training_mask(:)));        %Number of classes
nbr_classified = sum(test_mask(:)>0);  %The total number of pixels in the test set
[N,M] = size(tm{1});                 %Size of image
minimum_value = -5;
maximum_value = 60;

for feature = 1:number_of_features
    
    %We are sending the images into this "black box" that you should
    %implement and we are getting the resulting class.
    feature_image = tm{feature};
    [class_labels, means, variances] = UnivariateGaussianTrainer(training_mask, feature_image);
    [class] = UnivariateGaussianClassifier(feature_image, class_labels, means, variances);
    colors = {'b', 'g', 'k', 'r'};

    figure(200 + feature); clf
    colormap jet
    cmap = colormap(100 + feature);
    for i = 1:numel(class_labels)
        class_label = class_labels(i);
        mu = means(i);
        sigma = sqrt(variances(i));
        x = linspace(minimum_value, maximum_value, 5 * (maximum_value - minimum_value + 1));
        y = GaussianProbabilityDensity(x, sigma, mu);

        color = colors{i};
        label_text = sprintf('Class %d', class_label);
        plot(x, y, 'Color', color, 'DisplayName', label_text); hold on;
    end
    hold off;
    filename = sprintf('Feature%dProbabilityDistribution.png', feature);
%     title_text = sprintf('Feature %d, Probability Distribution', feature);
%     title(title_text);
    xlabel('Gray-level');
    ylabel('Probability');
    legend('show');
    print(filename, '-dpng');
    
    %Make a labeled image to display how the pixels were classified
    figure(200 + feature);clf
    imagesc(class)
    colormap jet
    colorbar
    filename = sprintf('Feature%dClassificationResult.png', feature);
%     title_text = sprintf('Feature %d, Classification Result', feature);
%     title(title_text);
    print(filename, '-dpng');
    
    %Lest mask out the traning part of the image
    img_labeled_train = zeros(N,M);
    img_labeled_train(training_mask==1) = class(training_mask==1);
    img_labeled_train(training_mask==2) = class(training_mask==2);
    img_labeled_train(training_mask==3) = class(training_mask==3);
    img_labeled_train(training_mask==4) = class(training_mask==4);
    
    figure(300 + feature);
    imagesc(img_labeled_train);
    colormap jet
    colorbar
    filename = sprintf('Feature%dTrainingResult.png', feature);
%     title_text = sprintf('Feature %d, Training Result', feature);
%     title(title_text);
    print(filename, '-dpng');
    
    %And the test part of the image
    img_labeled = zeros(N,M);
    img_labeled(test_mask==1) = class(test_mask==1);
    img_labeled(test_mask==2) = class(test_mask==2);
    img_labeled(test_mask==3) = class(test_mask==3);
    img_labeled(test_mask==4) = class(test_mask==4);
    
    figure(400+feature);
    imagesc(img_labeled)
    colormap jet
    colorbar
    filename = sprintf('Feature%dTestResult.png', feature);
%     title_text = sprintf('Feature %d, Test Result', feature);
%     title(title_text);
    print(filename, '-dpng');
    
    %Calculate the correct classification
    fprintf('Feature %d: \n',feature);
    correct = zeros(1,k);
    percent = zeros(1,k);
    error = 0;
    %Lets go through each class and calculate
    for class_index = 1:k
        % The error: by summing up how many class labels does not
        % correspond with the class index.
        error = error + sum(class(test_mask==class_index)~=class_index);
        % The correct is thus how many does fit
        correct(class_index) = sum(class(test_mask==class_index)==class_index);
        percent = correct(class_index)/sum(sum(test_mask==class_index));
        fprintf('Class %d correct: %f \n',class_index,percent*100);
    end
    fprintf('Total error: %f\n',error/nbr_classified);
    fprintf('Correct classification for feature image %d is %f \n\n\n',...
        feature,sum(correct)*100/nbr_classified);
end