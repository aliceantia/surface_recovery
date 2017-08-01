addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');






T = 100;
NPeriods = 2;
N = T*NPeriods;
t = linspace(0, 2*pi*NPeriods, N);

y1 = cos(t) + cos(t/1000);
Y1 = getSlidingWindowNoInterp(y1, T);

Z1 = getPCA(Y1);

subplot(241);
C = plotTimeColors(1:N, y1, 'type', '2DLine');
title('0.8cos(t) + 0.6cos(2t)');
subplot(242);
scatter3(Z1(:, 1), Z1(:, 2), Z1(:, 3), 20, C(1:size(Z1, 1), 1:3), 'fill');
title('Sliding Window PCA');


H11_2 = ripserPC(Y1, 2, 1); H11_2 = H11_2{2};
H11_3 = ripserPC(Y1, 3, 1); H11_3 = H11_3{2};

subplot(243);
plotDGM(H11_2);
title('Z2 Coefficients');
subplot(244);
plotDGM(H11_3);
title('Z3 Coefficients');

