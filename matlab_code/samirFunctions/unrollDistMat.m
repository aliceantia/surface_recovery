function V = unrollDistMat(dm)
n = length(dm);
V = dm(triu(true(n),-1));
