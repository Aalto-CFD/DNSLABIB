ST(:) = 0.0;

% The pas. scalar sources/sinks are updated here
[ST] = UpdatePSSource(SourceMaskFunction1,ST,T,0.0,dt);
[ST] = UpdatePSSource(SourceMaskFunction2,ST,T,0.0,dt);
[ST] = UpdatePSSource(SourceMaskFunction3,ST,T,0.0,dt);
[ST] = UpdatePSSource(SourceMaskFunction4,ST,T,0.0,dt);

DiffT = Beta(iny,inx,inz).*Laplacian(T,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz) +...
Beta(iny,east,inz).*((T(iny,east,inz)-T(iny,inx,inz))/dx^2) - Beta(iny,west,inz).*((T(iny,inx,inz)-T(iny,west,inz))/dx^2) + ...
Beta(north,inx,inz).*((T(north,inx,inz)-T(iny,inx,inz))/dy^2) - Beta(south,inx,inz).*((T(iny,inx,inz)-T(south,inx,inz))/dy^2) + ...
Beta(iny,inx,front).*((T(iny,inx,front)-T(iny,inx,inz))/dz^2) - Beta(iny,inx,back).*((T(iny,inx,inz)-T(iny,inx,back))/dz^2);
DiffT = 0.5*DiffT;

ConvT = U(iny,inx,inz).*(T(iny,east,inz)-T(iny,west,inz))/(2*dx) + ...
		V(iny,inx,inz).*(T(north,inx,inz)-T(south,inx,inz))/(2*dy) + ...
		W(iny,inx,inz).*(T(iny,inx,front)-T(iny,inx,back))/(2*dz);
        
dT = (-ConvT + nu*DiffT + ST)*dt;
