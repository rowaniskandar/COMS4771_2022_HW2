%naive bayes function
%created by: Rowan Iskandar
%last modified: 22july2022
%use: coms4771 summerb2022 hw1, hw2
function class = classifier_naivebayes(X_train, Y_train, x_test, num_class, num_features)
        train = cat(2,X_train,Y_train);
        num_data = size(X_train,1);

        prior = zeros(1,num_class);
        for k=1:num_class
            prior(k)=sum(Y_train(:)==k-1)/length(Y_train);
        end
        %multinomial estimators of conditional class probabilities (P(X,Y)

        mean_agecat = (1/num_data)*[sum(X_train(:,2)==1),sum(X_train(:,2)==2),...
            sum(X_train(:,2)==3),sum(X_train(:,2)==4)];
        
        mean_juvfelcat = (1/num_data)*[sum(X_train(:,4)==1),sum(X_train(:,4)==2),...
            sum(X_train(:,4)==3)];
        
        mean_juvmisdcat = (1/num_data)*[sum(X_train(:,5)==1),sum(X_train(:,5)==2),...
            sum(X_train(:,5)==3)];
        
        mean_juvothercat = (1/num_data)*[sum(X_train(:,6)==1),sum(X_train(:,6)==2),...
            sum(X_train(:,6)==3)];

        mean_priorscat = (1/num_data)*[sum(X_train(:,7)==1),sum(X_train(:,7)==2),...
            sum(X_train(:,7)==3),sum(X_train(:,7)==4),sum(X_train(:,7)==5)];
        
        mean_sex = (1/num_data)*[sum(X_train(:,1)==0),sum(X_train(:,1)==1)];
        mean_race = (1/num_data)*[sum(X_train(:,3)==0),sum(X_train(:,3)==1)];
        mean_chargeF = (1/num_data)*[sum(X_train(:,8)==0),sum(X_train(:,8)==1)];


        if (x_test(1) == 0)
            psex=mean_sex(1);
        else
            psex=mean_sex(2);
        end
        
        if (x_test(3)== 0)
            prace=mean_race(1);
        else
            prace=mean_race(2);
        end
        
        if (x_test(8)== 0)
            pchargeF=mean_chargeF(1);
        else
            pchargeF=mean_chargeF(2);
        end
        
        if (x_test(2)== 1)
            page=mean_agecat(1);
        elseif (x_test(2) == 2)
            page=mean_agecat(2);
        elseif (x_test(2) == 3)
            page=mean_agecat(3);
        elseif (x_test(2) == 4)
            page=mean_agecat(4);
        end
        
        if (x_test(4) == 1)
            pjuvfel=mean_juvfelcat(1);
        elseif (x_test(4) == 2)
            pjuvfel=mean_juvfelcat(2);
        elseif (x_test(4) == 3)
            pjuvfel=mean_juvfelcat(3);
        end
        
        
        if (x_test(5)== 1)
            pjuvmisd=mean_juvmisdcat(1);
        elseif (x_test(5) == 2)
            pjuvmisd=mean_juvmisdcat(2);
        elseif (x_test(5) == 3)
            pjuvmisd=mean_juvmisdcat(3);
        end
        
        if (x_test(6)== 1)
            pjuvother=mean_juvothercat(1);
        elseif (x_test(6) == 2)
            pjuvother=mean_juvothercat(2);
        elseif (x_test(6) == 3)
            pjuvother=mean_juvothercat(3);
        end
        
        if (x_test(7) == 1)
            ppriors=mean_priorscat(1);
        elseif (x_test(7) == 2)
            ppriors=mean_priorscat(2);
        elseif (x_test(7) == 3)
            ppriors=mean_priorscat(3);
        elseif (x_test(7) == 4)
            ppriors=mean_priorscat(4);
        elseif (x_test(7) == 5)
            ppriors=mean_priorscat(5);
        end

        score = zeros(num_class);
        
        for k=1:num_class
            score(k)= page*prace*psex*pjuvfel*pjuvmisd*pjuvother*ppriors*pchargeF*prior(k);
        end

        score_optim = max(score);
        class = find(score==score_optim)-1;
end