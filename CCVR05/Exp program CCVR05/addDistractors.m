function outPat = addDistractors(original,dNum, radius)

global Tpos

temp = original;

disNum = [dNum dNum]*1000;

locs = randi(4,4)*10;

y = 0:36:108;

while sum(temp>0) ~= 17
    temp = original;
    for q = 1:4
        for d = 1:2
            dPos = Tpos(1); %to enter loop
            while sum(sum(Tpos==dPos)) == 1 % check if distractor is in target location
                dPos = y(q) + randi(36);
            end
            temp(1,dPos) = disNum(d) + locs(q,d);
        end    
    end
end

outPat = temp;
    
end