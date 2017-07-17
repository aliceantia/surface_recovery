addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

%% Define system

dTheta = 0.02;
dPhi =sqrt(2);

%Move around torus
psi = @(theta, phi) [mod(theta + dTheta, 1), mod(phi + dPhi, 1)];  

%Define observation function as distance to some arbitrary point (theta0,
%phi0)
%modify to be distance along a klein bottle
theta0 = 1;
phi0 = 2;
obsfn = @(theta, phi) ...
    min(abs(theta - theta0) + abs(phi - phi0), ...
    1 - abs(theta - theta0) + 1 - abs(phi - phi0))
    %min(abs(theta - theta0), 1 - abs(theta - theta0)) ...
    %+ min(abs(phi - phi0), 1 - abs(phi - phi0));


%% Run dynamics from a bunch of seed points
d = 50; %Number of iterations of dynamics
Nvert = 20; %Number of points for theta
xvert = linspace(0, 1, Nvert);
Nhorz = 20; %Number of points for phi
xhorz = linspace(0, 1, Nhorz);
%Make a grid of points on the cylinder
[thetas, phis] = meshgrid(xvert, xhorz);
%Flatten grid to 1D arrays for convenience
thetas = thetas(:);
phis = phis(:);

N = length(thetas); %Total number of points in grid
Psi = zeros(N, d+1);
for ii = 1:N
    thetacurr = thetas(ii);
    phicurr = phis(ii);
    for jj = 1:d+1
        Psi(ii, jj) = obsfn(thetacurr, phicurr);
        res = psi(thetacurr, phicurr); %Iterate
        thetacurr = res(1);
        phicurr = res(2);
    end
end

%% Compare PH of the original samples to PH of the embedding
Y = getPCA(Psi);
% DPsi = getSSM(Psi);
% IsPsi = ripserDM(DPsi, 2, 2);
% 
% subplot(221);
% plotDGM(IsPsi{2});
% title('H1 Psi');x
% 
% subplot(223);
% plotDGM(IsPsi{3});
% title('H2 Psi');

%subplot(222);
plot3(Y(:, 1), Y(:, 2), Y(:, 3), '.');
plotTimeColors(1:size(Y, 1), Y, 'type', '3DPC');
axis equal;
title('PCA Psi');