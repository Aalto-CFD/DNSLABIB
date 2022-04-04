function [InterpolationMaskFunction] = CreateInterpolationMask(XCenter,YCenter,ZCenter,DimX,DimY,DimZ,X,Y,Z,Lx,Ly,Lz,minX,maxX,minY,maxY,minZ,maxZ,WallSmoothingFactor)

% if(XCenter < minX)
%     XCenter = minX;
% end
% if(XCenter > maxX)
%     XCenter = maxX;
% end
% if(YCenter < minY)
%     YCenter = minY;
% end
% if(YCenter > maxY)
%     YCenter = maxY;
% end
% if(ZCenter < minZ)
%     ZCenter = minZ;
% end
% if(ZCenter > maxZ)
%     ZCenter = maxZ;
% end

WallThicknessFactorX = 2.0*(1.0/(DimX/Lx));
WallThicknessFactorY = 2.0*(1.0/(DimY/Ly));
WallThicknessFactorZ = 2.0*(1.0/(DimZ/Lz));

InterpolationMaskFunction = 0.5.*(1-tanh(WallSmoothingFactor*(abs(X-XCenter)./(Lx/WallThicknessFactorX) - (Lx/WallThicknessFactorX)./abs(X-XCenter)))).* ...
0.5.*(1-tanh(WallSmoothingFactor*(abs(Y-YCenter)./(Ly/WallThicknessFactorY) - (Ly/WallThicknessFactorY)./abs(Y-YCenter)))).* ...
0.5.*(1-tanh(WallSmoothingFactor*(abs(Z-ZCenter)./(Lz/WallThicknessFactorZ) - (Lz/WallThicknessFactorZ)./abs(Z-ZCenter))));


end
