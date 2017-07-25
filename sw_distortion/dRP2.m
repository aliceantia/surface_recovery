function d = dRP2(p1,p2) 
d= min(sqrt(sum((sphere2xyz(p1(1),p1(2)) -sphere2xyz(p2(1),p2(2))).^2)) ...
                    ,sqrt(sum((sphere2xyz(p1(1)+pi,-p1(2)) -sphere2xyz(p2(1),p2(2))).^2)));
