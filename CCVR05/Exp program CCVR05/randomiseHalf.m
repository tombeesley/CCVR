function outPat = randomiseHalf(patIn, depthToR)
% this function finds all elements at a certain depth
% it then removes those elements and replaces them with new randomly
% generated elements. It takes into consideration the target position and
% exisiting elements to maintain the correct number of stimuli

tempPat = mod(mod(patIn,1000),100); % simplifies to depth and target/distractor codes
targetPos = find(mod(tempPat,10)==9); % finds target position
dsAtDepth = (floor(tempPat/10)*10)==depthToR; % marks which elements are at specified depth

outPat = patIn;
outPat(dsAtDepth) = 0; % set marked distractors at depth to 0
outPat(targetPos) = patIn(targetPos); % put target back in

y = 0:36:108;

for q = 1:4
    for d = 1:2
        dPos = targetPos; % sets as target to start while loop
        while outPat(dPos) ~= 0 % element is taken
            dPos = y(q) + randi(36);
        end
        outPat(dPos) = 1000 + randi(9)*100 + depthToR + 1;
    end  
end


