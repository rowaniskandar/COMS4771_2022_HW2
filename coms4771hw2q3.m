%COMS4771 summer B 2022
%homework 2
%codes also available on my github: https://github.com/rowaniskandar/COMS4771_2022_HW2
%created by: Rowan Iskandar (ri2282@columbia.edu;
%rowan.iskandar@sitem-insel.ch)
%modified: 23 July 2022
clear
rng(4)
data_test = readtable("propublicaTest.csv");
data_train = readtable("propublicaTrain.csv");
data_train_original = data_train;
data_summary = summary(data_test);
whos;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start of data pre-processing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
names = data_test.Properties.VariableNames;
num_features = size(data_train,2)-2;
num_data = size(data_train,1);
%get number of unique values of the class variable
a = unique(data_train(:,1));
num_class = size(a,1);
categories = [0,1];
%get number of unique values for each feature
%for features with many unique values, we create categorial variables (for
%naive Bayes)
%to derive the appropriate number and segments of the continuous data, we use quantiles
%age
unique_age = unique(data_train(:,2));
quantile_age=quantile(data_train.age,[0,0.25,0.5,0.75,1]);
data_train.agecat = double(ordinal(data_train.age,{'0','1','2', '3'},...
    [],[quantile_age(1),quantile_age(2),quantile_age(3),quantile_age(4),quantile_age(5)]));
unique_sex = unique(data_train(:,3));
unique_race = unique(data_train(:,4));

%juv fel count (3 cats)
unique_juvfel = unique(data_train.juv_fel_count);
quantile_juvfel=quantile(data_train.juv_fel_count,[0,0.25,0.5,0.75,1]);
data_train.juvfelcat = double(ordinal(data_train.juv_fel_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvfel(5)]));
unique_juvfel = unique(data_train.juv_fel_count);


%juv misd count (3 cats)
unique_juvmisd = unique(data_train.juv_misd_count);
quantile_juvmisd=quantile(data_train.juv_misd_count,[0,0.25,0.5,0.75,1]);
tabulate(data_train.juv_misd_count);
data_train.juvmisdcat = double(ordinal(data_train.juv_misd_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvmisd(5)]));


%juv  other (3 cats)
unique_juvother = unique(data_train.juv_other_count);
quantile_juvother=quantile(data_train.juv_other_count,[0,0.25,0.5,0.75,1]);
tabulate(data_train.juv_other_count);
data_train.juvothercat = double(ordinal(data_train.juv_other_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvother(5)]));

%priors
unique_priors = unique(data_train.priors_count);
quantile_priors=quantile(data_train.priors_count,[0,0.25,0.5,0.75,1]);
tabulate(data_train.priors_count);
data_train.priorscat = double(ordinal(data_train.priors_count,{'0','1','2','3','4'},...
    [],[0,1,2,3,4,quantile_priors(5)]));

%charge F
% unique_chargeF = unique(data_train.c_charge_degree_F);
% quantile_chargeF=quantile(data_train.c_charge_degree_F,[0,0.25,0.5,0.75,1]);
% tabulate(data_train.c_charge_degree_F);
% data_train.chargeFcat = ordinal(data_train.c_charge_degree_F,{'0','1','above 1'},...
%     [],[0,1,2,quantile_chargeF(5)]);
% 
% %charge M
% unique_chargeM = unique(data_train.c_charge_degree_M);
% quantile_chargeM=quantile(data_train.c_charge_degree_M,[0,0.25,0.5,0.75,1]);
% tabulate(data_train.c_charge_degree_M);
% data_train.chargeMcat = ordinal(data_train.c_charge_degree_M,{'0','1','above 1'},...
%     [],[0,1,2,quantile_chargeM(5)]);

%Note that charge F and M are reciprocal of each other -> so keep one
%c_charge_degree_F

%drop the original (redundant) variables 
% data_train = removevars(data_train,{'age','juv_fel_count','juv_misd_count','juv_other_count',...
%     'priors_count','c_charge_degree_M'});
data_train = [data_train.two_year_recid data_train.sex data_train.agecat data_train.race data_train.juvfelcat data_train.juvmisdcat data_train.juvothercat data_train.priorscat data_train.c_charge_degree_F];

data_train_original = removevars(data_train_original,{'c_charge_degree_M'});

%repeat above categorizations and apply them to data_test

