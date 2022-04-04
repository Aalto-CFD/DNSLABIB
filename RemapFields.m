% Remap the velocity, pressure and passive scalar fields to the new mesh from the old

[XOld,YOld,ZOld] = meshgrid(xOld,yOld,zOld);
[X,Y,Z] = meshgrid(x,y,z);

minX = min(min(min(XOld)));
maxX = max(max(max(XOld)));
minY = min(min(min(YOld)));
maxY = max(max(max(YOld)));
minZ = min(min(min(ZOld)));
maxZ = max(max(max(ZOld)));

[InterpolationMaskFunction] = CreateInterpolationMask(min(xOld) + (max(xOld)-min(xOld))/2.0, ...
min(yOld) + (max(yOld)-min(yOld))/2.0, min(zOld) + (max(zOld)-min(zOld))/2.0, ...
(max(xOld)-min(xOld)),(max(yOld)-min(yOld)),(max(zOld)-min(zOld)),XOld,YOld,ZOld,(max(xOld)-min(xOld)),(max(yOld)-min(yOld)), ...
(max(zOld)-min(zOld)),minX,maxX,minY,maxY,minZ,maxZ,5.0);

U = InterpolationMaskFunction.*U; V = InterpolationMaskFunction.*V; W = InterpolationMaskFunction.*W;
P = InterpolationMaskFunction.*P; T = InterpolationMaskFunction.*T;

[XOld,YOld,ZOld] = ndgrid(xOld,yOld,zOld);
[X,Y,Z] = ndgrid(x,y,z);

U = permute(U,PermutationMatrix); V = permute(V,PermutationMatrix); W = permute(W,PermutationMatrix);
P = permute(P,PermutationMatrix); T = permute(T,PermutationMatrix);

U = Remap(U,XOld,YOld,ZOld,X,Y,Z);
V = Remap(V,XOld,YOld,ZOld,X,Y,Z);
W = Remap(W,XOld,YOld,ZOld,X,Y,Z);
P = Remap(P,XOld,YOld,ZOld,X,Y,Z);
T = Remap(T,XOld,YOld,ZOld,X,Y,Z);

U = permute(U,PermutationMatrix); V = permute(V,PermutationMatrix); W = permute(W,PermutationMatrix);
P = permute(P,PermutationMatrix); T = permute(T,PermutationMatrix);

[XOld,YOld,ZOld] = meshgrid(xOld,yOld,zOld);
[X,Y,Z] = meshgrid(x,y,z);

CreateFields;
