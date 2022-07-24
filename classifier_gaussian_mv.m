%Multivariate Guassian classifier function
%created by: Rowan Iskandar
%last modified: 22july2022
%use: coms4771 summerb2022 hw1, hw2

function class = classifier_gaussian_mv(X_train, Y_train, x_test, num_class, num_feature, eps)
    disp(x_test);
    train = cat(2,X_train,Y_train);
    %Prior probability of class;
    prior = zeros(1,num_class);
    for k=1:num_class
        prior(k)=sum(Y_train(:)==k-1)/length(Y_train);
    end
    %MLE estimators of conditional class probabilities 
    mean_hat = zeros(num_feature,num_class);
    var_hat = zeros(num_feature,num_feature,num_class);
    for k=1:num_class
        mean_hat(:,k) = mean(train(Y_train==k-1,1:num_feature)); 
        var_hat(:,:,k) = cov(X_train(Y_train==k-1, 1:num_feature), 1) + eps*eye(num_feature);
    end
    score = zeros(num_class);
    for k=1:num_class
        score(k)= mvnpdf(x_test.',mean_hat(:,k),var_hat(:,:,k))*prior(k);
    end
    score_optim = max(score);
    class = find(score==score_optim)-1;
end