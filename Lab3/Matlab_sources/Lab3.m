%% Machine Learning -- Lab3: Logistic Regression
%
%  Instructions
%  ------------
%
%  This file contains code that helps you get started on the logistic
%  regression exercise. You will need to complete the following functions
%  in this exericse:
%
%     sigmoid.m
%     costFunction.m
%     predict.m
%     costFunctionReg.m
%
%  For this exercise, you will not need to change any code in this file,
%  or any other files other than those mentioned above.
%

%% Initialization
clear ; close all; clc

%% Load Data
%  The first two columns contains the exam scores and the third column
%  contains the label.

data = load('Lab3_data1.txt');
X = data(:, [1, 2]); y = data(:, 3);

%% ==================== Part 1: Plotting ====================
%  We start the exercise by first plotting the data to understand the
%  the problem we are working with.

fprintf(['Plotting data with + indicating (y = 1) examples and o ' ...
         'indicating (y = 0) examples.\n']);

plotData(X, y);

% Put some labels
hold on;
% Labels and Legend
xlabel('Exam 1 score')
ylabel('Exam 2 score')

% Specified in plot order
legend('Admitted', 'Not admitted')
hold off;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ============ Part 2: Compute Cost and Gradient ============
%  In this part of the exercise, you will implement the cost and gradient
%  for logistic regression. You neeed to complete the code in
%  costFunction.m

%  Setup the data matrix appropriately, and add ones for the intercept term
[m, n] = size(X);

% Add intercept term to x and X_test
X = [ones(m, 1) X];

% Initialize fitting parameters
initial_theta = zeros(n + 1, 1);

% Compute and display initial cost and gradient
[cost, grad] = costFunction(initial_theta, X, y);

fprintf('Cost at initial theta (zeros): %f\n', cost);
fprintf('Gradient at initial theta (zeros): \n');
fprintf(' %f \n', grad);

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ============= Part 3: Optimizing using fminunc  =============
%  In this exercise, you will use a built-in function (fminunc) to find the
%  optimal parameters theta.

%%%% OBS: FOR THE NEXT FUNCTION YOU NEED THE MATLAB OPTIMIZATION TOOLBOX!!!
%%%%
%%%% INSTALL IT USING THE ADD-ONS FROM HOME TAB!!!

%  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 400);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost
[theta, cost] = ...
    fminunc(@(t)(costFunction(t, X, y)), initial_theta, options);

% Print theta to screen
fprintf('Cost at theta found by fminunc: %f\n', cost);
fprintf('theta: \n');
fprintf(' %f \n', theta);

% Plot Boundary
plotDecisionBoundary(theta, X, y);

% Put some labels
hold on;
% Labels and Legend
xlabel('Exam 1 score')
ylabel('Exam 2 score')

% Specified in plot order
legend('Admitted', 'Not admitted')
hold off;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ============== Part 4: Predict and Accuracies ==============
%  After learning the parameters, you'll like to use it to predict the outcomes
%  on unseen data. In this part, you will use the logistic regression model
%  to predict the probability that a student with score 45 on exam 1 and
%  score 85 on exam 2 will be admitted.
%
%  Furthermore, you will compute the training and test set accuracies of
%  our model.
%
%  Your task is to complete the code in predict.m

%  Predict probability for a student with score 45 on exam 1
%  and score 85 on exam 2

prob = sigmoid([1 45 85] * theta);
fprintf(['For a student with scores 45 and 85, we predict an admission ' ...
         'probability of %f\n\n'], prob);

% Compute accuracy on our training set
p = predict(theta, X);

fprintf('Train Accuracy: %f\n', mean(double(p == y)) * 100);

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ============== Exercise a): Predict for Additional Students ==============
% Predict the admission result for 3 additional students
additional_students = [1 50 80; 1 60 70; 1 70 60];
additional_probs = sigmoid(additional_students * theta);
additional_preds = predict(theta, additional_students);

% Display the results
for i = 1:size(additional_students, 1)
    fprintf('For a student with scores %.0f and %.0f, we predict an admission probability of %f and prediction %d\n', ...
        additional_students(i, 2), additional_students(i, 3), additional_probs(i), additional_preds(i));
end

%% ============== Exercise b): Plot the predicted values with a different color and shape ==============
figure;
plotData(X(:, 2:3), y); % Plot the original data without the intercept term
hold on;
plot(additional_students(:, 2), additional_students(:, 3), 'kx', 'MarkerSize', 10, 'LineWidth', 2, 'Color', 'r');
legend('Admitted', 'Not admitted', 'Predicted');
hold off;

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

%% ============== Exercise c): Gradient Descent Iteratively ==============
% Apply gradient descent iteratively with learning rate 0.01
alpha = 0.01;
num_iters = 400;
theta = zeros(2, 1); % Initialize theta with 2 elements
J_history = zeros(num_iters, 1);

figure;
pos = find(y == 1);
neg = find(y == 0);
plot(X(pos, 2), X(pos, 3), 'k+','LineWidth', 2, 'MarkerSize', 7);
hold on;
plot(X(neg, 2), X(neg, 3), 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 7);

% Initialize the decision boundary plot
plot_x = [min(X(:,2))-2,  max(X(:,2))+2];
plot_y = (-1./theta(2)).*(theta(1).*plot_x);
decision_boundary_plot = plot(plot_x, plot_y, 'b-');

grad = zeros(2, 1);
y_pred = zeros(100, 1);
for iter = 1:num_iters
    % Compute the prediction
    y_pred = X(:, 2:3) * theta;  

    % Compute the gradient
    grad = (1 / m) * (X(:, 2:3)' * (y_pred - y))

    % Update theta simultaneously
    theta = theta - alpha * grad;

    % Save the cost J in every iteration
    J_history(iter) = (1 / m) * sum(-y .* log(sigmoid(X(:, 2:3) * theta)) - (1 - y) .* log(1 - sigmoid(X(:, 2:3) * theta)));

    % Update the decision boundary plot every 50 iterations
    if mod(iter, 50) == 0
        plot_y = (-1./theta(2)).*(theta(1).*plot_x);
        set(decision_boundary_plot, 'YData', plot_y);
        drawnow;
    end
end

xlabel('Exam 1 score');
ylabel('Exam 2 score');
legend('Admitted', 'Not admitted', 'Decision Boundary');
hold off;

fprintf('\nProgram paused. Press enter to continue.\n');
