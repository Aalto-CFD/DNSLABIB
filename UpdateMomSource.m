function [SU,SV,SW] = UpdateSourceMask(SourceMaskFunction,SU,SV,SW,U,V,W,Uset,Vset,Wset,dt)

SU = SU + (1.0/(3.0*dt)).*(Uset-U).*SourceMaskFunction;
SV = SV + (1.0/(3.0*dt)).*(Vset-V).*SourceMaskFunction;
SW = SW + (1.0/(3.0*dt)).*(Wset-W).*SourceMaskFunction;

end
