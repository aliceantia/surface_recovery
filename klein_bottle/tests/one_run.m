addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');
addpath('../../matlab_code/samirFunctions');
addpath('../../sw_distortion');


a=1;

b=50;
dim = 2*b;
Tau = 4;
dT = 1;

[ts, SWd, Md, IsSliding2, IsSliding3]=f_getData(a,4);

computeDistortion(Md,SWd)

SWd = unrollDistMat(SWd);
Md = unrollDistMat(Md);

SW = getSlidingWindow(ts, dim, Tau, dT);
Y = getPCA(SW);
%D = SWd./Md;
clf;
%make plots
subplot(321);
C = plotTimeColors(1:length(ts), ts, 'type', '2DLine');
%title('SSM Original');

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

