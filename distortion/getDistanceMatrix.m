function [SWd, Md] = getDistanceMatrix(path, SW, dM)
    %add check that length of path and SW are same
    n=length(SW(:,1));
    SWd = zeros(n);
    Md = zeros(n);
    for ii= 1:n
        for jj = ii+1:n
            SWd(ii, jj) = sqrt(sum(SW(ii, :) - SW(jj, :).^2));
            Md(ii, jj) = dM(path(ii, :), path(jj, :));
        end
    end
end