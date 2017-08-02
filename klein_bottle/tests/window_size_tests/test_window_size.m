windowSizeResults1 = cell(5, 20);
for tau=1:20
   tau
   [ts, SWd, Md, IsSliding2, IsSliding3] = f_windowSize(tau);
   windowSizeResults1{1, tau} = ts;
   windowSizeResults1{2, tau} = SWd;
   windowSizeResults1{3, tau} = Md;
   windowSizeResults1{4, tau} = IsSliding2;
   windowSizeResults1{5, tau} = IsSliding3;
end
