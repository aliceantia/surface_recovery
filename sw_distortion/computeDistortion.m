function c = computeDistortion(path_matrix, sw_matrix)
N = 1000;
shrinking_ratio = sw_matrix./path_matrix;
max_lambda = 1/min(shrinking_ratio(:));
x = linspace(0,max_lambda, N);
distortions = zeros(1, N);
for ii = 1:N
    diff = abs(path_matrix - x(ii)*sw_matrix);
    distortions(ii) = max(diff(:));
end 
c= min(distortions);