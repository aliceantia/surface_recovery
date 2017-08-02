%% Alg to detect klein bottle persistence
function k = kleinBottlePersistence(H1_Z2, H2_Z2, H1_Z3)
% Get Max H2
persistences = H2_Z2(:,2) - H2_Z2(:,1);
[~,I] = max(persistences);
max_H2_Z2_bar= H2_Z2(I,:)
% find H1 classes that are alive during this time
filter = H1_Z2(:,1) < max_H2_Z2_bar(2) & H1_Z2(:,2) > max_H2_Z2_bar(1);
alive_H1_bars = H1_Z2(filter,:);
[~,I] = sort(alive_H1_bars(:,2) - alive_H1_bars(:,1), 'descend')
if size(I) < 2 
    k = 0;
    return;
end

alive_H1_bars = alive_H1_bars(I,:)
overlap_bar = [max(alive_H1_bars(1,1), alive_H1_bars(2,1)), min(alive_H1_bars(1,2), alive_H1_bars(2,2))]
overlap_bar = [max(overlap_bar(1),max_H2_Z2_bar(1)), min(overlap_bar(2), max_H2_Z2_bar(2))];
k=  max(0, overlap_bar(2) -overlap_bar(1));
