addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');

%% Define system

scale = 2*pi;

N = 100;

thetas = linspace(0, scale, N);
phis = linspace(0, scale, N);

%% observation point
theta0 = 0;
phi0 = 0;

% theta0 = 0;
% phi0 = 0;

%% observation function
g = @(theta, phi) sqrt(min(scale - mod(abs(theta-theta0),scale), mod(abs(theta-theta0),scale)).^2 + min(scale - mod(abs(phi-phi0),scale), mod(abs(phi-phi0),scale)).^2);

gK = @(theta,phi) g(mod(theta+scale/2, scale), mod(-phi, scale));

[X, Y] = meshgrid(thetas,phis);

X = X(:);
Y = Y(:);

% x = g(thetas, phis);
% y = g(mod(thetas + scale/2, scale),mod(-phis, scale));

scatter(g(pi/2,Y), gK(pi/2,Y), '.');

% scatter(cos(X-theta0)+cos(Y), -cos(X-theta0)+cos(Y), '.');

