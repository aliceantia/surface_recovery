function d = dSphere(p1,p2)
d= sqrt(sum((sphere2xyz(p1(1),p1(2)) -sphere2xyz(p2(1),p2(2))).^2));
