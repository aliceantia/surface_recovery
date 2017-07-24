addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system

T = 10000;
alpha = 1000;
beta = 100;
t = linspace(0, 2*pi*NPeriods*alpha, T);

f = cos(t/beta) + cos(t/alpha);
fT = cos(t/beta) - cos(t/alpha);

%% observation function

dim = 20;
Tau = 1;
dT = 1;

%% dot product

SWf = getSlidingWindow(f, dim, Tau, dT);
SWfT = getSlidingWindow(fT, dim, Tau, dT);

u = SWf(1,:);

f = SWf*u';
fT = SWfT*u';

ts = min(x,y);

X = getSlidingWindow(ts, dim, Tau, dT);

Y = getPCA(X);
X = getGreedyPerm(X, 300);

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(X);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DX, 3, 2);

figure(1);
clf;

subplot(321);
C = plotTimeColors(1:length(ts), ts, 'type', '2DLine');
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
