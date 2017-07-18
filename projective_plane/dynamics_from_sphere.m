% Sphere dynamics with antipodally symmetric observation function
addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

sphere2xyz = @(theta, phi) [cos(theta)*cos(phi), sin(theta)*cos(phi), sin(phi) ];

%% Define dynamical system
%Define observation function as cosine distance to some arbitrary point theta0
theta0 = 0.6;
phi0 = 0.3;
obsfn = @(theta, phi) abs(sum(sphere2xyz(theta0, phi0).*sphere2xyz(theta, phi)));

%Fill out a spiral trajectory on the sphere
NTotal = 840;
NPeriods = 30;
phis = linspace(-pi/5, pi/5, NTotal);
thetas = linspace(0, 2*pi*NPeriods, NTotal);

%Apply observation function to trajectory points to get a time series x
x = zeros(NTotal, 1);
X = zeros(NTotal, 3);
for ii = 1:NTotal
    x(ii) = obsfn(thetas(ii), phis(ii));
    X(ii, :) = sphere2xyz(thetas(ii), phis(ii));
end

plot3(X(:, 1), X(:, 2), X(:, 3));


%% Perform Sliding Window Embedding
X = getSlidingWindowNoInterp(x, NTotal/NPeriods);
Y = getPCA(X); %Perform PCA on sliding window embedding
X = getGreedyPerm(X, 400); % fps on embedding point cloud

%% Compute PH of the embedding

disp('Doing TDA...');
DX = getSSM(X);
IsSliding = ripserDM(DX, 2, 2);

clf;
subplot(221);
C = plotTimeColors(1:length(x), x, 'type', '2DLine');
title('SSM Original');

subplot(222);
Y = Y(:, 1:3); %Go down to 3D PCA
C = C(1:size(Y, 1), :);
scatter3(Y(:, 1), Y(:, 2), Y(:, 3), 20, C(:, 1:3), 'fill');
title('PCA Phi');

subplot(223);
plotDGM(IsSliding{2});
title('H1 Phi');

subplot(224);
plotDGM(IsSliding{3});
title('H2 Phi');