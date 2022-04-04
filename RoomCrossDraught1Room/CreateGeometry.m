BetaXF = (zeros(Ny, Nx, Nz));
BetaXB = (zeros(Ny, Nx, Nz));
BetaYF = (zeros(Ny, Nx, Nz));
BetaYB = (zeros(Ny, Nx, Nz));
BetaZF = (zeros(Ny, Nx, Nz));
BetaZB = (zeros(Ny, Nx, Nz)); 

Beta = CreateBlock(Lx/2,0,Lz/2,Lx,0.6,Lz,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateBlock(Lx/2,Ly,Lz/2,Lx,0.6,Lz,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateBlock(0,Ly/2,Lz/2,0.6,Ly,Lz,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateBlock(Lx,Ly/2,Lz/2,0.6,Ly,Lz,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateBlock(Lx/2,Ly/2,0,Lx,Ly,0.6,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateBlock(Lx/2,Ly/2,Lz,Lx,Ly,0.6,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);

OffsetFactor = 0.3;

Beta = CreateInverseBlock(0,2.1+OffsetFactor,1.75+OffsetFactor,0.6,0.8,1.5,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateInverseBlock(Lx,2.1+OffsetFactor,1.75+OffsetFactor,0.6,0.8,1.5,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateInverseBlock(0,6.8+OffsetFactor,1.75+OffsetFactor,0.6,0.8,1.5,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);
Beta = CreateInverseBlock(Lx,6.8+OffsetFactor,1.75+OffsetFactor,0.6,0.8,1.5,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta);

% Use simple 1st degree forward differencing in each direction to resolve the location
% of boundary cells
BetaX = (Beta(iny,east,inz)-Beta(iny,inx,inz))/dx; BetaXF = BetaX; BetaXB = BetaX;
BetaXF(BetaX > 0) = 0; BetaXB(BetaX < 0) = 0.0;
BetaXFSetThis = circshift(BetaXF,[0 1 0]); BetaXFBC = circshift(BetaXF,[0 -1 0]);
BetaXBSetThis = circshift(BetaXB,[0 0 0]); BetaXBBC = circshift(BetaXB,[0 2 0]);

BetaY = (Beta(north,inx,inz)-Beta(iny,inx,inz))/dy; BetaYF = BetaY; BetaYB = BetaY;
BetaYF(BetaY > 0) = 0; BetaYB(BetaY < 0) = 0.0;
BetaYFSetThis = circshift(BetaYF,[1 0 0]); BetaYFBC = circshift(BetaYF,[-1 0 0]);
BetaYBSetThis = circshift(BetaYB,[0 0 0]); BetaYBBC = circshift(BetaYB,[2 0 0]);

BetaZ = (Beta(iny,inx,front)-Beta(iny,inx,inz))/dz; BetaZF = BetaZ; BetaZB = BetaZ;
BetaZF(BetaZ > 0) = 0; BetaZB(BetaZ < 0) = 0.0;
BetaZFSetThis = circshift(BetaZF,[0 0 1]); BetaZFBC = circshift(BetaZF,[0 0 -1]);
BetaZBSetThis = circshift(BetaZB,[0 0 0]); BetaZBBC = circshift(BetaZB,[0 0 2]);

clear BetaX BetaXF BetaXB BetaY BetaYF BetaYB BetaZ BetaZF BetaZB;
