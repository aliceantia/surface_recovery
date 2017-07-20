function [SWd, Md] = getDistanceMatrix(path, SW, dFunction)
    if length(SW(:,1)) ~= length(path(:,1))
        disp("path not same size as SW")
        disp("length SW")
        length(SW(:,1))
        disp("length path")
        length(path(:,1))
    end
    n=length(SW(:,1));
    SWd = zeros(n);
    Md = zeros(n);
    for ii= 1:n
        for jj = ii+1:n
            SWd(ii, jj) = sqrt(sum((SW(ii, :) - SW(jj, :)).^2));
            Md(ii, jj) = dFunction(path(ii, :), path(jj, :));
        end
    end
end