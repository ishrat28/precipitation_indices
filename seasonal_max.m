function convertToSeasonalMax(inputDir, outputDir)

    inputDir = 'path for the files';
    outputDir = 'Directory to save';

    url = fullfile(inputDir, 'data');
    pth = fullfile(url, 'your_folder');
    ls = dir(fullfile(pth, '*.nc'));
    
    for j = 1:length(ls)
        prec = fullfile(url, 'your_folder', ls(j).name);
        pr_CESM2LE = double(ncread(prec, 'pr'));
        pr_time = double(ncread(prec, 'time'));
        pr_lat = double(ncread(prec, 'lat'));
        pr_lon = double(ncread(prec, 'lon'));
        thisImage3D = pr_CESM2LE(:, :, :, 1); 

        thisImage3D_sort = rot90(thisImage3D);
        lng_yr = thisImage3D_sort(:, :, 36501:59860); % The index depends on the 'time' variable and the range need for calculation

        spring_all = NaN(size(lng_yr,1),size(lng_yr,2), n); % n represents the no of years.
        summer_all = NaN(size(lng_yr,1),size(lng_yr,2), n);
        fall_all = NaN(size(lng_yr,1),size(lng_yr,2), n);
        winter_all = NaN(size(lng_yr,1),size(lng_yr,2), n);

        for r = 1:size(lng_yr,1)
            for c = 1:size(lng_yr,2)
                b = reshape(lng_yr(r, c, :), length(lng_yr), 1);

                % Generate year
                dt = 1951:2014; 
                dt = dt';
                tm = repelem(dt, 365);

                % Generate days
                dy = (1:365)';
                d = repmat(dy, n, 1); % n is no of years

                addpath(fullfile(inputDir, 'function', 'ddd2mmdd', 'ddd2mmdd new')); % ddd2mmdd is required to run the script
                [mm, dd] = ddd2mmdd(tm, d); %mm represents months, dd represents day

                % Now we have year, month, day of the month, and day of the year.
                % We will separate monthly values.
                T = table(tm, mm, dd, b);
                seasonal_max = varfun(@nanmax, T, 'GroupingVariables', {'tm', 'mm'}, 'InputVariables', {'b'});

                isSummer = ismember(seasonal_max.mm, [6, 7, 8]); %logical index for the months fall in the spring season
                isFall = ismember(seasonal_max.mm, [9, 10, 11]); % logical index for the months fall in the summer season
                isWinter = ismember(seasonal_max.mm, [12, 1, 2]); % logical index for the months fall in the fall season
                isSpring = ismember(seasonal_max.mm, [3, 4, 5]); % logical index for the months fall in the winter season

                pr_sp = seasonal_max.nanmax_b(isSpring); % check the header name of the seasonal_max table.
                sp = (max(reshape(pr_sp, 3, n)))'; % n represents the no of the years. Maximum every 3 elements which represent march, april and may
            
                pr_su = seasonal_max.nanmax_b(isSummer);
                su = (max(reshape(pr_su, 3, n)))'; 
           
                pr_fl = seasonal_max.nanmax_b(isFall);
                fl = (max(reshape(pr_fl, 3, n)))';

                pr_win = seasonal_max.nanmax_b(isWinter);
                win = (max(reshape(pr_win, 3, n)))';
             

                spring_all(r, c, :) = sp;
                summer_all(r, c, :) = su;
                fall_all(r, c, :) = fl;
                winter_all(r, c, :) = win;
            end
        end

        springFile = fullfile(outputDir, 'spring', ['spring_', num2str(j), '.mat']);
        summerFile = fullfile(outputDir, 'summer', ['summer_', num2str(j), '.mat']);
        fallFile = fullfile(outputDir, 'fall', ['fall_', num2str(j), '.mat']);
        winterFile = fullfile(outputDir,'winter', ['winter_', num2str(j), '.mat']);

        save(springFile,'spring_all'); 
        save(summerFile,'summer_all');
        save(fallFile,'fall_all');
        save(winterFile,'winter_all');
    end
end
