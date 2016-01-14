function [sol,val] = tsp(sol,options)
global pointMatrix;
global WalkSpeed;
global distMatrix

sol;
numvars=size(sol,2)-1;

score =0;
distance =0;
time =0;
penalty = 0;
speed =0;

toggleStart =0;

for n=1:numvars
    if sol(n)==1
        toggleStart =1;
    end
    
    if toggleStart ==0 && n==1
        distance = distance + (distMatrix(sol(n),1));
        score = score + pointMatrix(sol(n));
        run =1;
    end
    
    if toggleStart ==0 && n>1
        distance = distance  + (distMatrix(sol(n),sol(n-1)));
        score = score + pointMatrix(sol(n));
    end
end

time = distance * (1/WalkSpeed) ;  %0.7039
if (time > 3600)
    penalty = ((time - 3600)/60) *2;
end

val = score - penalty;








