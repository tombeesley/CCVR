function out = OrderTrialsAwareness(TT,startB,blocks)

TPB = numel(TT)*4; % trials per block

bStruc1 = reshape(repmat(TT,4,1),TPB,1);
bStruc2 = repmat([1:4]',numel(TT),1);

blockStruc = [bStruc1 bStruc2 bStruc2];

bOrder = zeros(TPB*blocks,6);

for b = 1:blocks
    
    step = (b-1)*TPB; tStep = (startB+b-2)*4; %used for array indexing
    
    randCheck = false;
    while randCheck == false
        randCheck = true;
    
        rO = randperm(TPB);
        temp = blockStruc(rO,:);
    
        qDiff = diff(temp(:,2));
        if sum(qDiff==0) > 0
            randCheck = false;
        elseif b > 1 && temp(1,2) == bOrder((b-1)*8,2)
            randCheck = false;
        end
    end
        
    
    
    %   adds remaining trial details
    temp4 = ones(TPB,1); % session number
    temp5 = (startB+b-1)*ones(TPB,1); % block number
    temp6 = (1:TPB)'; % trial number
    bOrder(step+1:step+TPB,:) = [temp4 temp5 temp6 temp];
    
    
end

out = bOrder;