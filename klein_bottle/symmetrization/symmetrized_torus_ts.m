addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

%% Define system

height = 1;
scale = 2*pi;

numPeriods = 100; %increase for shallower angle

b = 100; %period size. increase for more points

a = b*numPeriods; %time steps

thetas = linspace(0, scale*numPeriods*sqrt(5), a);
phis = linspace(0, scale*height, a);

v0 = [1,1, 1, 1];
T = [-1, -1, 1, -1];

% theta0 = 0.3;
% phi0 = 0.3*height;

%% cylinder code

% d_cyl = @(theta, phi) min(1- mod(abs(theta - theta0),1), mod(abs(theta-theta0),1))+ abs(phi-phi0);
% g = @(theta, phi) min(d_cyl(theta + 0.5, -phi), d_cyl(theta + 0.5, 2*height - phi));

%%

g = @(theta, phi) min(1 - mod(theta-theta0,1), mod(theta-theta0,1)) + min(height - mod(phi-phi0,height), mod(phi-phi0,height));
g = @(theta, phi) v0*[cos(theta);sin(theta);2*cos(phi);2*sin(phi)];
% gT = @(theta, phi) v0*([cos(theta);sin(theta);cos(phi);sin(phi)].*T');

obsfn = @(theta, phi) g(theta,phi);
% obsfn = @(theta, phi) min(g(theta,phi), d_cyl(theta,phi));
% obsfn = @(theta, phi) g(theta,phi).^2+g(theta,phi).*gT(theta,phi)+gT(theta,phi).^2;

% x = obsfn(thetas, phis);

% dim = 100;
% Tau = 1;
% dT = 1;
% X = getSlidingWindow(x, dim, Tau, dT);

% X = [cos(thetas);sin(thetas);2*cos(phis);2*sin(phis)]';

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

% subplot(321);
% C = plotTimeColors(1:length(x), x, 'type', '2DLine');
% title('SSM Original');
% 
% subplot(322);
% Y = Y(:, 1:3); %Go down to 3D PCA
% C = C(1:size(Y, 1), :);
% scatter3(Y(:, 1), Y(:, 2), Y(:, 3), 20, C(:, 1:3), 'fill');
% title('PCA Phi');

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
