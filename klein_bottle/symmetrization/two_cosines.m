addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system
NPeriods = 1;
T = 10000;
alpha = 100+sqrt(2); % ratio of winding
range = 4*pi;
t = linspace(0, range, T);
g = @(x) -pi/2*cos(x) + pi/2;
%g =  @(x) cos(x);
%g = @(x) min(2*pi - abs(mod(x,2*pi)),abs(mod(x,2*pi))); 
obs1 = 1.2;
obs2 = .9;
%f = 0.4*(cos((t+05)*(1+alpha)) - cos((t+0.5)*(1-alpha))) + cos(t*(2+alpha)) + cos(t*(2-alpha)) ;
% f = min(g(alpha*t-obs1)+ g(t-obs2), g(alpha*t - obs1 + pi) + g(-t-obs2));
f = min(g(alpha*t-obs1)+ g(t-obs2),g(alpha*t - obs1 + pi) + g(-t-obs2));
%f = g(alpha*t-obs1)+ g(t-obs2);
%f  = cos(alpha*t) + cos(t);
%% observation function

dim = 120;
% tau selection procedure (similar to in theorem 2.2 of jose's paper)
% eta = floor(dim*abs(alpha - 1)/(2*max(alpha,1)));
% numerical_tau = 2*pi* eta/(dim * abs(alpha-1))
Tau = 4; %floor(numerical_tau *(T/range))
dT = 1;

%% dot product

SWf = getSlidingWindow(f, dim, Tau, dT);

Y = getPCA(SWf);
SWf = getGreedyPerm(SWf, 300);

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(SWf);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DX, 3, 2);

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
plotBarcodes(IsSliding3{2});
title('H1 Phi (mod 3)');

subplot(326);
plotBarcodes(IsSliding3{3});
title('H2 Phi (mod 3)');

kleinBottlePersistence(IsSliding2{2},IsSliding2{3},IsSliding3{3})