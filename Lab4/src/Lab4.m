%% Machine Learning -- Lab4: Online Perceptron Algorithm
%
%  Instructions
%  ------------
%
%  This file contains code that helps you get started on implementing the
%  online perceptron algorithm. You will need to complete the following
%  steps:
%
%     1. Initialize the weights and parameters.
%     2. Implement the online perceptron algorithm.
%     3. Apply the algorithm to the training set.
%     4. Plot the decision boundary.
%

%% Initialization
clear; close all; clc;

%% Read the image
image_file = '../Lab4_img/test00.bmp';
img = imread(image_file);

% Get the dimensions of the image
[rows, cols, ~] = size(img);

% Initialize the training set
X = [];
Y = [];

%% Identify red and blue points and construct the training set
for row = 1:rows
    for col = 1:cols
        % Check if the point is red
        if img(row, col, 1) > 0 && img(row, col, 2) == 0 && img(row, col, 3) == 0
            X = [X; row, col];
            Y = [Y; 1];
        % Check if the point is blue
        elseif img(row, col, 1) == 0 && img(row, col, 2) == 0 && img(row, col, 3) > 0
            X = [X; row, col];
            Y = [Y; -1];
        end
    end
end

%% Display the results
fprintf('Number of red points: %d\n', sum(Y == 1));
fprintf('Number of blue points: %d\n', sum(Y == -1));

% Plot the points
figure;
hold on;
plot(X(Y == 1, 1), X(Y == 1, 2), 'r+', 'LineWidth', 2, 'MarkerSize', 7);
plot(X(Y == -1, 1), X(Y == -1, 2), 'bo', 'LineWidth', 2, 'MarkerSize', 7);
xlabel('Column');
ylabel('Row');
legend('Red Points', 'Blue Points');
axis([0, 30, -20, 50]);
hold off;


%% Online Perceptron Algorithm
% Parameters
eta = 1e-4;
w = [0.1; 0.1; 0.1]; % Initialize weights
E_limit = 1e-5;
max_iter = 1e5;

% Add bias term to X
X = [ones(size(X, 1), 1) X];

% Training loop
for iter = 1:max_iter
    % Initialize error
    E = 0;
    
    % Loop over each training example
    for i = 1:size(X, 1)
        % Compute the prediction
        y_pred = sign(w' * X(i, :)');
        
        % Update weights if there is a misclassification
        if y_pred ~= Y(i)
            w = w + eta * Y(i) * X(i, :)';
            E = E + 1;
        end
    end
    
    % Check for convergence
    if E / size(X, 1) < E_limit
        fprintf('Converged after %d iterations\n', iter);
        break;
    end
end

% Display final weights
fprintf('Final weights: \n');
disp(w);

%% Plot the decision boundary
figure;
hold on;
plot(X(Y == 1, 2), X(Y == 1, 3), 'r+', 'LineWidth', 2, 'MarkerSize', 7);
plot(X(Y == -1, 2), X(Y == -1, 3), 'bo', 'LineWidth', 2, 'MarkerSize', 7);

% Plot the decision boundary
plot_x = [min(X(:, 2))-2, max(X(:, 2))+2];
plot_y = (-w(1) - w(2) * plot_x) / w(3);
plot(plot_x, plot_y, 'k-', 'LineWidth', 2);

xlabel('Column');
ylabel('Row');
legend('Red Points', 'Blue Points', 'Decision Boundary');
hold off;

%% Batch Perceptron Algorithm


