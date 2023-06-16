%% Instructions for setting generic paths:
% 1. Set the input path to the directory where the daily precipitation data is located.
%    Example: inpth = '/path/to/input/data/daily_precipitation/';
inpth = '/path/to/input/data/daily_precipitation/';

% 2. Set the output path to the directory where the results will be saved.
%    Example: opth = '/path/to/output/results/';
opth = '/path/to/output/results/';

% Note: Replace '/path/to/input/data/daily_precipitation/' and '/path/to/output/results/' with the actual directory paths on your system.


function calculateExtremeDays(inpth, opth)
    % Inputs:
    %   - inpth: Input path to the directory containing the precipitation data
    %   - opth: Output path to save the calculated extreme days

    pth = fullfile(inpth, 'accumulation'); % accumulation folder stores daily data for each year, it's a 3D matrix for each year
    ls = dir(fullfile(pth, '*.mat'));

    % Calculate pr_nldas (99th percentile)
    pr_all = [];
    for j = 1:length(ls)
        prec_file = fullfile(pth, ls(j).name);
        prec = load(prec_file);
        pr_all = [pr_all; reshape(prec.pr, [], 1)];
    end
    pr_nldas = prctile(pr_all, 99);

    for h = 1:length(ls)
        prec_file = fullfile(pth, ls(h).name);
        [~, f2, ~] = fileparts(prec_file);

        prec = load(prec_file);
        pr = prec.pr;

        % Calculate temporal average precipitation
        mean_temporal = mean(pr, 3);

        % Calculate areal average precipitation
        mean_areal = mean(pr, [1, 2], 'omitnan');

        % Calculate extreme days
        isExtreme = mean_areal > pr_nldas;
        ex_days = ceil(sum(isExtreme));

        out_file = fullfile(opth, ['ex_days', f2, '.mat']);
        save(out_file, 'ex_days');
    end
end