%get number of unique values for each feature
%for features with many unique values, we create categorial variables (for
%naive Bayes)
%to derive the appropriate number and segments of the continuous data, we use quantiles
%age
unique_age = unique(data_test(:,2));
quantile_age=quantile(data_test.age,[0,0.25,0.5,0.75,1]);
data_test.agecat = double(ordinal(data_test.age,{'0','1','2', '3'},...
    [],[quantile_age(1),quantile_age(2),quantile_age(3),quantile_age(4),quantile_age(5)]));
unique_sex = unique(data_test(:,3));
unique_race = unique(data_test(:,4));

%juv fel count (3 cats)
unique_juvfel = unique(data_test.juv_fel_count);
quantile_juvfel=quantile(data_test.juv_fel_count,[0,0.25,0.5,0.75,1]);
data_test.juvfelcat = double(ordinal(data_test.juv_fel_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvfel(5)]));
unique_juvfel = unique(data_test.juv_fel_count);


%juv misd count (3 cats)
unique_juvmisd = unique(data_test.juv_misd_count);
quantile_juvmisd=quantile(data_test.juv_misd_count,[0,0.25,0.5,0.75,1]);
tabulate(data_test.juv_misd_count);
data_test.juvmisdcat = double(ordinal(data_test.juv_misd_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvmisd(5)]));


%juv  other (3 cats)
unique_juvother = unique(data_test.juv_other_count);
quantile_juvother=quantile(data_test.juv_other_count,[0,0.25,0.5,0.75,1]);
tabulate(data_test.juv_other_count);
data_test.juvothercat = double(ordinal(data_test.juv_other_count,{'0','1','2'},...
    [],[0,1,2,quantile_juvother(5)]));

%priors
unique_priors = unique(data_test.priors_count);
quantile_priors=quantile(data_test.priors_count,[0,0.25,0.5,0.75,1]);
tabulate(data_test.priors_count);
data_test.priorscat = double(ordinal(data_test.priors_count,{'0','1','2','3','4'},...
    [],[0,1,2,3,4,quantile_priors(5)]));

data_test = removevars(data_test,{'age','juv_fel_count','juv_misd_count','juv_other_count',...
    'priors_count','c_charge_degree_M'});
data_test = [data_test.two_year_recid data_test.sex data_test.agecat data_test.race data_test.juvfelcat data_test.juvmisdcat data_test.juvothercat data_test.priorscat data_test.c_charge_degree_F];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%start of analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Y = data_train(:,1);
X = data_train(:,2:9);
ks=[1,2,4,6,8,10];
%k-fold cross-validation performance evaluation
%number of k folds
k_cv = 10;
% Get the number of vectors belonging to each category.
vecsPerCat = getVecsPerCat(X, Y, categories);
% Compute the fold sizes for each category
foldSizes = computeFoldSizes(vecsPerCat, k_cv);
% Randomly sort the vectors in X, then organize them by category.
[X_sorted, y_sorted] = randSortAndGroup(X, Y, categories);

%variables to store performance
performance_gaussian=zeros(1,k_cv);
performance_knn_euclid=zeros(size(ks,2),k_cv);
performance_knn_l1=zeros(size(ks,2),k_cv);
performance_knn_linf=zeros(size(ks,2),k_cv);
performance_naive=zeros(1,k_cv);
eps=0.0001;
for i=1:k_cv
    %iterate through each fold of cross-validation samples
    [X_train, Y_train, X_test, Y_test] = getFoldVectors(X_sorted, y_sorted, categories, vecsPerCat, foldSizes, i);    %Multivariate Gaussian classifier
    train = cat(2,X_train,Y_train);
    %evaluate performance
    %performance_gaussian(i) = classifier_gaussian_mv_err(X_train, Y_train, X_test, Y_test, num_class, num_features,eps);
    %k-nn classifier
    performance_knn_euclid(:,i) = classifier_generalkNN_err(X_train,Y_train,X_test, Y_test,ks,"euclidean");
    performance_knn_l1(:,i) = classifier_generalkNN_err(X_train,Y_train,X_test, Y_test,ks,"l1");
    performance_knn_linf(:,i) = classifier_generalkNN_err(X_train,Y_train,X_test, Y_test,ks,"linf");
    %naive bayes
    performance_naive(i) = classifier_naivebayes_err(X_train, Y_train, X_test, Y_test, num_class, num_features);
end
%summary of performance using cross
performance_knn_euclid_avg = sum(performance_knn_euclid)/k_cv;
performance_knn_l1_avg = sum(performance_knn_l1)/k_cv;
performance_knn_linf_avg = sum(performance_knn_linf)/k_cv;
performance_gaussian_avg = sum(performance_gaussian)/k_cv;

%out of sample predictions
