% For filtering the passive scalar field, calculate the second order derivative in the y-direction by utilizing the finite volume method
% and multiply by the suitable filter coefficient (dy/pi)^2

function G = DivDivY(P,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

G =   0.5.*(Beta(north,inx,inz)+Beta(iny,inx,inz)).*((P(north,inx,inz)-P(iny,inx,inz))/dy^2) - ...
      0.5.*(Beta(south,inx,inz)+Beta(iny,inx,inz)).*((P(iny,inx,inz)-P(south,inx,inz))/dy^2);
G = ((dy/pi).^2).*G;
