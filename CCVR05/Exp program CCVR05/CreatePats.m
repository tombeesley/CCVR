function outData = CreatePats

blocks = 18;
subjects = 50;

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
    P = zeros(10,144,4*blocks);

    clc; sub 

   
    % Repeated near target 
    for i = 1:4
        P(1,:,i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
    end 
    P(1,:,1:4*blocks) = repmat(P(1,:,1:4),[1 1 blocks]);
    
    % Repeated far target 
    for i = 1:4
        P(2,:,i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
    end 
    P(2,:,1:4*blocks) = repmat(P(2,:,1:4),[1 1 blocks]);
    
    % Copy to set 3 and do depth switch for two patterns
    if rem(sub,2) == 1
        setsSwitched = [1 3 2 4]; % odd numbered participants
    else
        setsSwitched = [2 4 1 3]; % even numbered participants
    end
    % set 1 switches (new set 3)
    P(3,:,setsSwitched(1)) = depthswitch(P(1,:,setsSwitched(1)), nearDist, farDist);
    P(3,:,setsSwitched(2)) = depthswitch(P(1,:,setsSwitched(2)), nearDist, farDist);
    P(3,:,setsSwitched(3)) = P(1,:,setsSwitched(3));
    P(3,:,setsSwitched(4)) = P(1,:,setsSwitched(4));
    P(3,:,1:4*blocks) = repmat(P(3,:,1:4),[1 1 blocks]);
    
    % set 2 switches (new set 4)
    P(4,:,setsSwitched(3)) = depthswitch(P(2,:,setsSwitched(3)), nearDist, farDist);
    P(4,:,setsSwitched(4)) = depthswitch(P(2,:,setsSwitched(4)), nearDist, farDist);
    P(4,:,setsSwitched(1)) = P(2,:,setsSwitched(1));
    P(4,:,setsSwitched(2)) = P(2,:,setsSwitched(2));
    P(4,:,1:4*blocks) = repmat(P(4,:,1:4),[1 1 blocks]);

    % Near target random
    for x = 0:4:4*blocks-4
        for i = 1:4
            P(5,:,x+i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist);
        end
    end
    
    % Far target random
    for x = 0:4:4*blocks-4
        for i = 1:4
            P(6,:,x+i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist);
        end
    end
    
    % awareness patterns
    for i = 1:4
        P(7,:,i) = P(1,:,i); % copy pattern from set 1
        P(8,:,i) = P(2,:,i);
        P(9,:,i) = makePattern(1,1,1,1,i, nearDist, farDist, nearDist); % random
        P(10,:,i) = makePattern(1,1,1,2,i, nearDist, farDist, farDist); % random
    end
    for b = 1:3 % additional blocks of awareness test (repetitions of patterns)
        P(7:10,:,(b*4)+1:(b*4)+4) = P(5:8,:,1:4);
    end
    
    order = zeros(192,6);
    % set order for main procedure
    order(1:160,:) = OrderTrials([1 2 5 6],1,10,0);
    order(161:288,:) = OrderTrials([3 4 5 6],11,8,order(160,6));

    % set order for awareness procedure
    orderAwareness = OrderTrialsAwareness([7 8 9 10],1,2);

    outData(sub,1) = {uint16(P)};
    outData(sub,2) = {uint16(order)};
    outData(sub,3) = {uint16(orderAwareness)};
    outData(sub,4) = {setTs};
    outData(sub,5) = {setCols};
    
    % Convert to CSV
    ConvertToCSV(outData(sub,1), outData(sub,2), outData(sub,3), sub);
    
end

end
