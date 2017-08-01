function d = dTorusL1(p1, p2)
    p1(1) = mod(p1(1), 2*pi);
    p1(2) = mod(p1(2), 2*pi);
    p2(1) = mod(p2(1), 2*pi);
    p2(2) = mod(p2(2), 2*pi);
    d=min(abs(p1(1) - p2(1)), 2*pi - abs(p1(1) - p2(1))) ...
        + min(abs(p1(2) - p2(2)), 2*pi - abs(p1(2) - p2(2)));
end