%kNN function
%k: vector of k (# of closes neighbor)
%metric: distance metric ("euclidean","l1","linf")
%A: training points
%t: test point
%created by: Rowan Iskandar
%last modified: 22july2022
%use: coms4771 summerb2022 hw1, hw2
function [p] = classifier_generalkNN(X_train, Y_train, x_test, ks, metric)
    num_k = size(ks,1); %get total number of k neighbors vector (will iterate over this)
    p = zeros(num_k,1);
    if metric == "euclidean"
        % compute Euclidian distance between test point and train points
        r_zx = sum(bsxfun(@minus, X_train, x_test).^2, 2);
    elseif metric == "l1"
        r_zx = sum(abs(bsxfun(@minus,X_train,x_test)),2);
    elseif metric == "linf"
        r_zx = max(abs(bsxfun(@minus,X_train,x_test)),2);
    end
    % sort the distances in ascending order 
    [r_zx,idx] = sort(r_zx, 1, 'ascend');
    % keep only the K nearest neighbours
    for i=1:num_k
        k = ks(i);
        r_zx = r_zx(1:k); % keep the first kK’ distances
        idx = idx(1:k); % keep the first ’K’ indexes
        % majority vote 
        p(i) = mode(Y_train(idx));
    end
end
