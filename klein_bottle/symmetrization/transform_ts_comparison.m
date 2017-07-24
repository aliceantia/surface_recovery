addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system

dTheta = sqrt(2);
dPhi = sqrt(5);

scale = 1;

height = .2; %decrease for shallower angle. risky because ripser can't see the identification

numPeriods = 100; %increase for shallower angle

b = 100; %period size. increase for more points

numIterations = numPeriods*b;

thetas = linspace(0, scale*numPeriods*dTheta, numIterations);
phis = linspace(0, scale*dPhi*height, numIterations);

%% observation point
theta0 = 0.3*scale;
phi0 = 0.3*height*scale;

%% observation function
g = @(theta, phi) min(scale - mod(theta-theta0,scale), mod(theta-theta0,scale)) + min(scale*height - mod(phi-phi0,scale*height), mod(phi-phi0,scale*height));

x = g(thetas, phis);
y = g(mod(thetas + scale/2, scale),mod(-phis, scale*height));

dim = 100;
Tau = floor(b/dim);
dT = 1;
SW = getSlidingWindow(x, dim, Tau, dT);
SWT = getSlidingWindow(y, dim, Tau, dT);

v0 = SW(1,:);

tslen = length(SW(:,1));

%ts = x;

%% dot product
gSW = SW*v0';
gSWT = SWT*v0';

ts = min(gSW,gSWT);

PQ = fft(x); %Power Spectral Density
% PQ = PQ(1:ceil(length(x)/2));

PH = fft(y); %Power Spectral Density
% PH = PH(1:ceil(length(y)/2));
%%
%% dist from pt
% gSW = zeros(tslen);
% gSWT = zeros(tslen);
% 
% for ii=1:tslen
%     gSW(ii) = norm(SW(ii)-v0);
%     gSWT(ii) = norm(SWT(ii)-v0);
% end
%%
% 
% X = getSlidingWindow(ts, dim, Tau, dT*tslen/numIterations);
% Y = getPCA(X);
% X = getGreedyPerm(X, 300);

%% Compute PH of the embedding

% disp('Doing TDA (mod 2)...');
% DX = getSSM(X);
% IsSliding2 = ripserDM(DX, 2, 2);
% disp('Doing TDA (mod 3)...');
% IsSliding3 = ripserDM(DX, 3, 2);

figure(1);
clf;

subplot(221);
plotTimeColors(1:length(gSW), gSW, 'type', '2DLine');
title('Original TS');

subplot(222);
plotTimeColors(1:length(gSWT), gSWT, 'type', '2DLine');
title('transformed TS');

subplot(223);
plotTimeColors(1:length(ts), ts, 'type', '2DLine');
title('symmetrized TS');

figure(2);
clf;
plot(PH);
hold on;
plot(PQ);
title('Power Spectral Densities');
ylabel('Energy (dB)');
xlabel('Frequency Index');
legend({'fh', 'fq'});
set(gcf, 'Position', [0, 0, 600, 400]);


