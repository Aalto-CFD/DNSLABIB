% This function creates the S(x,y,z) mask function to be applied in constraining the sources to a specific
% region. XCenter, YCenter and ZCenter refer to the volumetric center coordinates of the source region, while
% DimX, DimY and DimZ are the length, width and depth of the region. Furthermore, WallSmoothingFactor is the
% "B" coefficient for smoothing the the mask boundary in the tanh function 

function [SU,SV,SW,SourceMaskLinearFunction] = CreateSourceInitMask(XCenter,YCenter,ZCenter,DimX,DimY,DimZ,X,Y,Z,Lx,Ly,Lz,minX,maxX,minY,maxY,minZ,maxZ,WallSmoothingFactor,SU,SV,SW,U,V,W,Uset,Vset,Wset,dt)

% Make sure the provided coordinates don't extend beyond the flow domain
if(XCenter < minX)
    XCenter = minX;
end
if(XCenter > maxX)
    XCenter = maxX;
end
if(YCenter < minY)
    YCenter = minY;
end
if(YCenter > maxY)
    YCenter = maxY;
end
if(ZCenter < minZ)
    ZCenter = minZ;
end
if(ZCenter > maxZ)
    ZCenter = maxZ;
end

% Define the dimension-related coefficients in the tanh expression
% in terms of DimX, DimY and DimZ and the flow domain dimensions Lx, Ly and Lz 
WallThicknessFactorX = 2.0*(1.0/(DimX/Lx));
WallThicknessFactorY = 2.0*(1.0/(DimY/Ly));
WallThicknessFactorZ = 2.0*(1.0/(DimZ/Lz));
Nx = size(U,1); Ny = size(U,2); Nz = size(U,3);

UseTANH = 1;

% Finally, calculate the source term S(x,y,z) in terms of the tanh function
if (UseTANH == 1)
	SourceMaskLinearFunction = 0.5.*(1-tanh(WallSmoothingFactor*(abs(X-XCenter)./(Lx/WallThicknessFactorX) - (Lx/WallThicknessFactorX)./abs(X-XCenter)))).* ...
	0.5.*(1-tanh(WallSmoothingFactor*(abs(Y-YCenter)./(Ly/WallThicknessFactorY) - (Ly/WallThicknessFactorY)./abs(Y-YCenter)))).* ...
	0.5.*(1-tanh(WallSmoothingFactor*(abs(Z-ZCenter)./(Lz/WallThicknessFactorZ) - (Lz/WallThicknessFactorZ)./abs(Z-ZCenter))));

% Alternatively, use a parabolic mask profile
else
	SourceMaskLinearFunction = gpuArray(zeros(Nx, Ny, Nz));
	SourceMaskLinearFunction(XCenter - DimX/2.0 < X & X < XCenter + DimX/2.0 & YCenter - DimY/2.0 < Y ...
	& Y < YCenter + DimY/2.0 & ZCenter - DimZ/2.0 < Z & Z < ZCenter + DimZ/2.0) = 1.0;
	
	ax = -1.0/((DimX/2.0).^2); bx = (2.0*XCenter)/((DimX/2.0).^2); cx = 1.0 - (XCenter.^2)/((DimX/2.0).^2);
	ay = -1.0/((DimY/2.0).^2); by = (2.0*YCenter)/((DimY/2.0).^2); cy = 1.0 - (YCenter.^2)/((DimY/2.0).^2);
	az = -1.0/((DimZ/2.0).^2); bz = (2.0*ZCenter)/((DimZ/2.0).^2); cz = 1.0 - (ZCenter.^2)/((DimZ/2.0).^2);

	Xx = X(XCenter - DimX/2.0 < X & X < XCenter + DimX/2.0 & YCenter - DimY/2.0 < Y ...
	& Y < YCenter + DimY/2.0 & ZCenter - DimZ/2.0 < Z & Z < ZCenter + DimZ/2.0);
	Yy = Y(XCenter - DimX/2.0 < X & X < XCenter + DimX/2.0 & YCenter - DimY/2.0 < Y ...
	& Y < YCenter + DimY/2.0 & ZCenter - DimZ/2.0 < Z & Z < ZCenter + DimZ/2.0);
	Zz = Z(XCenter - DimX/2.0 < X & X < XCenter + DimX/2.0 & YCenter - DimY/2.0 < Y ...
	& Y < YCenter + DimY/2.0 & ZCenter - DimZ/2.0 < Z & Z < ZCenter + DimZ/2.0);

	SourceMaskLinearFunction(XCenter - DimX/2.0 < X & X < XCenter + DimX/2.0 & YCenter - DimY/2.0 < Y ...
	& Y < YCenter + DimY/2.0 & ZCenter - DimZ/2.0 < Z & Z < ZCenter + DimZ/2.0) = (ax.*Xx.*Xx + bx.*Xx + cx).* ...
	(ay.*Yy.*Yy + by.*Yy + cy).*(az.*Zz.*Zz + bz.*Zz + cz);
end
% Update the momentum source terms in each direction utilizing the mask function 
SU = SU + (1.0/(3.0*dt)).*(Uset-U).*SourceMaskLinearFunction;
SV = SV + (1.0/(3.0*dt)).*(Vset-V).*SourceMaskLinearFunction;
SW = SW + (1.0/(3.0*dt)).*(Wset-W).*SourceMaskLinearFunction;


end
