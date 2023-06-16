function PR_map_all = calculateMaxPRMap(inpth)
    pth = fullfile(inpth, 'accumulation');
    ls = dir(fullfile(pth, '*.mat'));
    PR_map_all = [];

    % calling yearly data stored in the accumulation folder
    for j = 1:length(ls)
        prec = fullfile(pth, ls(j).name);
        prec = load(prec);
        prec = prec.pr;

        pr_map = NaN(size(prec, 1), size(prec, 2));
        max_p_map = zeros(size(pr_map));

        for r = 1:size(prec, 1)
            for c = 1:size(prec, 2)
                b = reshape(prec(r, c, :), length(prec), 1);
                mov_pr = movsum(b, 5);
                max_pr = max(mov_pr);
                max_p_map(r, c) = max_pr;
            end
        end

        PR_map_all = cat(3, PR_map_all, max_p_map);
    end
end
