function [FXYZ] = Divergence(InputEast,InputWest,InputNorth,InputSouth,InputFront,InputBack,dx,dy,dz)

    FX = (InputEast - InputWest)/(2.0*dx);
    FY = (InputNorth - InputSouth)/(2.0*dy);
    FZ = (InputFront - InputBack)/(2.0*dz);
    
    FXYZ = FX + FY + FZ;

end

