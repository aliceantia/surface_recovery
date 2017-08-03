function [ts, SWd, Md, IsSliding2, IsSliding3] = f_getData(a, tau)
%Idea as p -> infty min(a,b) = (a+b) - (a^p + b^p)^(1/p)
p = 30;


useDiffusionMap = false;
k=20;

%% Define trajectory
scale = 2*pi; %scale is always 2 pi
height = 1/2; %decrease for shallower angle. risky because ripser can't see the identification
numPeriods = 50; %increase for shallower angle
b = 100; %samller period size. increase for more points
numIterations = numPeriods*b;

thetas = linspace(0, scale*numPeriods, numIterations);
phis = linspace(0, scale*height, numIterations);


%% distance/some function on torus and klein
%  L1
dTorusL1 = @(p1, p2) ...
    min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))) ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2)));

minL1 = @(p1, p2) min(dTorusL1(p1, p2), ...
    dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));

pMinApproxL1= @(p1, p2) dTorusL1(p1, p2) ...
    + dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    - (dTorusL1(p1, p2)^p ...
    + dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])^p)^(1/p);

softMinApproxL1 = @(p1, p2) (dTorusL1(p1, p2)*exp(-a*dTorusL1(p1, p2)) ...
    + dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    *exp(-a*dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]))) ...
    /(exp(-a*dTorusL1(p1, p2))...
    + exp(-a*dTorusL1(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])));
% L2
dTorusL2 = @(p1,p2) ...
    sqrt(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))).^2 ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))).^2);

minL2 =  @(p1, p2) min(dTorusL2(p1, p2),...
    dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));

pMinApproxL2= @(p1, p2) dTorusL2(p1, p2) ...
    + dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    - (dTorusL2(p1, p2)^p ...
    + dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])^p)^(1/p);

softMinApproxL2 = @(p1, p2) (dTorusL2(p1, p2)*exp(-a*dTorusL2(p1, p2)) ...
    + dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    *exp(-a*dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]))) ...
    /(exp(-a*dTorusL2(p1, p2))...
    + exp(-a*dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])));

% cos
torusCos = @(p1, p2) ...
    cos(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))))...
    + cos(min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))));

softMinApproxCos = @(p1, p2) (torusCos(p1, p2)*exp(-a*torusCos(p1, p2)) ...
    + torusCos(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    *exp(-a*torusCos(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]))) ...
    /(exp(-a*torusCos(p1, p2))...
    + exp(-a*torusCos(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])));

%% observation function
obsfn = minL1; %choose a function

theta0 = 0.3*scale;
phi0 = 0.3*height*scale;

g = @(theta, phi) obsfn([theta phi], [theta0 phi0]);

ts=zeros(1,numIterations);

for ii=1:numIterations
    ts(ii) = g(mod(thetas(ii), scale), mod(phis(ii), scale));
end

dim = 100;
Tau = tau;
dT = 1;
SW = getSlidingWindow(ts, dim, Tau, dT);

%% Distortion
path = horzcat(mod(thetas, scale)', mod(phis, scale)');
[SWd, Md] = getDistanceMatrix(path, SW, minL2);

%% do TDA
if useDiffusionMap
    SW = getDiffusionMap(getSSM(SW), k);
end
SW = getGreedyPerm(SW, 300);
disp('Doing TDA (mod 2)...');
DSW = getSSM(SW);
IsSliding2 = ripserDM(DSW, 2, 2);
disp('Doing TDA (mod 3)...');
IsSliding3 = ripserDM(DSW, 3, 2);

end