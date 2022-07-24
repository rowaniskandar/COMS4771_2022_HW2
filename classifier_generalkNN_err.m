function [error] = classifier_generalkNN_err(x_test,y_test,X_train, Y_train, k, metric)
    num_k = size(k,1);
    k_miss=zeros(num_k,1);
    error=zeros(num_k,1);
    k_pred=zeros(num_k,1);
    for i=1:size(x_test,1)
        for j=1:num_k
            k_pred(j)=classifier_generalkNN(k,X_train, Y_train, x_test(i,:),metric);
            %disp(k_pred);
            if k_pred(j)==y_test(i)
                k_miss(j)=k_miss(j);
            else
                k_miss(j)=k_miss(j)+1;
            end
        end
    end
    for j=1:num_k
        error(j)=k_miss(j)/size(x_test,1);
    end
    %disp(error);
end