addpath('../matlab_code/GeometryTools');
addpath('../matlab_code/ripser');
addpath('../matlab_code/TDETools');

T = 25;
NPeriods = 25;
N = T*NPeriods;
t = linspace(0, 2*pi*NPeriods, N);
a = 0; %amplitude of ramp

%function for ramp a bottom of file

%here try different ways of incorperating the ramp function 
%add to change location - seem to make two tori
%multiply to change amplitude ect
wave= @(t, a) cos(sqrt(5)*t) + cos(sqrt(2)*t)+a*ramp(t, 1.3*T);

y=zeros(1, N);
for ii=1:N
    y(:, ii) = wave(t(1,ii), a);
end

Y = getSlidingWindowNoInterp(y, T);
Y = getGreedyPerm(Y, 300);
Z = getPCA(Y);

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

function[y]= ramp(t, T)
    if t<2*T
        y=0;
    elseif t<3*T
        y=t-2*T;
    else
        y=T;
    end
end