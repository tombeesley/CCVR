function outData = CreatePats

blocks = 1;
subjects = 1;

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

nearDist = 30;
farDist = 50;

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

    % Near target repeated
    for i = 1:4
        P(1,:,i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
    end   
    P(1,:,1:4*blocks) = repmat(P(1,:,1:4),[1 1 blocks]);

    % Far target repeated
    for i = 1:4
        P(2,:,i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
    end   
    P(2,:,1:4*blocks) = repmat(P(2,:,1:4),[1 1 blocks]);
    
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
    
    % copy repeated patterns for awareness test
    P(5,:,1:4) = P(1,:,1:4);
    P(6,:,1:4) = P(2,:,1:4);
    
    % new "random patterns" for awareness test
    for i = 1:4
        P(7,:,x+i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
        P(8,:,x+i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
    end
    
    % set order for main procedure
    order = OrderTrials([1 2 3 4],1,blocks,0);
    
    % set order for awareness procedure
    orderAwareness = OrderTrialsAwareness([5 6 7 8],1,4);

    outData(sub,1) = {uint16(P)};
    outData(sub,2) = {uint16(order)};
    outData(sub,3) = {uint16(orderAwareness)};
    outData(sub,4) = {setTs};
    outData(sub,5) = {setCols};
    
    % Convert to CSV
    ConvertToCSV(outData(sub,1), outData(sub,2), outData(sub,3), sub);
    
end
