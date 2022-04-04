% Calculate the x-directional contribution of the Laplacian operator for a scalar P with the 2nd order central difference

function [FXX] = LaplacianXX(P,east,west,north,south,front,back,inx,iny,inz,dx,dy,dz)

    FXX = (P(iny,east,inz) - 2.0*P(iny,inx,inz) + P(iny,west,inz))/(dx*dx);

end

