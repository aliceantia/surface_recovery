%% Alg to detect klein bottle persistence (how long does a klein bottle remain a klein bottle).
function k = kleinBottlePersistence(H1_Z2, H2_Z2, H2_Z3)

% Get the class in H2 Z2 that persists the longest
persistences = H2_Z2(:,2) - H2_Z2(:,1);
[~,I] = max(persistences);
max_H2_Z2_bar = H2_Z2(I,:);

% find H1 classes in Z2 that are alive during the max H2 class
filter = H1_Z2(:,1) < max_H2_Z2_bar(2) & H1_Z2(:,2) > max_H2_Z2_bar(1);
alive_H1_bars = H1_Z2(filter,:);

% find the longest two H1 classes during this time
[~,I] = sort(alive_H1_bars(:,2) - alive_H1_bars(:,1), 'descend')
if size(I) < 2 % there's not enough H1 classes to form a klein bottle
    k = 0;
    return;
end
alive_H1_bars = alive_H1_bars(I,:)

% Create a bar representing when a klein bottle could potentially be alive.
overlap_bar = [max(alive_H1_bars(1,1), alive_H1_bars(2,1)), min(alive_H1_bars(1,2), alive_H1_bars(2,2))];
overlap_bar = [max(overlap_bar(1),max_H2_Z2_bar(1)), min(overlap_bar(2), max_H2_Z2_bar(2))]

% Subtract off the longest H2 Z3 class that's still alive during this time.

% Edit the H2 Z3 bars such that the birth time is at least the birth time
% of overlap_bar, and death time is at most the death time of the
% overlap_bar
H2_Z3(:,1) = max(overlap_bar(1), H2_Z3(:,1));
H2_Z3(:,2) = min(overlap_bar(2), H2_Z3(:,2));
% Find max length (lengths may be negative) of the potentially
% "obstructing" edited H2 bars in Z3

max_obstruction = max(0,max( H2_Z3(:,2) -H2_Z3(:,1)) )

% Return length of overlap_bar minus longest obstruction.
k = max(0, overlap_bar(2) - overlap_bar(1) - max_obstruction);