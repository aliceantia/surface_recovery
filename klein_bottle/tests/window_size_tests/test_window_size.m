for tau=1:20
   tau
   [ts, SWd, Md, IsSliding2, IsSliding3] = f_windowSize(tau);
   save(join(['tau' num2str(tau)]));
end
