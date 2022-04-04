% For filtering the passive scalar field, calculate the second order derivative in the z-direction by utilizing the finite volume method
% and multiply by the suitable filter coefficient (dz/pi)^2

function G = DivDivZ(P,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

G =   0.5.*(Beta(iny,inx,front)+Beta(iny,inx,inz)).*((P(iny,inx,front)-P(iny,inx,inz))/dz^2) - ...
      0.5.*(Beta(iny,inx,back)+Beta(iny,inx,inz)).*((P(iny,inx,inz)-P(iny,inx,back))/dz^2);
G = ((dz/pi).^2).*G;
