%% Q1-4
% Main script to estimate c_n(2) for n = 1 to 10
N = 1e5; 
n_values = 1:10;
estimates = zeros(size(n_values)); 

for i = 1:length(n_values)
    n = n_values(i);
    estimates(i) = SIS_SAW(N, n); 
    fprintf('Estimated c_%d(2) = %.4f\n', n, estimates(i)); 
end

% Plot the results
figure;
plot(n_values, estimates, '-o', 'LineWidth', 2);
xlabel('n');
ylabel('Estimated c_n(2)');
title('Estimated Number of Self-Avoiding Walks in Z^2');
grid on;

% Function to generate a self-avoiding walk and compute its weight
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

        idx = randi(size(neighbors, 1)); 
        next_pos = neighbors(idx, :);

      
        walk = [walk; next_pos];
        visited(mat2str(next_pos)) = true;

        weight = weight * size(neighbors, 1);
    end
end



% Function to get free neighbors of a position
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

function c_n_estimate = SIS_SAW(N, n)
    total_weight = 0;

    for i = 1:N
        [~, weight] = generate_SAW(n);
        total_weight = total_weight + weight;
    end

    c_n_estimate = total_weight / N;
end
