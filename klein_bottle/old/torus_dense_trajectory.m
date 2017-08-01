addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system

dTheta = .05;
dPhi = sqrt(2)*dTheta/100;

%Move around torus
psi = @(theta, phi) [mod(theta + dTheta, 1), mod(phi + dPhi, 1)];  


%define distance function on torus
dTorus = @(theta1, phi1, theta2, phi2) ...
    min(abs(theta1 - theta2), 1 - abs(theta1 - theta2)) +...
    min(abs(phi1 - phi2), 1 - abs(phi1 - phi2));
%Define observation function as distance to some arbitrary point (theta0,
%phi0)
theta0 = 0.1;
phi0 = 0.2;
obsfn = @(theta, phi) ...
    dTorus(theta, phi, theta0, phi0);

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

dim = 8;
Tau = 1;
dT = 1;
Psi = getSlidingWindow(Psi, dim, Tau, dT);
Y = getPCA(Psi);
Psi = getGreedyPerm(Psi, 400);

%% Compare PH of the original samples to PH of the embedding
DPsi = getSSM(Psi);
IsPsi = ripserDM(DPsi, 3, 2);

clf;

subplot(221);
plotDGM(IsPsi{2});
title('H1 Psi');

subplot(223);
plotDGM(IsPsi{3});
title('H2 Psi');

subplot(222);
plot3(Y(:, 1), Y(:, 2), Y(:, 3), '.');
plotTimeColors(1:size(Y, 1), Y, 'type', '3DPC');
axis equal;
title('PCA Psi');

subplot(224);
c= linspace(1,20,length(Z(1,:)));
scatter(Z(1,:), Z(2, :), [], c);
title('plot');