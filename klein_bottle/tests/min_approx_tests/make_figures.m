addpath('../../../matlab_code/GeometryTools');
addpath('../../../matlab_code/ripser');
addpath('../../../matlab_code/TDETools');
addpath('../../../matlab_code/samirFunctions');
addpath('../../../sw_distortion');

%load dataset before running this

%check params.txt for these settings
b=50;
dim = 2*b;
Tau = 4;
dT = 1;
SW = getSlidingWindow(ts, dim, Tau, dT);

a = -0.1:0.05:1.2;

for ii=1:length(a) %length of run
ii

ts = softMinApproxResults1{1, ii};
SWd = softMinApproxResults1{2, ii};
Md = softMinApproxResults1{3, ii};
IsSliding2 = softMinApproxResults1{4, ii};
IsSliding3 = softMinApproxResults1{5, ii};

clf;

SWd = unrollDistMat(SWd);
Md = unrollDistMat(Md);

Y = getPCA(SW);
subplot(3,2,1);
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

name = join(['softMinApproxResults1_', num2str(ii), '.png']);
saveas(gcf, name);
name = join(['softMinApproxResults1_', num2str(ii)]);
saveas(gcf, name);
end