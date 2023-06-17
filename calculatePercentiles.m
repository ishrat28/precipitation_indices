input_dir = 'path to your daily precipitation stored as 3D matrix for individual year';
output_dir = 'directory to save percentile maps';
[percentile_map_99, percentile_map_95, percentile_all] = calculatePercentiles(input_dir, output_dir);

function [percentile_map_99, percentile_map_95, percentile_all] = calculatePercentiles(input_dir, output_dir)
    files = dir(fullfile(input_dir, '*.mat'));
    num_files = length(files);

    % Load data from each file
    data_all = [];
    for j = 1:num_files
        file_path = fullfile(input_dir, files(j).name);
        data = load(file_path);
        data_all = cat(3, data_all, data.pr); % check the data structure of matfiles, 'pr' stores daily precipitation.'cat' function concatenate datasets at each pixel
    end

    % Calculate percentiles
    [rows, cols, ~] = size(data_all);
    percentile_map_99 = NaN(rows, cols);
    percentile_map_95 = NaN(rows, cols);
    for row = 1:rows
        for col = 1:cols
            percentile_map_99(row, col) = prctile(data_all(row, col, :), 99);
            percentile_map_95(row, col) = prctile(data_all(row, col, :), 95);
        end
    end

    % Save percentile maps
    save(fullfile(output_dir, 'percentile_map_99.mat'), 'percentile_map_99');
    save(fullfile(output_dir, 'percentile_map_95.mat'), 'percentile_map_95');

    % Return the percentile maps and all the data
    percentile_all = data_all;
end

