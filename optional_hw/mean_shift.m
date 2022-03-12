function [clus] = mean_shift(X)
    % init
    nums = size(X, 4);
    dim = size(X, 2);
    radix = 15000;
    clusters = [];
    centers = zeros(dim,dim,dim,nums);
    end_threshold = 100;
    close_threshold = 10000;
    belong_to = zeros(nums,1);
    
    % deal each picture
    for i = 1:nums
        if belong_to(i)>0
            continue
        end
        converged = false;
        center = X(:,:,:,i);
        while ~converged
            dis = zeros(nums,1);
            vec = zeros(dim, 1);
            % caculate each distance of other picture
            for j = 1:nums
                flat_x = reshape(X(:,:,:,j),[],1).';
                flat_c = reshape(center,[],1).';
                dis(j) = norm(flat_x-flat_c);
                if dis(j) < radix
                    % update shift vector
                    vec = center - X(:,:,:,j);
                    % update cluster index
                    belong_to(j) = i;
                end
            end
            % check if converged
           center = center + vec;
           flat_v = reshape(vec,[],1).';
            if norm(flat_v) < end_threshold
                converged = true;
            end
            centers(:,:,:,i)=center(:,:,:);
        end
    end
    
    %merge the close cluster
    for i=1:nums
        flat_center_i = reshape(centers(:,:,:,belong_to(i)),[],1).';
        for j=i+1:nums
            if belong_to(i)==belong_to(j)
                continue
            end
            bt = belong_to(j);
            flat_center_j = reshape(centers(:,:,:,bt),[],1).';
            if norm(flat_center_i-flat_center_j)<close_threshold
                belong_to(j)=i;
            end
        end
    end
    
    clus = belong_to;
end