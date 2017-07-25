% Sphere dynamics with antipodally symmetric observation function
addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');
addpath('../matlab_code/samirFunctions');

%% Define dynamical system
%Define observation function as cosine distance to some arbitrary point theta0
theta0 = 0.7;
phi0 = 1;
obsfn = @(theta, phi) sum(sphere2xyz(theta0, phi0).*sphere2xyz(theta, phi));
tic
[path, signal, sliding_window] = sphereSpiralTrajectory(600, 30, 40, obsfn);
toc
tic
%% Perform Sliding Window Embedding
pca = getPCA(sliding_window); %Perform PCA on sliding window embedding

[SWd, Md] = getDistanceMatrix(path, sliding_window, @dSphere);
toc
tic
computeDistortion(Md,SWd)
toc
X = unrollDistMat(SWd);
Y = unrollDistMat(Md);

D = SWd./Md;

subplot(131)
C = plotTimeColors(1:length(signal), signal, 'type', '2DLine');
subplot(132)
C = C(1:size(pca, 1), :);
scatter3(pca(:, 1), pca(:, 2), pca(:, 3), 20, C(:, 1:3), 'fill');
subplot(133)
scatter(Y,X, 2, 'filled');