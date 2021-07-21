function result = analyseRT
% this program reads the csv files
% and analyses the RT and error data

Experiment = 1;
if Experiment == 1
    subs = 1:25;
elseif Experiment == 2
    subs = 1:20;
end

res = zeros(numel(subs),4);
resBlocks = zeros(numel(subs),12);

sCnt = 0;

for s = subs
    
    sCnt = sCnt + 1;
    
    if Experiment == 1
        fname = ['Exp1a\Output data\data_',int2str(s), '.csv'];
        d = csvread(fname,1,3);
    elseif Experiment == 2
        fname = ['Exp1b\Output data\data_',int2str(s), '.csv'];
        d = csvread(fname,1,4);
    end     
    
    d(d(:,7)>0,:) = []; % remove trials with multiple responses
    if Experiment == 1
        d(d(:,6)>=10000,:) = []; % remove trials greater than 10s
    elseif Experiment == 2
        d(d(:,6)==9999,:) = []; % remove trials with timeout
    end
    
    for t = 1:4
        res(sCnt,t) = mean(d(d(:,3)==t,6));
    end
    
    bNums = [1 11 21];
    for t = 1:4
        TTtemp = d(d(:,3)==t,:);
        for b = 1:3
            temp = TTtemp(TTtemp(:,1)>=bNums(b),:);
            temp = temp(temp(:,1)<=bNums(b)+9,:);
            step = (t-1)*3 + b;
            resBlocks(sCnt,step) = mean(temp(:,6));
        end
    
    end
    
end

result.overall = [subs' res];
result.blocks = [subs' resBlocks];