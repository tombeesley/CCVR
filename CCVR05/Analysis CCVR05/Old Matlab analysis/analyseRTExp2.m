 function result = analyseRTExp2
% this program reads the csv files
% and analyses the RT and error data

subs = 1:40;

targetAnalysis = 0; % 0 is all; 1 is target near; 2 is target far.
maxRespAllowed = 1;

resStg1 = zeros(numel(subs),4);
resStg1Blocks = zeros(numel(subs),20);
resStg2 = zeros(numel(subs),6);
resAware = zeros(numel(subs),4);
resExclusions = zeros(numel(subs),5);

sCnt = 0;

for s = subs
    
    sCnt = sCnt + 1;
    
    fname = ['Main_Data\data_',int2str(s), '.csv'];
    d = csvread(fname,1,4);    
    
    dAw = d(289:end,:);
    d = d(1:288,:); % trim off the awareness
    dOld = d; % store original array - useful below    
    
    resExclusions(sCnt,1) = mean(d(:,7)); % store percentage of multiple responses
    resExclusions(sCnt,2) = mean(d(:,7)>maxRespAllowed)*100; % store percentage of trials over max responses allowed
    d(d(:,7)>maxRespAllowed,:) = []; % remove trials with multiple responses
    resExclusions(sCnt,3) = mean(dOld(:,6)==9999)*100; % store percentage of timeouts
    d(d(:,6)==9999,:) = []; % remove trials with timeout
       
    resExclusions(sCnt,4) = size(d,1)/288*100; % percentage of trials remaining for analysis
  
    resExclusions(sCnt,5) = mean(d(:,6),1); % overall mean RT
    
    %%%%%%
   
    % Stage 1 analysis
    d1 = d(d(:,1)<=10,:);
    
    TT = [1 2 5 6];
    
    % All blocks by TT
    for t = 1:4
        resStg1(sCnt,t) = mean(d1(d1(:,3)==TT(t),6));
    end
    
    % 2 block bins by TT
    bcnt = 0;
    for t = 1:4
        step = (t-1)*5;
        tempTT = d1(d1(:,3)==TT(t),:);
        bcnt = 0;
        for b = 1:2:10
            temp = tempTT(tempTT(:,1)>=b,:);
            temp = temp(temp(:,1)<=b+1,:);
            bcnt = bcnt + 1;     
            resStg1Blocks(sCnt,step+bcnt) = mean(temp(:,6));
        end
        
    end
    
    %%%%%%
   
    % Stage 2 analysis
    d2 = d(d(:,1)>10,:);
    
    TT = [3 4 5 6];
    
    % Which sets switched?
    if rem(s,2) == 1
        sSw = [1 3 2 4]; % odd numbered participants
    else
        sSw = [2 4 1 3]; % even numbered participants
    end
    
    % add column to code for switch
    d2 = [d2 zeros(size(d2,1),1)];
    
    % look for switch cases and mark as "1"
    for r = 1:size(d2,1)
        if d2(r,3) == 3 && (d2(r,5)==sSw(1) || d2(r,5)==sSw(2))
            d2(r,end) = 1;
        elseif d2(r,3) == 4 && (d2(r,5)==sSw(3) || d2(r,5)==sSw(4))
            d2(r,end) = 1;
        end
    end
      
    % All blocks by TT
    tCnt = 0;
    for t = 1:4
        tCnt = tCnt + 1;
        if t < 3
            tempTT = d2(d2(:,3)==TT(t),:);
            resStg2(sCnt,tCnt) = mean(tempTT(tempTT(:,end)==0,6)); % non-switched
            tCnt = tCnt + 1;
            resStg2(sCnt,tCnt) = mean(tempTT(tempTT(:,end)==1,6)); % switched
        else
            resStg2(sCnt,tCnt) = mean(d2(d2(:,3)==TT(t),6)); % random patterns
        end
        
    end
    
    % awareness test
    resAware(sCnt, 1) = mean(dAw(dAw(:,3)==7,11));
    resAware(sCnt, 2) = mean(dAw(dAw(:,3)==8,11));
    resAware(sCnt, 3) = 1-mean(dAw(dAw(:,3)==9,11));
    resAware(sCnt, 4) = 1-mean(dAw(dAw(:,3)==10,11));
    
end

result = [subs' resExclusions resStg1Blocks resStg2 resAware];

 end



