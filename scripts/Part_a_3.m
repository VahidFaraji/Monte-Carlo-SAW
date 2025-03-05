%% Q1-3
function estimate = SIS_naive(n, N)
    SAW_count = 0;
    for i = 1:N
        path = zeros(n+1, 2);
        path(1,:) = [0, 0];
        valid = true;
        for k = 1:n
            dir = randi(4);
            switch dir
                case 1
                    new_pos = path(k,:) + [0, 1];
                case 2
                    new_pos = path(k,:) + [0, -1];
                case 3
                    new_pos = path(k,:) + [-1, 0];
                case 4
                    new_pos = path(k,:) + [1, 0];
            end
            if any(ismember(path(1:k,:), new_pos, 'rows'))
                valid = false;
                break;
            end
            path(k+1,:) = new_pos;
        end
        SAW_count = SAW_count + valid;
    end
    estimate = (SAW_count / N) * 4^n;
end

N = 1e5; 
n_values = 1:10; 
estimates = zeros(size(n_values)); 

for i = 1:length(n_values)
    n = n_values(i);
    estimates(i) = SIS_naive(n, N);
    fprintf('n = %d, c_n(2) ≈ %.2f\n', n, estimates(i));
end
