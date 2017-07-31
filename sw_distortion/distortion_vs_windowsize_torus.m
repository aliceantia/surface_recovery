addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');
addpath('../matlab_code/samirFunctions');


%% Define system

dTheta = 0.1*sqrt(2);
dPhi = 0.1*sqrt(5);

%Move around torus
psi = @(theta, phi) [mod(theta + dTheta, 1), mod(phi + dPhi, 1)];  


%define distance function on torus
dTorus = @(p1, p2) ...
    min(abs(p1(1) - p2(1)), 1 - abs(p1(1) - p2(1))) +...
     min(abs(p1(2) - p2(2)), 1 - abs(p1(2) - p2(2)));
%Define observation function as distance to some arbitrary point (theta0,
%phi0)
theta0 = 0.1;
phi0 = 0.2;
obsfn = @(theta, phi) ...
    dTorus([theta phi], [theta0 phi0]);

d = 400; %number of iterations of dynamics

Z = zeros(d+1, 2);
Psi = zeros(1,d+1);
thetacurr = 0;
phicurr = 0;
for ii = 1:d+1
    Z(ii,1) = thetacurr;
    Z(ii,2) = phicurr;
    Psi(ii) = obsfn(thetacurr, phicurr);
    res = psi(thetacurr, phicurr); %Iterate
    thetacurr = res(1);
    phicurr = res(2);
end

range = 20;
starting_d = 4;
distortions = zeros(1,range);
for ii = 1:range
    ii
    Sw = getSlidingWindowNoInterp(Psi, starting_d+ii -1);
    [SWd, Md] = getDistanceMatrix(Z, Sw, dSphere);
    distortions(ii) = computeDistortion(Md,SWd);
end


X = unrollDistMat(SWd);
Y = unrollDistMat(Md);

d_s = linspace(starting_d, starting_d + range -1, range);
subplot(121)
plot(d_s, distortions);
subplot(122)
plot(Y,X, '.', 'markersize', 5)
