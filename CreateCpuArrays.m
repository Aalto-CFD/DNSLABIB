% This script transforms the quantities in the MATLAB workspace
% to the standard array representation

hh=whos;

for(ff=1:length(hh))

if(strcmp(hh(ff).name,'ans') || strcmp(hh(ff).name,'hh'))

elseif(strcmp(hh(ff).class,'struct'))
    eval(strcat(hh(ff).name, '= structfun(@gather,', hh(ff).name, [',''UniformOutput'','], 'false);'));
else
       eval(strcat(hh(ff).name, '= gather(',hh(ff).name,');'));
    end
    end
 
