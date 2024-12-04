clear variables
clc

% option 1 read all data at once
data = readtable('nhanes_matlab.xlsx');

% % option 2 read multiple directories
% ds = datastore('nhanes_matlab.xlsx'); % create a datastore object
% ds.ReadSize = 50; % Set ReadSize property in ds to 50 so we only read in 50 lines at a time
% data50 = read(ds); % Read in first 50 lines
% data100 = read(ds); % Read in next 50 lines
% data_all = readall(ds); % Read in all data

% % option 3
% filename = 'nhanes_matlab.xlsx';
% fid = fopen(filename) %open file - first set a particular filename!
% myLine = fgetl(fid) %read data - option 1
% myData = textscan(fid, formatSpec) % read data - option 2
% fclose(fid); % Close the file

% % write data
% write_data = data(1:5, 1:5) %select the data you want
% filename = 'new_data.xlsx'; %write to excel file
% writetable(write_data, filename) %write the data

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

% These do not work when there is NaN data
mean_Height1 = mean(data_Height); % Must create the height array first
median_Height1 = median(data_Height);
mode_Height1 = mode(data_Height);
stddev_Height1 = std(data_Height);

% These omit NaN values
mean_Height2 = mean(data_ID_Height_arr, 'omitnan')
median_Height2 = median(data_ID_Height_arr, 'omitnan')
stddev_Height2 = std(data_ID_Height_arr, 'omitnan')

%% ------------------------- Plotting -------------------------
% Plot first 40 heights - as line
data_ID_Height_arr = table2array(data_ID_Height);
plot(data_ID_Height_arr(1:40, 2));

% Plot multiple lines
data_ID_Height_arr = table2array(data_ID_Height);
space = (1:40); % Need to establish the number of points
l1 = data_ID_Height_arr(1:40, 2);
l2 = data_ID_Height_arr(41:80, 2);
plot(space, l1, space, l2);

% When plotting a matrix, each column is a line. Row index is the x-axis variable.
plot(space, l1, '--', space, l2, ':'); % '--' will plot y2 as a dashed line, ':' will plot y3 as a dotted line

% More Line Specifications: Line Style, Color, and Marker
% Line specifications can be written in any order. ('g--*' = '*g--')
plot(space, l1, 'g', space, l2, 'c*'); % 'g' plots y1 as a green line, 'c*' plots y3 as cyan asterisk markers with no line

% Subplots:
% Create 2 other sets
l3 = data_ID_Height_arr(81:120, 2);
l4 = data_ID_Height_arr(121:160, 2);

% Create 2 rows and 2 columns of subplots (2x2 = 4 total plots)
subplot(2, 2, 1); plot(space, l1); % Plots y1 in the first subplot
subplot(2, 2, 2); plot(space, l2); % Plots y2 in the second subplot
subplot(2, 2, 3); plot(space, l3); % Plots y3 in the third subplot
subplot(2, 2, 4); plot(space, l4); % Plots y4 in the fourth subplot

% Handles - change appearance
p = plot(space, l1);
p.Marker = '*'; % Add asterisk markers
p.Color = 'black'; % Change line color to black

%% Other visualization tools:
% Stem plot - for discrete values!
stem(data_ID_Height_arr(1:200,2))

% Stairs graph
stairs(data_ID_Height_arr(1:200,2))

% Scatter plots - view relations between multiple variables - can color based on a variable
scatter(data_ID_Height_arr(1:200,2), data_ID_Height_arr(1:200,1))

%% Heatmaps - can view categories
v2 = {'id', 'Race', 'Height'} % select the "categorical” attribute that separates the data into clases
                              % as well as the "numerical" attribute that provides the color for each class

data_useful2 = data(1:100, v2); %select just 100 rows and the desired columns
h = heatmap(data_useful2,'Race','id','ColorVariable','Height');

%% Histogram function
histogram(data_ID_Height_arr(1:2000,2)) %histogram of the heights in the first 2000 samples
histogram(data_ID_Height_arr(1:2000,2),10) % same histogram, using exactly 10 bins
histogram(data_ID_Height_arr(1:2000,2),[100,130,160,190]) %histogram, specifying intervals

%% Scaling
clc

data_ID_Height_scaled = rescale(table2array(data_Height)) % simple scale
% scale in interval
lower = 0 %set lower boundary
upper = 10 %set upper boundary
R = rescale(table2array(data_Height),lower,upper) % rescale into the established margins

%% Missing data
TF = ismissing(data_Height)
