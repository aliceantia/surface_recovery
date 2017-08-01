% Sphere dynamics with antipodally symmetric observation function
addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

NTotal = 600;
NPeriods = 30;

uE = @(t) -t^2 -t +2;
lE = @(t) t^2 -t -2;

inside = @(t) sin(NPeriods*t) + 0.8*sin(2*NPeriods*t);
fun = @(t) (uE(t)-lE(t))/2*inside(t) + (uE(t)+lE(t))/2;


t=linspace(-sqrt(2), sqrt(2), NTotal);

x = zeros(NTotal, 1);
for ii=1:NTotal
    x(ii)=fun(t(ii));
end

X = getSlidingWindowNoInterp(x, NTotal/30);
Z = getPCA(X); %Perform PCA on sliding window embedding
Y = getGreedyPerm(X, 300); % fps on embedding point cloud

disp('computing rips mod 2 on original...');
Is2 = ripserPC(Y, 2, 2);
H1_2 = Is2{2};
H2_2 = Is2{3};

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