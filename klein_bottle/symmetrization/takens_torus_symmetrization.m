addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system

dTheta = 1;
dPhi = 1;

scale = 1;

height = .2; %decrease for shallower angle. risky because ripser can't see the identification

numPeriods = 100; %increase for shallower angle

b = 100; %period size. increase for more points

numIterations = numPeriods*b;

thetas = linspace(0, scale*numPeriods*dTheta, numIterations);
phis = linspace(0, scale*dPhi*height, numIterations);

%% observation point
theta0 = 0.3*scale;
phi0 = 0.3*height*scale;

%% observation function
g = @(theta, phi) min(scale - mod(theta-theta0,scale), mod(theta-theta0,scale)) + min(scale*height - mod(phi-phi0,scale*height), mod(phi-phi0,scale*height));

x = g(thetas, phis);
y = g(mod(thetas + scale/2, scale),mod(-phis, scale*height));

dim = 100;
Tau = floor(b/dim);
dT = 1;
SW = getSlidingWindow(x, dim, Tau, dT);
SWT = getSlidingWindow(y, dim, Tau, dT);

v0 = SW(1,:);

tslen = length(SW(:,1));

%ts = x;

%% dot product
gSW = SW*v0';
gSWT = SWT*v0';

ts = min(gSW,gSWT);
%%
%% dist from pt
% gSW = zeros(tslen);
% gSWT = zeros(tslen);
% 
% for ii=1:tslen
%     gSW(ii) = norm(SW(ii)-v0);
%     gSWT(ii) = norm(SWT(ii)-v0);
% end
%%

X = getSlidingWindow(ts, dim, Tau, dT*tslen/numIterations);
Y = getPCA(X);
X = getGreedyPerm(X, 300);

%% Compute PH of the embedding

disp('Doing TDA (mod 2)...');
DX = getSSM(X);
IsSliding2 = ripserDM(DX, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DX, 3, 2);

figure(2);
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
