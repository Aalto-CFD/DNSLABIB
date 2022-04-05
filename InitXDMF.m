% Initialize the required .h5 files

FieldName = sprintf('fields.h5');
if isfile(FieldName), delete (FieldName); end
FieldName = sprintf('geometry.h5');
if isfile(FieldName), delete (FieldName); end
FieldName = sprintf('particles.h5');
if isfile(FieldName), delete (FieldName); end
if isfile('particles.raw'), delete particles.raw; end

% Create the accompanying XDMF file
fileID = fopen('openWithParaView.xmf','w');
fprintf(fileID,'<?xml version="1.0" ?>\n');
fprintf(fileID,'<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" []>\n');
fprintf(fileID,'<Xdmf Version="2.0">\n');
fprintf(fileID,' <Domain>\n');
fprintf(fileID,'  <Grid Name="mesh" GridType="Collection" CollectionType="Temporal">\n');
fclose(fileID);
