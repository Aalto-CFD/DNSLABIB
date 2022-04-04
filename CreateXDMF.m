%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Visualize a Matlab 3D-arrays in Paraview/VisIt using HDF5 & XDMF
%
%               Coded by Manuel Diaz, ENSMA, 2020.07.28.
%                   Copyright (c) 2020, Manuel Diaz.
%                           All rights reserved.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Remarks:
%    1. This snippet exemplifies how to export a 3D array into ParaView as
%    a 3DRectMesh. This is a classical approach to export large volumes of
%    data preferred in High Perfomance Computations (HPC).
%             ( like reading/writting [10,000]^3 arrays )
%    2. This example outputs 3 files: the geometry.h5, the field.h5 and
%    the solution.xmf. The 3 files are required to be in the same folder.
%    But for opening the array in ParaView/Visit, only the *.xmf file is
%    initially required. ParaView/VisIt will then load the two h5-files.
%    3. When exporting data from Matlab/Fortran observe that the data is
%    transposed. This is because Matlab (like Fortran) store data in memory
%    using a column-major order, but HDF5 and ParaView are C-based
%    applications that store data using a row-major order. More details can
%    be found at:
%        https://support.hdfgroup.org/HDF5/doc1.6/UG/12_Dataspaces.html
%    4. XDMF stands for eXtensible Data Model and Format. Is a standardized
%    approach to exchange scientific data between HPC codes. For further
%    details, I refer to:
%        http://www.xdmf.org/
%    5. Matlab supports natively HDF5 format, actually *.mat files use the
%    hdf5 technology on the background. So using h5-files are highly
%    encouraged to read/write/share data.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create geometry file
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
