function Beta = CreateBlock(XCenter,YCenter,ZCenter,DimX,DimY,DimZ,x,y,z,dx,dy,dz,Nx,Ny,Nz,Beta)

[~,Ix] = min(abs(x-XCenter));
[~,Iy] = min(abs(y-YCenter));
[~,Iz] = min(abs(z-ZCenter));

LengthX = round(DimX/dx);
LengthY = round(DimY/dy);
LengthZ = round(DimZ/dz);

DefIxMinus = Ix-floor(LengthX/2);
DefIxPlus = Ix+floor(LengthX/2);
DefIyMinus = Iy-floor(LengthY/2);
DefIyPlus = Iy+floor(LengthY/2);
DefIzMinus = Iz-floor(LengthZ/2);
DefIzPlus = Iz+floor(LengthZ/2);

if(Ix-floor(LengthX/2) < 1)
    DefIxMinus = 1;
end
if(Ix+floor(LengthX/2) > Nx)
    DefIxPlus = Nx;
end
if(Iy-floor(LengthY/2) < 1)
    DefIyMinus = 1;
end
if(Iy+floor(LengthY/2) > Ny)
    DefIyPlus = Ny;
end
if(Iz-floor(LengthZ/2) < 1)
    DefIzMinus = 1;
end
if(Iz+floor(LengthZ/2) > Nz)
    DefIzPlus = Nz;
end

Beta(DefIyMinus:DefIyPlus,DefIxMinus:DefIxPlus,DefIzMinus:DefIzPlus) = 0.0;

end

