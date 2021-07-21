function outPat = makePattern(tCol, dCol1, dCol2, Trow, Tloc, D1rad, D2rad, Trad)
    
global Tpos;
global setTs;

temp = zeros(1,144);

disNum = [dCol1 dCol1 dCol2 dCol2]*1000;
rots = randi(9,4)*100;
rad = repmat([1 1 2 2],4,1); % equal near and far in each quadrant
rad(rad==1) = D1rad; rad(rad==2) = D2rad;

y = 0:36:108;

while sum(temp>0) ~= 17
    temp(1,:) = 0;
    for q = 1:4
        for d = 1:4
            dPos = Tpos(1); %to enter loop
            while sum(sum(Tpos==dPos)) == 1 % check if distractor is in target location
               dPos = y(q) + randi(36);
            end
            temp(1,dPos) = disNum(d) + rots(q,d) + rad(q,d) + 1; 
        end
    end
    t = setTs(Trow,Tloc) ; %fixed target location
    temp(1,t) = tCol*1000 + randi(4)*100 + Trad + 9;
end
    
outPat = temp;
    
end