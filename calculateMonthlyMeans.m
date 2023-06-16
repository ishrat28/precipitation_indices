%% Instructions for setting generic paths:
% 1. Set the input path to the directory where the daily precipitation data is located.
%    Example: inpth = '/path/to/input/data/daily_precipitation/';
inpth = '/path/to/input/data/daily_precipitation/';

% 2. Set the output path to the directory where the results will be saved.
%    Example: opth = '/path/to/output/results/';
opth = '/path/to/output/results/';

% Note: Replace '/path/to/input/data/daily_precipitation/' and '/path/to/output/results/' with the actual directory paths on your system.

function calculateMonthlyMeans(inpth opth)
    
    pth = fullfile(inpth, 'accumulation\'); %'accumulation folder stores the daily precipitation 
    ls = dir(fullfile(pth, '*.mat'));

    for j = 1:length(ls)
        prm = load(fullfile(pth, ls(j).name));
        prm = prm.pr;
        f2 = extractBetween(ls(j).name, 10, strlength(ls(j).name)-4); % depends on the string length
 

        c = cumsum(eomday(d, 1:12));
        for k = 1:12
            if (j > sum(c(1:k-1))) && (j <= sum(c(1:k)))
                monthlyMeans = nanmean(prm(:,:,sum(c(1:k-1))+1:sum(c(1:k))), 3);
                save(fullfile(opth, [f2 '_M' num2str(k) '.mat']), 'monthlyMeans');
            end
        end
    end
end

