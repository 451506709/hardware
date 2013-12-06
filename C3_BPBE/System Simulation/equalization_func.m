
% Cell Parameters
nominalCap = 3.1;       % amp-hour
esr = 0.08;             % ohms - assume constant for these purposes

% Pack Parameters
numCellsParallel = 14;  
numCellsSeries = 32;


cellcapacity = (randn(numCellsSeries,numCellsParallel)*.1+nominalCap);  
moduleCapacity = sum(cellcapacity')';

moduleCapacity = moduleCapacity .*1000.*3600; % amp-hr * 1000 (mA/A) * 3600 (sec/hr) = mA-sec

% Start with a fully charged pack
moduleSOC = moduleCapacity;

% Current profile to follow.  This should be replaced by actual current 
% profile. 10A continous.
current = ones(1,20000)*10000;   %mA, basic constant current profile.



energy = energy / 1000 / 3600;
total = sum(capacity) / 1000 / 3600 / numCellsSeries;

fprintf('Energy Extracted: %1.4f / %1.2f (%1.3f%%) amp-hours in %1.0f sec\n', ...
    energy,total,energy/total*100, seconds);

voltage = ones(32,1);
temp = ones(32,1)*25;
fans = ones(8,1);

