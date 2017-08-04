addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');
addpath('../../matlab_code/samirFunctions');
addpath('../../sw_distortion');

%load dataset before running this
data = softMinApproxResults3;

data_size = size(data);
data_size = data_size(2);
%check params.txt for these settings
dT = 1;
scale = 2*pi; % scale is always 2*pi


for ii=1:data_size %length of run
ii

ts = data{1, ii};
path = data{2, ii};
IsSliding2 = data{3, ii};
IsSliding3 = data{4, ii};
dim = data{5, ii};
Tau = data{6, ii};

%% Reconstruct distance matrices
dTorusL2 = @(p1,p2) ...
    sqrt(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))).^2 ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))).^2);

minL2 =  @(p1, p2) min(dTorusL2(p1, p2),...
    dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));

SW = getSlidingWindow(ts, dim, Tau, 1);

[SWd, Md] = getDistanceMatrix(path, SW,minL2);

clf;

SWd = unrollDistMat(SWd);
Md = unrollDistMat(Md);

SW = getSlidingWindow(ts, dim, Tau, dT);
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