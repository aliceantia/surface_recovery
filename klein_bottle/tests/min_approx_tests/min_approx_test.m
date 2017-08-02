softMinApproxResults1 = cell(5, 27);
for a=-0.1:0.05:1.2
   a
   [ts, SWd, Md, IsSliding2, IsSliding3] = f_min_approx(a);
   softMinApproxResults1{1, a} = ts;
   softMinApproxResults1{2, a} = SWd;
   softMinApproxResults1{3, a} = Md;
   softMinApproxResults1{4, a} = IsSliding2;
   softMinApproxResults1{5, a} = IsSliding3;
end