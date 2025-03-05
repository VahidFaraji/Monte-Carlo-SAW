%% Q1-5
n_values = 1:10; 
estimates = zeros(size(n_values)); 

for i = 1:length(n_values)
    n = n_values(i);
    
    if n < 5
        N = 1e5; 
    else
        N = 1e6;
    end
    
    estimates(i) = SISR_SAW(N, n); 
    fprintf('Estimated c_%d(2) = %.4f (N = %d)\n', n, estimates(i), N);
end

% Plot the results
figure;
plot(n_values, estimates, '-o', 'LineWidth', 2);
xlabel('n');
ylabel('Estimated c_n(2)');
title('Estimated Number of Self-Avoiding Walks in Z^2 using SISR');
grid on;

%% Function to estimate c_n(2) using SISR
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

%% Function to generate a self-avoiding walk and compute its weight
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

%% Function to get free neighbors of a position
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