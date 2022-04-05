% Write the flow fields in the .h5 files and update the XDMF metadata

Nxc = gather(Nx); Nyc = gather(Ny); Nzc = gather(Nz);
xcc = gather(x); ycc = gather(y); zcc = gather(z);
Ucc = gather(U); Vcc = gather(V); Wcc = gather(W);
SimulationTimec = gather(SimulationTime); setHDF5TimeStepCountc = gather(setHDF5TimeStepCount);
UVWMagcc = sqrt(Ucc.^2 + Vcc.^2 + Wcc.^2);
Tcc = gather(T);
Pcc = gather(P);
xdcc = gather(xd); ydcc = gather(yd); zdcc = gather(zd); Ndcc = gather(Nd);
udcc = gather(ud); vdcc = gather(vd); wdcc = gather(wd); ddcc = gather(dd);

Ucc = permute(Ucc,PermutationMatrix); Vcc = permute(Vcc,PermutationMatrix);
Wcc = permute(Wcc,PermutationMatrix); UVWMagcc = permute(UVWMagcc,PermutationMatrix);
Tcc = permute(Tcc,PermutationMatrix); Pcc = permute(Pcc,PermutationMatrix);

InterT = gather(Beta); InterT = permute(InterT,PermutationMatrix);

if isfile('geometry.h5'), delete geometry.h5; end
% x-axis
h5create('geometry.h5','/x_nodes',Nxc);
h5write('geometry.h5','/x_nodes',xcc);
% y-axis
h5create('geometry.h5','/y_nodes',Nyc);
h5write('geometry.h5','/y_nodes',ycc);
% z-axis
h5create('geometry.h5','/z_nodes',Nzc);
h5write('geometry.h5','/z_nodes',zcc);

FieldNameCoords = sprintf('/coords%g', setHDF5TimeStepCountc);

FieldName = sprintf('fields.h5');
FieldNameU = sprintf('/U%g', setHDF5TimeStepCountc);
FieldNameV = sprintf('/V%g', setHDF5TimeStepCountc);
FieldNameW = sprintf('/W%g', setHDF5TimeStepCountc);
FieldNameUVW = sprintf('/UVWMag%g', setHDF5TimeStepCountc);
FieldNameT = sprintf('/T%g', setHDF5TimeStepCountc);
FieldNameP = sprintf('/P%g', setHDF5TimeStepCountc);
FieldNameMask = sprintf('/Mask%g', setHDF5TimeStepCountc);

h5create(FieldName,FieldNameU,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameU,Ucc);

h5create(FieldName,FieldNameV,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameV,Vcc);

h5create(FieldName,FieldNameW,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameW,Wcc);

h5create(FieldName,FieldNameUVW,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameUVW,UVWMagcc);

h5create(FieldName,FieldNameT,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameT,Tcc);

h5create(FieldName,FieldNameP,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameP,Pcc);

h5create(FieldName,FieldNameMask,[Nxc,Nyc,Nzc]);
h5write(FieldName,FieldNameMask,InterT);

FieldNamePartRaw = sprintf('particles%g', setHDF5TimeStepCountc);
FieldNamePartRaw = FieldNamePartRaw + ".txt";
writematrix([xdcc ydcc zdcc udcc vdcc wdcc ddcc],FieldNamePartRaw,'Delimiter',',');

if isfile(FieldNameU), delete (FieldNameU); end
if isfile(FieldNameV), delete (FieldNameV); end
if isfile(FieldNameW), delete (FieldNameW); end
if isfile(FieldNameUVW), delete (FieldNameUVW); end
if isfile(FieldNameT), delete (FieldNameT); end
if isfile(FieldNameP), delete (FieldNameP); end
if isfile(FieldNameMask), delete (FieldNameMask); end

% Numbers precision
precision = 8; % bit for real double
time = SimulationTimec;
it = setHDF5TimeStepCountc;
% write associated XDMF file
fileID = fopen('openWithParaView.xmf','a');
fprintf(fileID,'  <Grid Name="mesh" GridType="Uniform">\n');
fprintf(fileID,'   <Topology TopologyType="3DRectMesh" NumberOfElements="%d %d %d"/>\n',Nzc,Nyc,Nxc);
fprintf(fileID,'   <Geometry GeometryType="VXVYVZ">\n');
fprintf(fileID,'    <DataItem Name="coordx" Dimensions="%g" NumberType="Float" Precision="%g" Format="HDF">\n',Nxc,precision);
fprintf(fileID,'     geometry.h5:/x_nodes\n');
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'    <DataItem Name="coordy" Dimensions="%g" NumberType="Float" Precision="%g" Format="HDF">\n',Nyc,precision);
fprintf(fileID,'     geometry.h5:/y_nodes\n');
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'    <DataItem Name="coordz" Dimensions="%g" NumberType="Float" Precision="%g" Format="HDF">\n',Nzc,precision);
fprintf(fileID,'     geometry.h5:/z_nodes\n');
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Geometry>\n');
fprintf(fileID,'   <Time TimeType="Single" Value="%g"/>\n',time);
fprintf(fileID,'   <Attribute Name="U" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/U%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="V" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/V%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="W" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/W%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="UVWMag" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/UVWMag%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="T" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/T%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="P" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/P%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'   <Attribute Name="Mask" AttributeType="Scalar" Center="Node">\n');
fprintf(fileID,'    <DataItem Dimensions="%d %d %d" NumberType="Float" Precision="%d" Format="HDF">\n',Nzc,Nyc,Nxc,precision);
fprintf(fileID,'     fields.h5:/Mask%g\n',it);
fprintf(fileID,'    </DataItem>\n');
fprintf(fileID,'   </Attribute>\n');
fprintf(fileID,'  </Grid>\n');
fclose(fileID);
