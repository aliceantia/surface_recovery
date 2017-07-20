addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

%% Define system

dTheta = sqrt(2);
dPhi = sqrt(5);

%Move around torus
psi = @(theta, phi) [mod(theta + dTheta, 1), mod(phi + dPhi, 1)];  

%Define observation function as distance to some arbitrary point (theta0,
%phi0)
%modify to be distance along a klein bottle
theta0 = 0.1;
phi0 = 0.2;
obsfn = @(theta, phi) ...
    min(abs(theta - theta0), 1 - abs(theta - theta0)) +...
    min(abs(phi - phi0), 1 - abs(phi - phi0));

d = 3000; %number of iterations of dynamics

Z = zeros(2,d+1);
Psi = zeros(1,d+1);
thetacurr = 0;
phicurr = 0;
for ii = 1:d+1
    Z(1,ii) = thetacurr;
    Z(2,ii) = phicurr;
    Psi(ii) = obsfn(thetacurr, phicurr);
    res = psi(thetacurr, phicurr); %Iterate
    thetacurr = res(1);
    phicurr = res(2);
end

x = Psi;

dim = 6;
Tau = 1;
dT = 1;
SW = getSlidingWindow(x, dim, Tau, dT);

obspt = SW(1,:);

temp = size(SW(:,1));
M = temp(1);
y = zeros(M);
for ii=1:M
    y(ii) = norm(obspt-SW(ii,:));
end

X = getSlidingWindow(y, dim, Tau, dT);

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
C = plotTimeColors(1:length(y), y, 'type', '2DLine');
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
