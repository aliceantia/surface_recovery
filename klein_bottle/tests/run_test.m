%a = 0:0.1:5; %set parameter range

tau = 1:20;
data = cell(5, length(tau));


for ii=1:length(tau)
   tic
%   a(ii)
   [ts, SWd, Md, IsSliding2, IsSliding3] = f_getData(0, tau(ii));
   data{1, ii} = ts;
   data{2, ii} = SWd;
   data{3, ii} = Md;
   data{4, ii} = IsSliding2;
   data{5, ii} = IsSliding3;
   toc
end

softMinApproxResults1 = data; %change this to change name of data set then export 
%to results and update param.txt


