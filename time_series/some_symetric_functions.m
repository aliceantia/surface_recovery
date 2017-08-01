addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

T = 25;
NPeriods = 70;
N = T*NPeriods;
t = linspace(-2*pi, 2*pi, N);
a = 1;

w1= sqrt(2);
w2=sqrt(3)/100;
phi=2;
n=40;

wave1= @(t) cos(w1*t) +cos(-w2*t) + ...
    cos((w1 +w2)*t) - cos((w1 - w2)*t);

wave2=@(t) abs(sin(t)*sin(phi)+cos(n*t+1)) + cos(t)*cos(phi);

wave3=@(t) cos(25*sqrt(2)*t) + cos(2*acot(exp(-t)));

wave4=@(t) 4*cos(25*sqrt(2)*t)*cos(2*acot(exp(-t)));

y=zeros(1, N);
for ii=1:N
    y(:, ii) = wave4(t(1,ii));
end



Y = getSlidingWindowNoInterp(y, T);
Z = getPCA(Y);
Y = getGreedyPerm(Y, 300);

disp('computing rips mod 2...');
Is2 = ripserPC(Y, 2, 2);
H1_2 = Is2{2};
H2_2 = Is2{3};

disp('computing rips mod 3 ...');
Is3 = ripserPC(Y, 3, 2);
H1_3 = Is3{2};
H2_3 = Is3{3};


figure
subplot(221);
C = plotTimeColors(1:N, y, 'type', '2DLine');
title('');
subplot(222);
scatter3(Z(:, 1), Z(:, 2), Z(:, 3), 20, C(1:size(Z, 1), 1:3), 'fill');
title('Sliding Window PCA');


subplot(223);
plotDGM(H1_2);
plotDGM(H2_2, 'red', 'd');
title('Z2 Coefficients');

subplot(224);
plotDGM(H1_3);
plotDGM(H2_3, 'red', 'd');
title('Z3 Coefficients');
