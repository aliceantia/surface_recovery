a = 0:0.05:1.4;
softMinApproxResults1 = cell(5, length(a));

for ii=1:length(a)
   a(ii)
   [ts, SWd, Md, IsSliding2, IsSliding3] = f_min_approx(a(ii));
   softMinApproxResults1{1, ii} = ts;
   softMinApproxResults1{2, ii} = SWd;
   softMinApproxResults1{3, ii} = Md;
   softMinApproxResults1{4, ii} = IsSliding2;
   softMinApproxResults1{5, ii} = IsSliding3;
end