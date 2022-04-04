% For filtering the passive scalar field, calculate the second order derivative in the x-direction by utilizing the finite volume method
% and multiply by the suitable filter coefficient (dx/pi)^2

function G = DivDivX(P,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)
G =   0.5.*(Beta(iny,east,inz)+Beta(iny,inx,inz)).*((P(iny,east,inz)-P(iny,inx,inz))/dx^2) - ...
      0.5.*(Beta(iny,west,inz)+Beta(iny,inx,inz)).*((P(iny,inx,inz)-P(iny,west,inz))/dx^2);
G = ((dx/pi).^2).*G;
