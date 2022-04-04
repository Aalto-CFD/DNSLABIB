%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% advection-diffusion stage with RK4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Uold = U; Vold = V; Wold = W;
Uc   = U; Vc   = V; Wc = W;


for(rk=1:4)

ConstructVelocityIncrement;

if(rk<4)
    U=Uold+b(rk)*dU;
    V=Vold+b(rk)*dV;
    W=Wold+b(rk)*dW;
    ObstacleVels;
end
    Uc=Uc+a(rk)*dU;
    Vc=Vc+a(rk)*dV;
    Wc=Wc+a(rk)*dW;

end
ObstacleVels;

% Reinitialize the filtered fields
DivDivUXX = Uc;
DivDivUYY = Uc;
DivDivUZZ = Uc;
DivDivVXX = Vc;
DivDivVYY = Vc;
DivDivVZZ = Vc;
DivDivWXX = Wc;
DivDivWYY = Wc;
DivDivWZZ = Wc;

% Define the terms for filtering the velocity field
for iii=1:3
    DivDivUXX = ((dx/pi).^2).*LaplacianXX(DivDivUXX,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivUYY = ((dy/pi).^2).*LaplacianYY(DivDivUYY,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivUZZ = ((dz/pi).^2).*LaplacianZZ(DivDivUZZ,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivVXX = ((dx/pi).^2).*LaplacianXX(DivDivVXX,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivVYY = ((dy/pi).^2).*LaplacianYY(DivDivVYY,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivVZZ = ((dz/pi).^2).*LaplacianZZ(DivDivVZZ,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivWXX = ((dx/pi).^2).*LaplacianXX(DivDivWXX,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivWYY = ((dy/pi).^2).*LaplacianYY(DivDivWYY,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
    DivDivWZZ = ((dz/pi).^2).*LaplacianZZ(DivDivWZZ,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz);
end

% Filter the velocity component by component
Uc = Uc + DivDivUXX + DivDivUYY + DivDivUZZ;
Vc = Vc + DivDivVXX + DivDivVYY + DivDivVZZ;
Wc = Wc + DivDivWXX + DivDivWYY + DivDivWZZ;
% Enforce incompressibility by performing a projection step
[Uc,Vc,Wc,P]=Project(Uc,Vc,Wc,KX,KY,KZ,P,Beta,dx,dy,dz,east,west,north,south,front,back,inx,iny,inz);
U = Uc; V = Vc; W = Wc;
ObstacleVels;
