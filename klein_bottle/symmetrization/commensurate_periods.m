addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system
NPeriods = 1;
T = 20000;
alpha = 90;
t = linspace(0, 25*pi, T);

f = cos(sqrt(2)*t) + cos(sqrt(5)*t) + cos((sqrt(5)+3*sqrt(2))*t);
%% observation function

dim = 40;
Tau = floor(T/(dim*15));
dT = 1;

%% dot product

SWf = getSlidingWindow(f, dim, Tau, dT);

Y = getPCA(SWf);
SWf = getGreedyPerm(SWf, 200);

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(SWf);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
%IsSliding3 = ripserDM(DX, 3, 2);

figure(1);
clf;

subplot(321);
C = plotTimeColors(1:length(f), f, 'type', '2DLine');
title('SSM Original');

subplot(322);
Y = Y(:, 1:3); %Go down to 3D PCA
C = C(1:size(Y, 1), :);
scatter3(Y(:, 1), Y(:, 2), Y(:, 3), 20, C(:, 1:3), 'fill');
title('PCA Phi');

subplot(323);
plotBarcodes(IsSliding2{2});
title('H1 Phi (mod 2)');

subplot(324);
plotBarcodes(IsSliding2{3});
title('H2 Phi (mod 2)');

subplot(325);
plotDGM(IsSliding2{2});
title('H1 Phi (mod 2)');

subplot(326);
plotDGM(IsSliding2{3});
title('H2 Phi (mod 2)');

% subplot(325);
% plotBarcodes(IsSliding3{2});
% title('H1 Phi (mod 3)');
% 
% subplot(326);
% plotBarcodes(IsSliding3{3});
% title('H2 Phi (mod 3)');