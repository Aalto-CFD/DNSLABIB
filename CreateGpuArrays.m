hh=whos;

for(ff=1:length(hh))

if(strcmp(hh(ff).name,'ans') || strcmp(hh(ff).name,'hh'))

elseif(strcmp(hh(ff).class,'struct'))
    eval(strcat(hh(ff).name, '= structfun(@gpuArray,', hh(ff).name, [',''UniformOutput'','], 'false);'));
else
       eval(strcat(hh(ff).name, '= gpuArray(',hh(ff).name,');'));
    end
    end
 