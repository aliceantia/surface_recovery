addpath('../../matlab_code/GeometryTools');
addpath('../../matlab_code/ripser');
addpath('../../matlab_code/TDETools');
addpath('../../matlab_code/samirFunctions');
addpath('../../sw_distortion');

%a = 0:0.1:5; %set parameter range
tau = 1:5;
data = cell(6, length(tau));


for ii=1:length(tau)
   tic
   [ts, path, IsSliding2, IsSliding3, dim, Tau, A] = f_getData(0, tau(ii));
   data{1, ii} = ts;
   data{2, ii} = path; 
   data{3, ii} = IsSliding2;
   data{4, ii} = IsSliding3;
   data{5, ii} = dim;
   data{6, ii} = Tau;
   data{7, ii} = A;
   toc
end

softMinApproxResults3 = data; %change this to change name of data set then export 
%to results and update param.txt


