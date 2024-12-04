clear variables
clc

% option 1 read all data at once
data = readtable('nhanes_matlab.xlsx');

v = {'id', 'Height', 'Weight'}; %Create a vector containing the names of the desired columns
data_useful = data(:, v); %extract the required columns by specifying the names
%data_useful = data(:, 1:3); %alternative way: extract the required columns by specifying the index

%Minimum
data_Height = min(data_useful); %2.1 minimum value for the numerical matrix
data_Height = data_useful(:, 2); %2.1 just Height data
min_Height = min(data_Height); %2.1 minimum value for Height
max_Height = max(data_Height); %2.1 maximum value for Height

%ID of the minimum
data_ID_Height = data_useful(:, 1:2); %select the ID and the Height
min_Height_arr = table2array(min(data_ID_Height)); %convert to numerical value – ID + Height
min_Height = min_Height_arr(2); %extract minimum
id_min_Height = min_Height_arr(1); %extract ID of minimum
data_ID_Height_arr = table2array(data_ID_Height(:, 2)); %convert to numerical value
id_Min = find(data_ID_Height_arr == min_Height);
id_found_Min = data_useful(id_Min, 1); % ID on column 1

%% Problem 3.2

% With function
mean_Height2 = mean(data_ID_Height_arr, 'omitnan');
median_Height2 = median(data_ID_Height_arr, 'omitnan');
stddev_Height2 = std(data_ID_Height_arr, 'omitnan')

% With formula from page 3
data_ID_Height_arr = data_ID_Height_arr(~isnan(data_ID_Height_arr)); % remove NaN
sqrt(sum((data_ID_Height_arr - mean_Height2) .^ 2) / length(data_ID_Height_arr))

%% Problem 3.3

v_prob_3 = {'id', 'Diabetes', 'BMI'};

data_for_heatmap = data(1:100, v_prob_3); %select just 100 rows and the desired columns
h = heatmap(data_for_heatmap, 'Diabetes', 'BMI', 'ColorVariable','BMI');

%% Problem 3.4

data4scale = data(:, 'Age');
minAge_scale = 1;
maxAge_scale = 10;
data_scaled = ((data4scale - min(data4scale)) ./ (max(data4scale) - min(data4scale))) .* (maxAge_scale - minAge_scale)  + minAge_scale;

min(data_scaled)
max(data_scaled)

%% Problem 3.5 (primul 3.5)

figure,
subplot(2, 1, 1)
histogram(data4scale{:, 1}) 
title('Before scaling')

subplot(2, 1, 2)
histogram(data_scaled{:, 1})
title('After scaling')

%% Problem 3.5 (al doilea 3.5)

% Extract the 'Income' column from the table
dataTImp = data(:, 'Income');

% Identify missing values
TF = ismissing(dataTImp);

% Mean of all values
meanOfAllValues = mean(dataTImp{:, 'Income'}, 'omitnan');

% Median of the first 20 values
medianOfTheFirst20Values = median(dataTImp{1:20, 'Income'}, 'omitnan');

% Standard deviation of all values
stddev = std(dataTImp{:, 'Income'}, 'omitnan');

% Minimum of the normalized data
minOfTheNormalized = min((dataTImp{:, 'Income'} - meanOfAllValues) / stddev, [], 'omitnan');

% Create copies of the 'Income' column for different imputation methods
dataTImp1 = dataTImp;
dataTImp2 = dataTImp;
dataTImp3 = dataTImp;

% Replace missing values with the mean, median, and minimum of the normalized data
for i = 1:height(dataTImp)
    if TF(i, 1)
        dataTImp1.Income(i) = meanOfAllValues;
        dataTImp2.Income(i) = medianOfTheFirst20Values;
        dataTImp3.Income(i) = minOfTheNormalized;
    end
end

%% Problem 3.6

% Separate the data into train (60%), test (20%), and validate (20%) sets
num_rows = height(data);
train_end = round(0.6 * num_rows);
test_end = train_end + round(0.2 * num_rows);

train_data = data(1:train_end, :);
test_data = data(train_end+1:test_end, :);
validate_data = data(test_end+1:end, :);

% Choose a numerical feature for computing the means (e.g., Height)
train_height = train_data{:, 'Height'};
validate_height = validate_data{:, 'Height'};
test_height = test_data{:, 'Height'};

% Compute means and standard deviation
mean_train = mean(train_height, 'omitnan');
mean_validate = mean(validate_height, 'omitnan');
std_test = std(test_height, 'omitnan');

% Check if the difference in mean between train and validate is smaller than the std of test
mean_diff = abs(mean_train - mean_validate);
is_smaller = mean_diff < std_test;

fprintf('Mean difference between train and validate: %f\n', mean_diff);
fprintf('Standard deviation of test dataset: %f\n', std_test);
fprintf('Is mean difference smaller than std of test? %d\n', is_smaller);

% Plot histograms for the 3 dataset distributions
figure;
subplot(3, 1, 1);
histogram(train_height);
title('Train Data Distribution');

subplot(3, 1, 2);
histogram(test_height);
title('Test Data Distribution');

subplot(3, 1, 3);
histogram(validate_height);
title('Validate Data Distribution');

%% Problem 3.7

% Alternative partitioning method: Random partitioning
rng(0); % For reproducibility
indices = randperm(num_rows);

train_indices = indices(1:train_end);
test_indices = indices(train_end+1:test_end);
validate_indices = indices(test_end+1:end);

train_data_random = data(train_indices, :);
test_data_random = data(test_indices, :);
validate_data_random = data(validate_indices, :);

% Choose a numerical feature for computing the means (e.g., Height)
train_height_random = train_data_random{:, 'Height'};
validate_height_random = validate_data_random{:, 'Height'};
test_height_random = test_data_random{:, 'Height'};

% Compute means and standard deviation
mean_train_random = mean(train_height_random, 'omitnan');
mean_validate_random = mean(validate_height_random, 'omitnan');
std_test_random = std(test_height_random, 'omitnan');

% Check if the difference in mean between train and validate is smaller than the std of test
mean_diff_random = abs(mean_train_random - mean_validate_random);
is_smaller_random = mean_diff_random < std_test_random;

fprintf('Random partitioning:\n');
fprintf('Mean difference between train and validate: %f\n', mean_diff_random);
fprintf('Standard deviation of test dataset: %f\n', std_test_random);
fprintf('Is mean difference smaller than std of test? %d\n', is_smaller_random);

% Plot histograms for the 3 dataset distributions (random partitioning)
figure;
subplot(3, 1, 1);
histogram(train_height_random);
title('Train Data Distribution (Random)');

subplot(3, 1, 2);
histogram(test_height_random);
title('Test Data Distribution (Random)');

subplot(3, 1, 3);
histogram(validate_height_random);
title('Validate Data Distribution (Random)');
