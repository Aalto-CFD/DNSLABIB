subiter = 3; % do 3 subiterations
dtd = dt/subiter; % droplet timestep

% index labels of droplets
 % indy = min(Ny,max(1,1+round((Ny-1)*yd/Ly))); indx = min(Nz,max(1, 1+round((Nx-1)*xd/Lx)));
 % indz = min(Nz,max(1, 1+round((Nz-1)*zd/Lz)));

 indy = min(Ny,max(1,1+round((Ny-1)*(yd-yMinPart)/(yMaxPart-yMinPart))));
 indx = min(Nx,max(1, 1+round((Nx-1)*(xd-xMinPart)/(xMaxPart-xMinPart))));
 indz = min(Nz,max(1, 1+round((Nz-1)*(zd-zMinPart)/(zMaxPart-zMinPart))));

% gas velocity at droplet positions
 ug = U(sub2ind(size(U),indy,indx,indz));
 vg = V(sub2ind(size(V),indy,indx,indz));
 wg = W(sub2ind(size(W),indy,indx,indz));

for(kk=1:subiter)
SolveDrops;
end

% create a treatment what happens to droplets at domain boundaries
ud(yd<yMinPart)=0; vd(yd<yMinPart)=0; wd(yd<yMinPart)=0; yd(yd<yMinPart) = yMinPart;
ud(yd>yMaxPart)=0; vd(yd>yMaxPart)=0; wd(yd>yMaxPart)=0; yd(yd>yMaxPart) = yMaxPart;
ud(xd<xMinPart)=0; vd(xd<xMinPart)=0; wd(xd<xMinPart)=0; xd(xd<xMinPart) = xMinPart;
ud(xd>xMaxPart)=0; vd(xd>xMaxPart)=0; wd(xd>xMaxPart)=0; xd(xd>xMaxPart) = xMaxPart;
ud(zd<zMinPart)=0; vd(zd<zMinPart)=0; wd(zd<zMinPart)=0; zd(zd<zMinPart) = zMinPart;
ud(zd>zMaxPart)=0; vd(zd>zMaxPart)=0; wd(zd>zMaxPart)=0; zd(zd>zMaxPart) = zMaxPart; 

