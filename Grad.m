function [FX,FY,FZ] = Grad(InputEast,InputWest,InputNorth,InputSouth,InputFront,InputBack,dx,dy,dz)

FX = (InputEast - InputWest)/(2.0*dx);
FY = (InputNorth - InputSouth)/(2.0*dy);
FZ = (InputFront - InputBack)/(2.0*dz);

end

