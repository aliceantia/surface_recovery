addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');
addpath('../sw_distortion');

N_sampling = 12;
phis = linspace(0,pi, N_sampling);
thetas = linspace(0,2*pi, N_sampling);
[x,y] = meshgrid(phis,thetas);
path = [x(:),y(:)];
[~,dM]  = getDistanceMatrix(path,path,@dKleinL1);
dM = dM + dM';
disp("doing mod 2");
result2 = ripserDM(dM, 2, 2);
disp("doing mod 3");
result3 = ripserDM(dM, 3, 2);
% 
% subplot(321);
% plotBarcodes(result2{1}, 6);
% title('H0 Phi (mod 2)');
scale = pi/(N_sampling-1) + 0.05;
scale = 0;
subplot(221);
plotBarcodes(clean_bars(result2{2}, scale),3);
title('H1 Phi (mod 2)');
subplot(222);
plotBarcodes(clean_bars(result2{3}, scale),3);
title('H2 Phi (mod 2)');

% subplot(322);
% plotBarcodes(result3{1}, 6);
% title('H0 Phi (mod 3)');
subplot(223);
plotBarcodes(clean_bars(result3{2}, scale),3);
title('H1 Phi (mod 3)');
subplot(224);
plotBarcodes(clean_bars(result3{3}, scale),3);
title('H2 Phi (mod 3)');