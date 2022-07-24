function error = classifier_naivebayes_err(X_train, Y_train, x_test, y_test, num_class, num_feature)
    k_miss=0;
    for i=1:size(x_test,1)
        k_pred=classifier_naivebayes(X_train, Y_train, x_test(i,:), num_class, num_feature);
        if k_pred==y_test(i)
            k_miss=k_miss;
        else
            k_miss=k_miss+1;
        end
    end
    error=k_miss/size(x_test,1);
end