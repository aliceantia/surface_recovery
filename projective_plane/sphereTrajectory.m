function  [theta, phi] = sphereTrajectory(type, t, a, theta0, phi0)

%set some defauls arguments
if nargin < 3
    a = 1;
end
if nargin < 5
    theta0 = -pi/2;
    phi0 = 0;
end
%set type
if type == "lissajous"
        theta = theta0 + t;
        phi = phi0 + 2*a*t;
end
end
