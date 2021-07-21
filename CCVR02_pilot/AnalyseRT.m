format bank % Removes scientific notation

%other variables
binNumber = 6; % number of bins, must be a factor of 18
binSize = 18/binNumber; % has to result in an integer
textFiles = dir('*.txt'); % info for all the .txt files in the directory 
numFiles = length(textFiles); % number of text files in the directory

% these arrays are for storing the averages
phase1Block = zeros(numFiles, 2, binNumber); % Phase 1 data
phase1BlockSplit = zeros(numFiles, 4, binNumber); % Phase 1 data split into target front and target back patterns
phase2Ovr = zeros(numFiles, 6); % Phase 2 data
basicData = zeros(numFiles, 4); % basic detail (subNum, mean RT, mean number of responses)

% for all the .txt files in the folder, extract the reaction time data
for subNum = 1:numFiles
    
    data = importdata(textFiles(subNum).name); % import data from a .txt file

    % basic detail (subNum, mean RT, mean number of responses)
    meanRT = mean(data(:,5),1);
    meanNumResp = mean(data(:,6),1);
    tcomp = size(data,1);

    data = data(data(:,5)<10,:); % removes trials with RT longer than 10 seconds
    data = data(data(:,6)==0,:); % removes trials with multiple responses

    % calculate and remove outliers
    stdRT = std(data(:,5),1);
    data = data(data(:,5)<=meanRT+2*stdRT,:);
    data = data(data(:,5)>=meanRT-2*stdRT,:);
    
    % write basic data to file (subNum, mean RT, mean number of responses, trials completed, prop. trials analysed)
    basicData(subNum,:) = [meanRT meanNumResp tcomp size(data,1)/tcomp];
    
    data(:,1) = data(:,1) + 1; % coding of blocks starts at 1 rather than 0.
    
    % Phase 1
    bNum = 0;
    for b = 1:binSize:18

        bNum = bNum + 1;

        % isolate the data for that bin
        temp = data(data(:,1)>=b,:); 
        temp = temp(temp(:,1)<=b+(binSize-1),:);

        % means for repeating and random patterns
        phase1Block(subNum, 1, bNum) = mean(temp(ismember(temp(:,2),1:8),5));
        phase1Block(subNum, 2, bNum) = mean(temp(ismember(temp(:,2),9:16),5));
        
        % split into target front/back
        phase1BlockSplit(subNum, 1, bNum) = mean(temp(ismember(temp(:,2),1:4),5)); % rep target front
        phase1BlockSplit(subNum, 2, bNum) = mean(temp(ismember(temp(:,2),5:8),5)); % rep target back
        phase1BlockSplit(subNum, 3, bNum) = mean(temp(ismember(temp(:,2),9:12),5)); % rand target front
        phase1BlockSplit(subNum, 4, bNum) = mean(temp(ismember(temp(:,2),13:16),5)); % rand target back
        
    end
    
    % Phase 2
    data = data(data(:,1)>18,:);
    phase2Ovr(subNum, 1) = mean(data(ismember(data(:,2),1:4),5)); % repeating target front (random elements on front)
    phase2Ovr(subNum, 2) = mean(data(ismember(data(:,2),5:8),5)); % repeating target front (random elements on back)
    phase2Ovr(subNum, 3) = mean(data(ismember(data(:,2),9:12),5)); % repeating target back (random elements on front)
    phase2Ovr(subNum, 4) = mean(data(ismember(data(:,2),13:16),5)); % repeating target back (random elements on back)
    phase2Ovr(subNum, 5) = mean(data(ismember(data(:,2),17:20),5)); % random target front 
    phase2Ovr(subNum, 6) = mean(data(ismember(data(:,2),21:24),5)); % random target back

end

% arrange data arrays in format for output to excel
results.Phase1 = [(1:numFiles)' squeeze(phase1Block(:,1,:)) squeeze(phase1Block(:,2,:)) ];
results.Phase1Split = [(1:numFiles)' squeeze(phase1BlockSplit(:,1,:)) squeeze(phase1BlockSplit(:,2,:)) squeeze(phase1BlockSplit(:,3,:)) squeeze(phase1BlockSplit(:,4,:)) ];
results.Phase2 = [(1:numFiles)' phase2Ovr];
results.Basic = [(1:numFiles)' basicData];
    
clearvars -except results %clears the workspace except the results variable
