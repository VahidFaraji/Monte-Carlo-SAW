%% Q1-6
n_values = 1:10;
num_repeats = 10;
all_estimates = zeros(num_repeats, length(n_values));

for rep = 1:num_repeats
    fprintf('Running Independent Estimation %d/%d...\n', rep, num_repeats);
    estimates = zeros(size(n_values));
    
    for i = 1:length(n_values)
        n = n_values(i);
        if n < 5
            N = 1e5;
        else
            N = 1e6;
        end
        estimates(i) = SISR_SAW(N, n);
    end
    
    all_estimates(rep, :) = estimates;
end

mean_estimates = mean(all_estimates, 1);
std_estimates = std(all_estimates, 0, 1);
exact_c_n = [4, 12, 36, 100, 284, 790, 2224, 6074, 16732, 46094];
error_percentage = abs(mean_estimates - exact_c_n) ./ exact_c_n * 100;

fprintf('\nEstimated Parameters (Based on Multiple Runs):\n');
fprintf('Mean Estimates:\n');
disp(mean_estimates);
fprintf('Standard Deviations:\n');
disp(std_estimates);

fprintf('\n   n     Mean_Estimated_c_n    Std_Dev    Exact_c_n    Error_Percentage\n');
fprintf('  __    __________________    _______    _________    ________________\n');
for i = 1:length(n_values)
    fprintf('  %2d       %10.4f       %7.4f       %6d       %10.4f\n', ...
            n_values(i), mean_estimates(i), std_estimates(i), exact_c_n(i), error_percentage(i));
end

figure;
hold on;
plot(n_values, mean_estimates, '-o', 'LineWidth', 2, 'DisplayName', 'Estimated c_n(2)');
plot(n_values, exact_c_n, '-s', 'LineWidth', 2, 'DisplayName', 'Exact c_n(2)');
xlabel('n');
ylabel('c_n(2)');
title('Estimated vs. Exact Number of Self-Avoiding Walks in Z^2');
legend;
grid on;
hold off;

log_c_n = log(mean_estimates);
log_n = log(n_values);
X = [ones(length(n_values), 1), n_values', log_n'];

b = X \ log_c_n';

A2_est = exp(b(1));
mu2_est = exp(b(2));
gamma2_est = b(3) + 1;

fprintf('\nEstimated Growth Parameters (Linear Regression Results):\n');
fprintf('A2 ≈ %.4f\n', A2_est);
fprintf('mu2 ≈ %.4f (Expected: ~2.638)\n', mu2_est);
fprintf('gamma2 ≈ %.4f (Expected: ~1.3438)\n', gamma2_est);

function c_n_estimate = SISR_SAW(N, n)
    particles = cell(N, 1);
    weights = zeros(N, 1);
    for i = 1:N
        [particles{i}, weights(i)] = generate_SAW(n);
    end
    normalized_weights = weights / (sum(weights) + 1e-10);
    resampled_indices = randsample(N, N, true, normalized_weights);
    resampled_particles = particles(resampled_indices);
    resampled_weights = ones(N, 1);
    c_n_estimate = sum(weights) / N;
end

function [walk, weight] = generate_SAW(n)
    walk = [0, 0];
    visited = containers.Map('KeyType', 'char', 'ValueType', 'logical');
    visited(mat2str([0, 0])) = true;
    weight = 1;
    for k = 1:n
        current_pos = walk(end, :);
        neighbors = get_free_neighbors(current_pos, visited);
        if isempty(neighbors)
            weight = 0;
            break;
        end
        next_pos = neighbors(randi(size(neighbors, 1)), :);
        walk = [walk; next_pos];
        visited(mat2str(next_pos)) = true;
        weight = weight * length(neighbors);
    end
end

function neighbors = get_free_neighbors(current_pos, visited)
    possible_neighbors = [1, 0; -1, 0; 0, 1; 0, -1];
    neighbors = [];
    for i = 1:size(possible_neighbors, 1)
        next_pos = current_pos + possible_neighbors(i, :);
        if ~visited.isKey(mat2str(next_pos))
            neighbors = [neighbors; next_pos];
        end
    end
end
