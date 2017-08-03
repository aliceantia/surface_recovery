function [ts, SWd, Md, IsSliding2, IsSliding3] = f_windowSize(tau)
addpath('../../../matlab_code/GeometryTools');
addpath('../../../matlab_code/ripser');
addpath('../../../matlab_code/TDETools');
addpath('../../../matlab_code/samirFunctions');
addpath('../../../sw_distortion');


%% Define trajectory
scale = 2*pi; %scale is always 2 pi
height = 1/2; %decrease for shallower angle. risky because ripser can't see the identification
numPeriods = 50; %increase for shallower angle
b = 50; %samller period size. increase for more points
numIterations = numPeriods*b;

thetas = linspace(0, scale*numPeriods, numIterations);
phis = linspace(0, scale*height, numIterations);


%% distance on torus and klein
%  L1
dTorusL1 = @(p1, p2) ...
    min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))) ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2)));

dKleinL1 = @(p1, p2) min(dTorusL1(p1, p2),...
    dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));
% L2 
dTorusL2 = @(p1,p2) ...
    sqrt(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))).^2 ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))).^2);
    
dKleinL2 =  @(p1, p2) min(dTorusL2(p1, p2),...
    dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));

%% observation function
theta0 = 0.3*scale;
phi0 = 0.3*height*scale;

g = @(theta, phi) dKleinL1([theta phi], [theta0 phi0]);

ts=zeros(1,numIterations);

for ii=1:numIterations
    ts(ii) = g(mod(thetas(ii), scale), mod(phis(ii), scale));
end

dim = 2*b;
Tau = tau;
dT = 1;
SW = getSlidingWindow(ts, dim, Tau, dT);

%Y = getPCA(SW);
%% Distortion
path = horzcat(mod(thetas, scale)', mod(phis, scale)');
[SWd, Md] = getDistanceMatrix(path, SW, dKleinL2);
toc
tic
%computeDistortion(Md,SWd)
toc
SWd = unrollDistMat(SWd);
Md = unrollDistMat(Md);

%D = SWd./Md;
%% do TDA
SW = getGreedyPerm(SW, 300);
disp('Doing TDA (mod 2)...');
DSW = getSSM(SW);
IsSliding2 = ripserDM(DSW, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DSW, 3, 2);