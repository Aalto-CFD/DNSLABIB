
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% advection-diffusion stage with RK4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Told = T;
Tc   = T;

for(rk=1:4)

ConstructScalarIncrement;

if(rk<4)
    T=Told+b(rk)*dT;
end
    Tc=Tc+a(rk)*dT;
    ObstacleTs;
end

% Reinitialize filtered fields
DivDivTXX = Tc;
DivDivTYY = Tc;
DivDivTZZ = Tc;

for iii=1:3
   DivDivTXX = DivDivX(DivDivTXX,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
   DivDivTYY = DivDivY(DivDivTYY,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
   DivDivTZZ = DivDivZ(DivDivTZZ,Beta,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);

end

Tc = Tc + DivDivTXX + DivDivTYY + DivDivTZZ;
T = Tc;
T = min(T,1.0);
T = max(T,0.0);
ObstacleTs;
