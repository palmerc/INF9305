%% Exercise 9 - PCA

clear
close all

number_features = 6;
data_array = [];
for index = 1:number_features
    filename = sprintf('tm%d.png', index);
    image_data = imread(filename);
    
    data_array(index, :) = image_data(:); %#ok<SAGROW>
end
