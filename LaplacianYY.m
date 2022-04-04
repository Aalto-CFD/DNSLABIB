% Calculate the y-directional contribution of the Laplacian operator for a scalar P with the 2nd order central difference

function [FYY] = LaplacianYY(P,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

    FYY = (P(north,inx,inz) - 2.0*P(iny,inx,inz) + P(south,inx,inz))/(dy*dy);

end

