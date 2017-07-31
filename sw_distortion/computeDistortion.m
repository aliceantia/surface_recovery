function c = computeDistortion(path_matrix, sw_matrix)
N = 1000;
shrinking_ratio = path_matrix./sw_matrix;
max_lambda = max(shrinking_ratio(:));
min_lambda = min(shrinking_ratio(:));
x = linspace(min_lambda,max_lambda, N);
distortions = zeros(1, N);
for ii = 1:N
    diff = abs(path_matrix - x(ii)*sw_matrix);
    distortions(ii) = max(diff(:));
end
c= min(distortions);    