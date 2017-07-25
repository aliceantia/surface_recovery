% Sphere trajectory generator
% Inputs: Ntotal, NPeriods, d (window size)

function [path, signal,sliding_window] = sphereSpiralTrajectory(NTotal, NPeriods, d, obsfn)
thetas = linspace(0, 2*pi*NPeriods, NTotal);
phis = linspace(-pi/2,pi/2, NTotal);

%Apply observation function to trajectory points to get a time series x
signal = zeros(NTotal, 1);
for ii = 1:NTotal
    signal(ii) = obsfn(thetas(ii), phis(ii));
end

path = [thetas; phis]';
sliding_window = getSlidingWindowNoInterp(signal, d);
