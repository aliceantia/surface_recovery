% Sphere dynamics with antipodally symmetric observation function
addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

sphere2xyz = @(theta, phi) [cos(theta)*cos(phi), sin(theta)*cos(phi), sin(phi) ];

%% Define dynamical system
%Define observation function as cosine distance to some arbitrary point theta0
theta0 = 0.6;
phi0 = 0.3;

theta1 = 3;
phi1 = 0.5;

obsfn = @(theta, phi) sum(sphere2xyz(theta0, phi0).*sphere2xyz(theta, phi));
%Fill out a spiral trajectory on the sphere
NTotal = 600;
NPeriods = 30;
phis = linspace(-pi/2, pi/2, NTotal);
thetas = linspace(0, 2*pi*NPeriods, NTotal);

%Apply observation function to trajectory points to get a time series x
x = zeros(NTotal, 1);
X = zeros(NTotal, 3);
for ii = 1:NTotal
    x(ii) = obsfn(thetas(ii), phis(ii));
    X(ii, :) = sphere2xyz(thetas(ii), phis(ii));
end


%% Perform Sliding Window Embedding
%preform analysis on original time series
x = x.^3;
X = getSlidingWindowNoInterp(x, NTotal/NPeriods);
Z = getPCA(X); %Perform PCA on sliding window embedding
Y = getGreedyPerm(X, 300); % fps on embedding point cloud

disp('computing rips mod 2 on original...');
Is2 = ripserPC(Y, 2, 2);
H1_2 = Is2{2};
H2_2 = Is2{3};

disp('computing rips mod 3 on original ...');
Is3 = ripserPC(Y, 3, 2);
H1_3 = Is3{2};
H2_3 = Is3{3};

%% tansform time series and preform analysis
Tx=abs(x);
TX = getSlidingWindowNoInterp(Tx, NTotal/NPeriods);
TZ = getPCA(TX); %Perform PCA on sliding window embedding
TY = getGreedyPerm(TX, 300); % fps on embedding point cloud

disp('computing rips mod 2 on transformed...');
TIs2 = ripserPC(TY, 2, 2);
TH1_2 = TIs2{2};
TH2_2 = TIs2{3};

disp('computing rips mod 3 on transformed ...');
TIs3 = ripserPC(TY, 3, 2);
TH1_3 = TIs3{2};
TH2_3 = TIs3{3};


%% Plots for original time series
clf;
subplot(241);
C = plotTimeColors(1:NTotal, x, 'type', '2DLine');
title('');
subplot(242);
scatter3(Z(:, 1), Z(:, 2), Z(:, 3), 20, C(1:size(Z, 1), 1:3), 'fill');
title('Sliding Window PCA original times series');


subplot(243);
plotDGM(H1_2);
plotDGM(H2_2, 'red', 'd');
title('Z2 Coefficients');

subplot(244);
plotDGM(H1_3);
plotDGM(H2_3, 'red', 'd');
title('Z3 Coefficients');

%% Plots for transformed time series
subplot(245);
C = plotTimeColors(1:NTotal, Tx, 'type', '2DLine');
title('');
subplot(246);
scatter3(TZ(:, 1), TZ(:, 2), TZ(:, 3), 20, C(1:size(TZ, 1), 1:3), 'fill');
title('Sliding Window PCA original times series');


subplot(247);
plotDGM(TH1_2);
plotDGM(TH2_2, 'red', 'd');
title('Z2 Coefficients');

subplot(248);
plotDGM(TH1_3);
plotDGM(TH2_3, 'red', 'd');
title('Z3 Coefficients');