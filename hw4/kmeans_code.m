function [clusters, centers] = kmeans_code(X, k, iters)
    X = single(X);
    len = size(X, 1);
    dim = size(X, 2);
    points = rand(k, dim);
    points = single(points);

    % 1. sample k number
    samples = randsample(len,k);

    % 2. ensure centers are existed points
    for i = 1:k
        points(i, :) = X(samples(i), :);
    end

    % 3. iterate
    for iter = 1:iters
        % vector with label
        XLabel = [X ones(len, 1)];
        % 4. scan each vector
        for i = 1:size(XLabel, 1)
            minDist = norm(XLabel(i, 1:dim).'- points(1, :).');
            minJ = 1;
            for j = 1:size(points, 1)
                dist = norm(XLabel(i, 1:dim).' - points(j, :).');
                if dist <= minDist
                    minJ = j;
                    minDist = dist;
                end
            end
            XLabel(i, dim + 1) = minJ;
        end

        % 5. group by point index
        for i = 1:k
            set(:, :, i) = {XLabel(XLabel(:, dim + 1) == i, 1:dim)};
        end

        % 6. renew points
        for i = 1:k
            avg = mean(set{i}, 1);
            points(i, :) = avg(1:dim);
        end
    end

    % 7. return centers and clusters
    clusters = set;
    centers = points;
end
