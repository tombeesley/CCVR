function ConvertToCSV(patternSet, trialOrder, awareOrder, subject)
    % Constants
    SET_INDEX = 4;
    PATTERN_INDEX = 5;
    ROW_DIMENSION = 1;
    MIN_X = 1;
    MIN_Y = 1;
    MAX_X = 12;

    % The object holding the CSV data for all trials for a single
    % participant.
    trialsCSV = [];
    for trial = 1:size(trialOrder{1,1},ROW_DIMENSION)

        % Get the set number and the pattern number for this trial
        set = trialOrder{1,1}(trial,SET_INDEX);
        pattern = trialOrder{1,1}(trial,PATTERN_INDEX);
        
        % Handles the trailing zero rows (quits the program once they are
        % reached)
        if (set == 0 || pattern == 0)
            break
        end
        
        % Trials contain a variable number of stimuli (rows) with each stimuli
        % having six columns (x, y, radius, rotationType, colorType,
        % distractorType).
        trialCSV = [];
        
        % From the 3D array with dimensions (set, object, pattern),
        % extract the objects for the trial with that pattern and set
        trialData = patternSet{1,1}(set,:,pattern);
        
        % Convert i values (from 1 to 144) into x-values that are 
        % based off the 4-quadrant mapping used by Tom.
        
        % The first 72 i-vals range from X = 1 to X = 6 
        % and Y = 1 to Y = 12
        x = MIN_X; y = MIN_Y;
        initialX = MIN_X;
        for i = 1:72 
            % If there exists an object at the i'th location
            % convert it to the stimulus format (6 columns as mentioned
            % above) and add it to the CSV array
            if trialData(1,i) ~= 0
                trialCSV = [trialCSV; getStim(trialData(1,i), x, y)];
            end
            
            % Increment x
            x = x + 1;
            
            % If x is greater than 6, set x back to the beginning
            % and increment y
            if x > MAX_X/2
                x = initialX;
                y = y + 1;
            end
        end

        % The second 72-vals range from X = 7 to X = 12
        % and from Y = 1 to Y = 12
        x = MAX_X/2 + 1; y = MIN_Y;
        initialX = MAX_X/2 + 1;
        for i = 73:144
            % If there exists an object at the i'th location
            % convert it to the stimulus format (6 columns as mentioned
            % above) and add it to the CSV array
            if trialData(1,i) ~= 0
                trialCSV = [trialCSV; getStim(trialData(1,i), x, y)];
            end
            
            % Increment x
            x = x + 1;
            
            % If x is greater than 12, set x back to the beginning
            % and increment y
            if x > MAX_X
                x = initialX;
                y = y + 1;
            end
        end
        
        % Add the trial to the data of all trials
        trialsCSV = [trialsCSV, trialCSV];
    end
    
    % The object holding the CSV data for all trials for a single
    % participant.
    awareTrialsCSV = [];
    for trial = 1:size(awareOrder{1,1},ROW_DIMENSION)
        % Get the set number and the pattern number for this trial
        set = awareOrder{1,1}(trial,SET_INDEX);
        pattern = awareOrder{1,1}(trial,PATTERN_INDEX);
        
        % Handles the trailing zero rows (quits the program once they are
        % reached)
        if (set == 0 || pattern == 0)
            break
        end
        
        % Trials contain a variable number of stimuli (rows) with each stimuli
        % having six columns (x, y, radius, rotationType, colorType,
        % distractorType).
        awareCSV = [];
        
        % From the 3D array with dimensions (set, object, pattern),
        % extract the objects for the trial with that pattern and set
        trialData = patternSet{1,1}(set,:,pattern);
        
        % Convert i values (from 1 to 144) into x-values that are 
        % based off the 4-quadrant mapping used by Tom.
        
        % The first 72 i-vals range from X = 1 to X = 6 
        % and Y = 1 to Y = 12
        x = MIN_X; y = MIN_Y;
        initialX = MIN_X;
        for i = 1:72 
            % If there exists an object at the i'th location
            % convert it to the stimulus format (6 columns as mentioned
            % above) and add it to the CSV array
            if trialData(1,i) ~= 0
                awareCSV = [awareCSV; getStim(trialData(1,i), x, y)];
            end
            
            % Increment x
            x = x + 1;
            
            % If x is greater than 6, set x back to the beginning
            % and increment y
            if x > MAX_X/2
                x = initialX;
                y = y + 1;
            end
        end

        % The second 72-vals range from X = 7 to X = 12
        % and from Y = 1 to Y = 12
        x = MAX_X/2 + 1; y = MIN_Y;
        initialX = MAX_X/2 + 1;
        for i = 73:144
            % If there exists an object at the i'th location
            % convert it to the stimulus format (6 columns as mentioned
            % above) and add it to the CSV array
            if trialData(1,i) ~= 0
                awareCSV = [awareCSV; getStim(trialData(1,i), x, y)];
            end
            
            % Increment x
            x = x + 1;
            
            % If x is greater than 12, set x back to the beginning
            % and increment y
            if x > MAX_X
                x = initialX;
                y = y + 1;
            end
        end
        
        % Add the trial to the data of all trials
        awareTrialsCSV = [awareTrialsCSV, awareCSV];
    end
    
    % Create the appropriate directories if they don't exist
    if (exist('Patterns','dir') == 0) 
        mkdir('Patterns') 
    end
    if (exist('Order','dir') == 0) 
        mkdir('Order') 
    end
    
    % Write the data of all trials to pattern_subjectNum.csv
    csvwrite(strcat(strcat('Patterns/pattern_', int2str(subject)),'.csv'), trialsCSV);
    csvwrite(strcat(strcat('Patterns/pattern_', int2str(subject)),'_aware.csv'), awareTrialsCSV);
    % Write the data of the trial order to order_subjectNum.csv
    csvwrite(strcat(strcat('Order/order_', int2str(subject)),'.csv'), trialOrder);
    csvwrite(strcat(strcat('Order/order_', int2str(subject)),'_aware.csv'), awareOrder);
end

% Converts the trialData format into the correct stimulus format
% (with 6 columns as mentioned before)
function stim = getStim(trialData, x, y)
    trialDataStr = int2str(trialData);
    colorVar = str2num(trialDataStr(1));
    rot = str2num(trialDataStr(2));
    rad = str2num(trialDataStr(3));
    distract = str2num(trialDataStr(4));
    stim = [x, y, rad, rot, colorVar, distract];
end
   
