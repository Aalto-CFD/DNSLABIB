function [U,V,W,P] = Project(U,V,W,KX,KY,KZ,P,Beta,dx,dy,dz,east,west,north,south,front,back,inx,iny,inz)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The projection method: calculate a pressure field
% which is then used to correct the velocities to satisfy
% the incompressibility condition.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is the Immersed Boundary enhanced pressure loop (hard-coded to run 4 iterations)
BetaT = 1-Beta;
for pI=1:4
    InterP = BetaT(iny,inx,inz).*Laplacian(P,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz) +...
    BetaT(iny,east,inz).*((P(iny,east,inz)-P(iny,inx,inz))/dx^2) - BetaT(iny,west,inz).*((P(iny,inx,inz)-P(iny,west,inz))/dx^2) + ...
    BetaT(north,inx,inz).*((P(north,inx,inz)-P(iny,inx,inz))/dy^2) - BetaT(south,inx,inz).*((P(iny,inx,inz)-P(south,inx,inz))/dy^2) + ...
    BetaT(iny,inx,front).*((P(iny,inx,front)-P(iny,inx,inz))/dz^2) - BetaT(iny,inx,back).*((P(iny,inx,inz)-P(iny,inx,back))/dz^2);
    InterP = 0.5*InterP;
    P = fftn(Divergence(Beta(iny,east,inz).*U(iny,east,inz),Beta(iny,west,inz).*U(iny,west,inz),Beta(north,inx,inz).*V(north,inx,inz), ...
    Beta(south,inx,inz).*V(south,inx,inz),Beta(iny,inx,front).*W(iny,inx,front),Beta(iny,inx,back).*W(iny,inx,back),dx,dy,dz) + InterP)./ ...
        min(-1e-12,(-KX.^2 - KY.^2 - KZ.^2));
    P = real(ifftn(P));
    P = P - mean(mean(mean(P)));
end

% Calculate the gradient of the obtained pressure solution and correct the velocity accordingly
[PX,PY,PZ] = Grad(P(iny,east,inz),P(iny,west,inz),P(north,inx,inz),P(south,inx,inz),P(iny,inx,front),P(iny,inx,back),dx,dy,dz);
U = U - PX;
V = V - PY;
W = W - PZ;
