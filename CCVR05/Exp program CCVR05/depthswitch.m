function patOut = depthswitch(patIn, dist1, dist2)
savedPat = patIn; % used to compare for sanity check
for i = 1:size(patIn,2)
    if rem(patIn(i),10) == 1 % just distractors
        
        oldDepth = rem(patIn(i),100)-1;
        if oldDepth == dist1
            newDepth = dist2;
        elseif oldDepth == dist2
            newDepth = dist1;
        end
        patIn(i) = patIn(i) - oldDepth + newDepth; % swap the depths
 
    end
    
end

patOut = patIn;

end