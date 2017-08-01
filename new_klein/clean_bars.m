function b = clean_bars(bars, scale)
c = (bars(:,2) - bars(:,1)) >= scale;
b = [bars(c,1), bars(c,2)];
end