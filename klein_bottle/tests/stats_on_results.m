addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');
addpath('../../matlab_code/samirFunctions');
addpath('../../sw_distortion');


%load dataset before running this

data = softMinApproxResults3;


%parameters in run
a = 0.1:0.1:2;

kleinPersistence = zeros(length(a), 1);
distortion = zeros(length(a), 1);

for ii=1:length(a) %length of run
ii

%get klein persistence for results
IsSliding2 = data{4, ii};
IsSliding3 = data{5, ii};

kleinPersistence(ii) = kleinBottlePersistence(IsSliding2{2}, IsSliding2{3}, IsSliding3{3});

%compute distortion for results
SWd = data{2, ii};
Md = data{3, ii};

distortion(ii) = computeDistortion(Md, SWd);
end

subplot(1,2,1)
plot(a', kleinPersistence);
ylabel('klein persistence');

subplot(122)
plot(a, distortion);
ylabel('distortion');
