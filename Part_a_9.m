ds = [3, 6, 12, 24];
A = zeros(length(ds), 1);
mu = zeros(length(ds), 1);
gamma = zeros(length(ds), 1);
mu_bd = zeros(length(ds), 1);

N = 5e4; 
max_n = 50; 

for ind_d = 1:length(ds)
    d = ds(ind_d);
    moves = [eye(d); -eye(d)];

    path = zeros(N, max_n + 1, d);
    c_est = zeros(max_n, 1);
    overall_est = 1;
    
    for step = 1:max_n
        weights = zeros(N, 1);
        for i = 1:N
            neighbors = shiftdim(path(i, step, :), 1) + moves;
            free_nei = [];
            for j = 1:(2 * d)
                if ~ismember(neighbors(j, :), shiftdim(path(i, :, :), 1), 'rows')
                    free_nei = [free_nei; neighbors(j, :)];
                end
            end
    
            weights(i) = size(free_nei, 1);
            if weights(i) > 0
                path(i, step + 1, :) = free_nei(randi(weights(i)), :);
            else
                path(i, step + 1, :) = path(i, step, :);
            end
        end
    
        ind = randsample(N, N, true, weights);
        path = path(ind, :, :);
        
        overall_est = overall_est * mean(weights);
        c_est(step) = overall_est;
    
        fprintf('Step n = %d, estimated c_n(%d) = %e\n', step, d, overall_est);
    end
    
    n_vals = (1:max_n)';
    
    X = [ones(max_n, 1), n_vals, log(n_vals)];
    b = X \ log(c_est);
    
    A(ind_d) = exp(b(1));
    mu(ind_d) = exp(b(2));
    gamma(ind_d) = b(3) + 1;
    mu_bd(ind_d) = 2 * d - 1 - 1 / (2 * d) - 3 / (2 * d)^2 - 16 / (2 * d)^3;
    
    fprintf('A_%d = %f\n', d, A(ind_d));
    fprintf('μ_%d = %f\n', d, mu(ind_d));
    fprintf('γ_%d = %f\n', d, gamma(ind_d));
end
