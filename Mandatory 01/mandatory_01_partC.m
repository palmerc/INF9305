%% Mandatory 1 - Part C
close all
clear

texture_directory = 'textures'
filename_pattern = 'mosaic%d';

mosaic_numbers = 1:2;
for mosaic_number = mosaic_numbers
    filename = sprintf(filename_pattern, mosaic_number);
    filepath = sprintf('%s/%s.png', texture_directory, filename);
    fprintf('Processing %s\n', filepath);
    tile = imread(filepath);
    
    gray_levels = 16;
    window_size = 15;
    tile_histeq = histeq(tile, gray_levels);
    tile_buckets = uint8(round(double(tile_histeq) * (gray_levels - 1) / double(max(tile_histeq(:)))));
    gray_limits = [min(tile_buckets(:)), max(tile_buckets(:))];
    
    for angle = [0, 45, 90]
        fprintf('Angle %d\n', angle);
        offset = [0 0];
        switch angle
            case 0
                offset = [0 2];
            case 45
                offset = [2 2];
            case 90
                offset = [2 0];
                
        end
        tic;
        [results, ZI] = SlidingGLCM(tile_buckets, ...
            'GrayLimits', gray_limits, ...
            'WindowSize', window_size, ...
            'Offset', offset, ...
            'NumLevels', gray_levels, ...
            'Symmetric', true);
        toc;
        
        output_filename = sprintf('partC-%s-angle%d.mat', filename, angle);
        save(output_filename, 'angle', 'results', 'window_size', 'gray_levels', 'offset', 'tile', 'ZI');
    end
end

%% Display Figures
close all
clear

filename_pattern = 'mosaic%d';
feature_names = {'inertia', 'homogeneity', 'cluster_shade'};

figure_value = 200;
mosaic_numbers = 1:2;
for mosaic_number = mosaic_numbers
    filename = sprintf(filename_pattern, mosaic_number);
    
    for angle = [0, 45, 90]
        filepath = sprintf('partC-%s-angle%d.mat', filename, angle);
        fprintf('Processing %s\n', filepath);
        load(filepath);
        
        figure(figure_value);
        subplot_value = 1;
        subplot(2,2,subplot_value); imshow(tile); title(filepath);
        
        for j = 1:length(feature_names)
            subplot_value = subplot_value + 1;
            feature_name = feature_names{j};
            
            title_text = strrep(sprintf('%s', feature_name), '_', '\_');
            feature = eval(sprintf('results.%s', feature_name));
            ax = subplot(2,2,subplot_value); imshow(feature, []); title(title_text); colormap(ax, 'jet'); colorbar;
            
            output_filename = sprintf('partC-%s-angle%d.png', filename, angle);
            print(output_filename, '-dpng');
        end
        figure_value = figure_value + 1;
    end
    
end

