format bank % Removes scientific notation

%other variables
binNumber = 6; % number of bins, must be a factor of 20
binSize = 18/binNumber; % has to be integer
textFiles = dir('*.txt'); %info for all the .txt files in the directory 
numFiles = length(textFiles); % number of text files in the directory

%mean reaction time across bins (two blocks) for each participant for:
repOut = zeros(numFiles, binNumber); %repeated patterns
nonRepOut = zeros(numFiles, binNumber); % randomised/new patterns
basicData = zeros(numFiles,2);

% for all the .txt files in the folder, extract the reaction time data
for subNum = 1:numFiles
    
   data = importdata(textFiles(subNum).name); % import data from a .txt file
    
   data = data(1:288,:); % removes awareness
   
   % basic detail (subNum meanRT meanResponses)
   basicData(subNum,:) = [mean(data(:,5),1) mean(data(:,6),1)];
   
   data = data(data(:,5)<10,:); % removes trials with mutliple responses
   data = data(data(:,6)==0,:); % removes trials with mutliple responses

   % calculate and remove outliers
   meanRT = mean(data(:,5),1);
   stdRT = std(data(:,5),1);
   
   data = data(data(:,5)<=meanRT+3*stdRT,:);
   data = data(data(:,5)>=meanRT-3*stdRT,:);
   
   data = data(data(:,6)==0,:); % removes trials with mutliple responses
   bNum = 0;
   
    for i = 1:binSize:18

        bNum = bNum + 1;

        % isolate the bin
        temp = data(data(:,1)>=i,:); 
        temp = temp(temp(:,1)<=i+(binSize-1),:);

        %average across the bin and put result in the array
        repOut(subNum, bNum) = mean(temp(temp(:,3)>0,5)); % for repeating patterns
        nonRepOut(subNum, bNum) = mean(temp(temp(:,3)==0,5)); % for new patterns

    end


end

%DEBUG: print the arrarys repOut and nonRepOut
results.RT = [(1:numFiles)' repOut nonRepOut]
results.Basic = [(1:numFiles)' basicData]

% %graph repOut and nonRepOut: Bin vs. RT
% plot (repOut(:,numFiles+1));
% hold
% plot(nonRepOut(:,numFiles+1))
% %Legend being difficult; temporary legend info
% '(blue = repeating, red = non repeating)'
    
clearvars -except results %clears the workspace except the results variable
