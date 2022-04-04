% Calculate the z-directional contribution of the Laplacian operator for a scalar P with the 2nd order central difference

function [FZZ] = LaplacianZZ(P,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

    FZZ = (P(iny,inx,front) - 2.0*P(iny,inx,inz) + P(iny,inx,back))/(dz*dz);

end

