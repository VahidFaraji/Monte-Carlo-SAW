% MATLAB Implementation for HA2-2 (Part a)
clc; clear; close all;

% Load the given dataset (population_2024.mat)
load('population_2024.mat'); % This should contain X_true and Y_obs
X_true = X;  % Assign correct variable name
Y_obs = Y;  % Assign correct variable name
% Given parameters
A = 0.8; B = 3.8; % Range for reproduction rate R_k
C = 0.6; D = 0.99; % Initial population range
G = 0.8; H = 1.25; % Observation noise range

n = length(Y_obs) - 1; % Number of time steps (n = 100)
N_values = [500, 1000, 10000]; % Different particle numbers for evaluation

A = 0.8; B = 3.8; C = 0.6; D = 0.99; G = 0.8; H = 1.25;
n = 100;
N_values = [500, 1000, 10000];

load('population_2024.mat');
X_true = X;  % Assuming X in the .mat file represents the true state

% Storage for results
results = struct();

for i = 1:length(N_values)
    N = N_values(i);
    particles = unifrnd(C, D, N, 1);
    tau = zeros(1, n+1);
    lower_CI = zeros(1, n+1);
    upper_CI = zeros(1, n+1);
    
    w = zeros(N, 1);
    for j = 1:N
        if Y(1) >= G * particles(j) && Y(1) <= H * particles(j)
            w(j) = 1 / (H * particles(j) - G * particles(j));
        else
            w(j) = 1e-10;
        end
    end
    w = w / sum(w);
    tau(1) = sum(particles .* w);
    lower_CI(1) = quantile(particles, 0.025);
    upper_CI(1) = quantile(particles, 0.975);
    
    Neff = 1 / sum(w.^2);
    if Neff < N / 2
        indices = randsample(N, N, true, w);
        particles = particles(indices);
    end
    
    for k = 1:n
        R = unifrnd(A, B, N, 1);
        particles = R .* particles .* (1 - particles) + 0.01 * randn(N, 1);
        
        w = zeros(N, 1);
        for j = 1:N
            if Y(k+1) >= G * particles(j) && Y(k+1) <= H * particles(j)
                w(j) = 1 / (H * particles(j) - G * particles(j));
            else
                w(j) = 1e-10;
            end
        end
        w = w / sum(w);
        tau(k+1) = sum(particles .* w);
        lower_CI(k+1) = quantile(particles, 0.025);
        upper_CI(k+1) = quantile(particles, 0.975);
        
        Neff = 1 / sum(w.^2);
        if Neff < N / 2
            indices = randsample(N, N, true, w);
            particles = particles(indices);
        end
    end
    
    % Compute Errors
    RMSE = sqrt(mean((tau - X_true).^2));
    MSE = mean((tau - X_true).^2);
    
    % Store results
    results(i).N = N;
    results(i).RMSE = RMSE;
    results(i).MSE = MSE;
    
    fprintf('N = %d, RMSE = %.4f, MSE = %.6f\n', N, RMSE, MSE);
    
    % --- 📌 Plot Results ---
    figure;
    hold on;

    % Fill the confidence interval
    fill([0:n, fliplr(0:n)], [upper_CI, fliplr(lower_CI)], 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'none');
    
    % Plot the true state
    plot(0:n, X_true, 'k--', 'LineWidth', 1.5);
    
    % Plot the filter estimate
    plot(0:n, tau, 'b', 'LineWidth', 1.5);
    
    xlabel('Time step k');
    ylabel('Estimated X_k');
    legend('Confidence Interval', 'True X_k', sprintf('Filter Estimate (N=%d)', N));
    title(sprintf('Particle Filter Estimate for N=%d with Confidence Interval', N));
    grid on;
    hold off;
end

