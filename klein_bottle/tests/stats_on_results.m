addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');
addpath('../../matlab_code/samirFunctions');
addpath('../../sw_distortion');


%load dataset before running this
data = softMinApproxResults3;

data_size = size(data);
data_size = data_size(2);
%check params.txt for these settings
dT = 1;
scale = 2*pi; % scale is always 2*pi


kleinPersistence = zeros(data_size, 1);
distortion = zeros(data_size, 1);

for ii=1:data_size %length of run
ii

% extract the data
ts = data{1, ii};
path = data{2, ii};
IsSliding2 = data{3, ii};
IsSliding3 = data{4, ii};
dim = data{5, ii};
Tau = data{6, ii};


% compute klein bottle persistence
kleinPersistence(ii) = kleinBottlePersistence(IsSliding2{2}, IsSliding2{3}, IsSliding3{3})


% Reconstruct distance matrices
dTorusL2 = @(p1,p2) ...
    sqrt(min(abs(p1(1) - p2(1)), scale - abs(p1(1) - p2(1))).^2 ...
    + min(abs(p1(2) - p2(2)), scale - abs(p1(2) - p2(2))).^2);

minL2 =  @(p1, p2) min(dTorusL2(p1, p2),...
    dTorusL2(p1, [mod(p2(1)+scale/2, scale) mod(-p2(2), scale)]));

SW = getSlidingWindow(ts, dim, Tau, 1);

[SWd, Md] = getDistanceMatrix(path, SW,minL2);


distortion(ii) = computeDistortion(Md, SWd);
end

% CHANGE THISS!!!!!!! (data 6 or 7, depending on tau or a)
independent_variable = [data{6,:}];

subplot(1,2,1)
plot(independent_variable', kleinPersistence);
ylabel('klein persistence');

subplot(122)
plot(independent_variable', distortion);
ylabel('distortion');
