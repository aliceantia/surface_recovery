addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system
NPeriods = 1;
T = 10000;
alpha = 90;
t = linspace(0, pi, T);
%g = @(x) -pi/2*cos(x) + pi/2;
g =  @(x) cos(x);
obs1 = 1.2;
obs2 = .9;
%f = 0.4*(cos((t+05)*(1+alpha)) - cos((t+0.5)*(1-alpha))) + cos(t*(2+alpha)) + cos(t*(2-alpha)) ;
% f = min(g(alpha*t-obs1)+ g(t-obs2), g(alpha*t - obs1 + pi) + g(-t-obs2));
f = sqrt((g(alpha*t-obs1)+ g(t-obs2)).*(g(alpha*t - obs1 + pi) + g(-t-obs2)));

% f = 0.5 + cos(alpha*t - obs1)*sin(t) + cos(alpha*t - obs).^2 + 0.5*
% \cos \left(nx+1\right)\sin x\ \ +0.5\left(1+\cos \left(nx+1\right)^2\right)+\ 0.5\sin \left(2x-\frac{\pi }{2}\right)\sin \left(\phi \right)+\cos \left(x\right)\cos \left(\phi \right)+\frac{1}{2}\cos \left(nx+1\right)^2\cos \left(2x\right)
%% observation function

dim = 100;
Tau = 1;
dT = 1;

%% dot product

SWf = getSlidingWindow(f, dim, Tau, dT);

Y = getPCA(SWf);
SWf = getGreedyPerm(SWf, 250);

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