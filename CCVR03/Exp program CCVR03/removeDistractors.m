function outPat = removeDistractors(original, dNum)

copy = original;

dMin = dNum*1000;
dMax = (dNum*1000)+1000;

original(((original>dMin)&(original<dMax))) = 0;

outPat = original;

end