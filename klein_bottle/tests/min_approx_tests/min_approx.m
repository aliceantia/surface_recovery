addpath('../../../matlab_code/GeometryTools');
addpath('../../../matlab_code/ripser');
addpath('../../../matlab_code/TDETools');
addpath('../../../matlab_code/samirFunctions');
addpath('../../../sw_distortion');



%%
%Idea as p -> infty min(a,b) = (a+b) - (a^p + b^p)^(1/p)
p = 30; 

%Idea soft max function set a
a=-.2;
%% Define trajectory
scale = 2*pi; %scale is always 2 pi
height = 1/2; %decrease for shallower angle. risky because ripser can't see the identification
numPeriods = 50; %increase for shallower angle
b = 50; %samller period size. increase for more points
numIterations = numPeriods*b;

thetas = linspace(0, scale*numPeriods, numIterations);
phis = linspace(0, scale*height, numIterations);


%% distance/some function on torus and klein
%  L1
dTorusL1 = @(p1, p2) ...
    min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))) ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2)));

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
    
pMinApproxL2= @(p1, p2) dTorusL2(p1, p2) ...
    + dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]) ...
    - (dTorusL2(p1, p2)^p ...
            + dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)])^p)^(1/p);
        
% cos 
torusCos = @(p1, p2) ...
    cos(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))))...
    + cos(min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))));

pMinApproxCos = @(p1, p2) ...
    cos(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))))...
    + cos(min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))));

%% observation function
obsfn = softMinApproxL1; %choose a function

theta0 = 0.3*scale;
phi0 = 0.3*height*scale;

g = @(theta, phi) obsfn([theta phi], [theta0 phi0]);

ts=zeros(1,numIterations);

for ii=1:numIterations
    ts(ii) = g(mod(thetas(ii), scale), mod(phis(ii), scale));
end

dim = 2*b;
Tau = 4;
dT = 1;
SW = getSlidingWindow(ts, dim, Tau, dT);

Y = getPCA(SW);
%% Distortion
path = horzcat(mod(thetas, scale)', mod(phis, scale)');
[SWd, Md] = getDistanceMatrix(path, SW, obsfn);

computeDistortion(Md,SWd)

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

%% Plots
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
plotDGM(IsSliding2{3}, 'red', 'd');
title('Z2 Coefficients');


subplot(324);
plotDGM(IsSliding3{2});
plotDGM(IsSliding3{3}, 'red', 'd');
title('Z3 Coefficients');

subplot(325)
scatter(Md, SWd, 2, 'filled');
title('Distortion');
xlabel('Distance on original surface');
ylabel('Distance in SW');

