function d = dKleinL1(p1, p2)
    d= min(dTorusL1(p1, p2), dTorusL1(p1, [(p2(1)+pi) (-p2(2))]));
end