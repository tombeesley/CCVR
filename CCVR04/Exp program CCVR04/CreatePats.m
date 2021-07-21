function outData = CreatePats

blocks = 62;
subjects = 100;

RandStream.setGlobalStream(RandStream('mt19937ar','seed',sum(100*clock)));

outData = cell(subjects,2);
global Tpos; Tpos = [10 11 15 20 26; 44 50 57 64 65; 80 81 88 95 101; 119 125 130 134 135];
global setTs;
global setCols;
global P;
global Dlocs;
Dlocs = zeros(4,31);
Dlocs(1,:) = [1:9 12:14 16:19 21:25 27:36];
Dlocs(2,:) = [37:43 45:49 51:56 58:63 66:72];
Dlocs(3,:) = [73:79 82:87 89:94 96:100 102:108];
Dlocs(4,:) = [109:118 120:124 126:129 131:133 136:144];

global Dnums;
Dnums = repmat([2000 3000 4000 5000],4,1);

nearDist = 20;
farDist = 60;

for sub = 1:subjects  
    
    setTs = zeros(2,4);
    for i = 1:4
        temp = Tpos(i,randperm(5));
        setTs(:,i) = temp(1:2); %sets the locations of the targets in fixed patterns
    end
    setCols = zeros(2,4);
    for i = 1:2
        setCols(i,:) = randperm(4)'; %screts the colours of the targets in fixed patterns
    end
    
    %make pattern array
    P = zeros(4,144,4*blocks);

    clc; sub 

    if mod(sub,2) == 1 % even/odd
        whichRand = [farDist nearDist]; % odd participants, randomise distal
    else
        whichRand = [nearDist farDist]; % even participants, randomise proximal
    end
    
    % Near target - repeated near, random far
    for i = 1:4
        P(1,:,i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
        for b = 1:blocks-1
            P(1,:,i+4*b) = randomiseHalf(P(1,:,i),whichRand(1)); % randomise one set
        end
    end 

    % Far target - repeated far, random near
    for i = 1:4
        P(2,:,i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
        for b = 1:blocks-1
            P(2,:,i+4*b) = randomiseHalf(P(2,:,i),whichRand(2)); % randomise one set
        end
    end 
    
    % Near target random
    for x = 0:4:4*blocks-4
        for i = 1:4
            P(3,:,x+i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
        end
    end
    
    % Far target random
    for x = 0:4:4*blocks-4
        for i = 1:4
            P(4,:,x+i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
        end
    end
    
    % awareness patterns
    for i = 1:4
        P(5,:,i) = P(1,:,i); % copy pattern from set 1
        P(5,:,i) = randomiseHalf(P(5,:,i),whichRand(1)); % randomise one set
        P(6,:,i) = P(2,:,i);
        P(6,:,i) = randomiseHalf(P(6,:,i),whichRand(2)); % randomise one set
        P(7,:,i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist); % random
        P(8,:,i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist); % random
    end
    for b = 1:3 % additional blocks of awareness test (repetitions of patterns)
        P(5:8,:,(b*4)+1:(b*4)+4) = P(5:8,:,1:4);
    end
    
    order = zeros(200,6);
    % set order for main procedure
    order(1:128,:) = OrderTrials([1 2],1,16,0);
    order(129:160,:) = OrderTrials([3 4],17,4,order(128,6));
    order(161:288,:) = OrderTrials([1 2],20,16,order(160,6));
    order(289:320,:) = OrderTrials([3 4],37,4,order(288,6));
    order(321:448,:) = OrderTrials([1 2],41,16,order(320,6));
    order(449:480,:) = OrderTrials([3 4],57,4,order(448,6));
    order(481:496,:) = OrderTrials([1 2],61,2,order(480,6));
    
    % set order for awareness procedure
    orderAwareness = OrderTrialsAwareness([5 6 7 8],1,2);

    outData(sub,1) = {uint16(P)};
    outData(sub,2) = {uint16(order)};
    outData(sub,3) = {uint16(orderAwareness)};
    outData(sub,4) = {setTs};
    outData(sub,5) = {setCols};
    
    % Convert to CSV
    ConvertToCSV(outData(sub,1), outData(sub,2), outData(sub,3), sub);
    
end
