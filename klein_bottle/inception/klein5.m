% Sliding window on spiral path down a cylinder with two cross caps
% We are attempting to recreate the homology of the Klein Bottle,
% which is equivalent to the connected sum of two projective planes.

addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define dynamical system
%Define observation function as distance to some arbitrary point theta0
width = 1;
height = 0.2; %(height)
    
theta0 = 0.3*width;
phi0 = 0.3*height;

g = @(theta, phi) sqrt(min(width- mod(abs(theta - theta0),width), mod(abs(theta-theta0),width)).^2+ abs(phi-phi0).^2);

gK = @(theta, phi) min(g(theta + width/2, -phi), g(theta+ width/2, 2*height- phi));
obsfn = @(theta, phi) min(g(theta,phi), gK(theta,phi));

%Fill out a trajectory on the cylinder
NTotal = 10000;
NPeriods = 100;
thetas = linspace(0, NPeriods*width, NTotal);
phis = linspace(0, height , NTotal);

%Apply observation function to trajectory points to get a time series x
x = obsfn(thetas, phis);

%% Perform Sliding Window Embedding

dim = NTotal/NPeriods;
Tau = 1;
dT = 1;
X = getSlidingWindow(x, dim, Tau, dT);

%% iterate SW!!

% temp = size(SW(:,1));
% M = temp(1);
% 
% obspt = SW(floor(M/2),:);
% 
% y = zeros(M);
% for ii=1:M
%     y(ii) = dot(obspt,SW(ii,:));
% end
% 
% X = getSlidingWindow(y, dim, Tau, dT*M/NTotal);
% x = y;

%% end iterate SW

Y = getPCA(X); %Perform PCA on sliding window embedding
X = getGreedyPerm(X, 300); % fps on embedding point cloud

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(X);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DX, 3, 2);

figure(2);
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