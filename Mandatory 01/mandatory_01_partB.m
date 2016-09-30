%% Mandatory 1 - PART B
close all
clear

texture_directory = 'textures'
filename_pattern = 'mosaic%d-subimage-%s';
corners = {'top-left', 'top-right', 'bottom-left', 'bottom-right'};

gray_levels = 16;

figure_value = 100;
mosaic_numbers = 1:2;
for mosaic_number = mosaic_numbers
    for i = 1:length(corners)
        corner = corners{i};
        filename = sprintf(filename_pattern, mosaic_number, corner);
        filepath = sprintf('%s/%s.png', texture_directory, filename);
        output_filename = sprintf('partB-%s.png', filename);
        fprintf('Processing %s\n', filepath);
        tile = imread(filepath);

        gray_levels = 16;
        tile_histeq = histeq(tile, gray_levels);
        tile_buckets = uint8(round(double(tile_histeq) * (gray_levels - 1) / double(max(tile_histeq(:)))));
        gray_limits = [min(tile_buckets(:)), max(tile_buckets(:))];
    
        for angle = 1:3
            offset = [0 0];
            switch angle
                case 1
                    offset = [0 1];
                case 2
                    offset = [1 1];
                case 3
                    offset = [1 0];
    
            end
            tic;
            [results, ZI] = GLCM(tile_buckets, ...
                            'GrayLimits', gray_limits, ...
                            'Offset', offset, ...
                            'NumLevels', gray_levels, ...
                            'Symmetric', true);
            toc;
  
            switch angle
                case 1
                    glcm1 = results;
                case 2
                    glcm2 = results;
                case 3
                    glcm3 = results;
            end
           
        end
        
        figure(figure_value);
        subplot(221); imshow(tile_buckets, []); title(filename);
        glcm_max = max(max([glcm1(:) glcm2(:) glcm3(:)]));
        glcm1_title = sprintf('0\\circ, mean %0.f, std %0.f', glcm1_mean, glcm1_std);
        ax = subplot(222); imshow(glcm1, []); title(glcm1_title); caxis([0 glcm_max]); colormap(ax, 'jet'); colorbar;
        glcm2_title = sprintf('45\\circ, mean %0.f, std %0.f', glcm2_mean, glcm2_std);
        ay = subplot(223); imshow(glcm2, []); title(glcm2_title); caxis([0 glcm_max]); colormap(ay, 'jet'); colorbar;
        glcm3_title = sprintf('90\\circ, mean %0.f, std %0.f', glcm3_mean, glcm3_std);
        az = subplot(224); imshow(glcm3, []); title(glcm3_title); caxis([0 glcm_max]); colormap(az, 'jet'); colorbar;
        figure_value = figure_value + 1;
        print(output_filename, '-dpng');
    end
end
