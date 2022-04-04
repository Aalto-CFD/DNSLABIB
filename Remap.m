% This function remaps the solution of a field from one mesh to another
% using linear interpolation

function MappedField = Remap(Field,XOld,YOld,ZOld,X,Y,Z)

MappedField = interpn(XOld,YOld,ZOld,Field,X,Y,Z,'linear',0.0);

end

