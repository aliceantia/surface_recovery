addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

%% Define system

d = 5000;
dTheta = sqrt(5);
height = 2;
dy = 2*height/d;

%dynamics
psi = @(theta, y) [mod(theta + dTheta, 1), y + dy];

%change this
theta0 = .5;
y0 = height/2;

g = @(theta, y) abs(y - y0) + min(abs(theta - theta0), 1 - abs(theta - theta0));

obsfn = @(theta, y) min(g(theta, y), g(mod(theta+.5, 1), sign(y)*height + sign(y)*abs(sign(y)*height-y)));


 %number of iterations of dynamics

Z = zeros(2,d+1);
Psi = zeros(1,d+1);
thetacurr = 0;
ycurr = -height;
for ii = 1:d+1
    Z(1,ii) = thetacurr;
    Z(2,ii) = ycurr;
    Psi(ii) = obsfn(thetacurr, ycurr);
    res = psi(thetacurr, ycurr); %Iterate
    thetacurr = res(1);
    ycurr = res(2);
end


dim = 20;
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