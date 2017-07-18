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
scatter(Z(1,:), Z(2, :));
title('plot');