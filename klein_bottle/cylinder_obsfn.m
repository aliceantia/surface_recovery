% Sliding window on spiral path down a cylinder with two cross caps
% We are attempting to recreate the homology of the Klein Bottle,
% which is equivalent to the connected sum of two projective planes.

addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

%% Define dynamical system
%Define observation function as distance to some arbitrary point theta0
inverse_fatness = 0.2; %(height)
    
theta0 = 0.3;
z0 = 0.3*inverse_fatness;

d_cyl = @(theta, z) min(1- mod(abs(theta - theta0),1), mod(abs(theta-theta0),1))+ abs(z-z0);

g = @(theta, z) min(d_cyl(theta + 0.5, -z), d_cyl(theta+ 0.5, 2*inverse_fatness- z));
obsfn = @(theta, z) g(theta,z).*d_cyl(theta,z);

%Fill out a trajectory on the cylinder
NTotal = 10000;
NPeriods = 100;
zs = linspace(0, inverse_fatness , NTotal);
thetas = linspace(0, NPeriods, NTotal);

%Apply observation function to trajectory points to get a time series x
x = obsfn(thetas, zs);


%% Perform Sliding Window Embedding
X = getSlidingWindowNoInterp(x, NTotal/NPeriods);
Y = getPCA(X); %Perform PCA on sliding window embedding
X = getGreedyPerm(X, 300); % fps on embedding point cloud

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(X);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DX, 3, 2);

clf;
subplot(321);
C = plotTimeColors(1:length(x), x, 'type', '2DLine');
title('SSM Original');

subplot(322);
Y = Y(:, 1:3); %Go down to 3D PCA
C = C(1:size(Y, 1), :);
scatter3(Y(:, 1), Y(:, 2), Y(:, 3), 20, C(:, 1:3), 'fill');
title('PCA Phi');

subplot(323);
plotDGM(IsSliding2{2});
title('H1 Phi (mod 2)');

subplot(324);
plotDGM(IsSliding2{3});
title('H2 Phi (mod 2)');

subplot(325);
plotDGM(IsSliding3{2});
title('H1 Phi (mod 3)');

subplot(326);
plotDGM(IsSliding3{3});
title('H2 Phi (mod 3)');