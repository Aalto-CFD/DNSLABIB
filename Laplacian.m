function [FXXYYZZ] = Laplacian(P,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

    FXX = (P(iny,east,inz) - 2.0*P(iny,inx,inz) + P(iny,west,inz))/(dx*dx);
    FYY = (P(north,inx,inz) - 2.0*P(iny,inx,inz) + P(south,inx,inz))/(dy*dy);
    FZZ = (P(iny,inx,front) - 2.0*P(iny,inx,inz) + P(iny,inx,back))/(dz*dz);
    
    FXXYYZZ = FXX + FYY + FZZ;

end

