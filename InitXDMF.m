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

FieldName = sprintf('fields.h5');
if isfile(FieldName), delete (FieldName); end
FieldName = sprintf('geometry.h5');
if isfile(FieldName), delete (FieldName); end
FieldName = sprintf('particles.h5');
if isfile(FieldName), delete (FieldName); end
if isfile('particles.raw'), delete particles.raw; end

% write associated XDMF file
fileID = fopen('openWithParaView.xmf','w');
fprintf(fileID,'<?xml version="1.0" ?>\n');
fprintf(fileID,'<!DOCTYPE Xdmf SYSTEM "Xdmf.dtd" []>\n');
fprintf(fileID,'<Xdmf Version="2.0">\n');
fprintf(fileID,' <Domain>\n');
fprintf(fileID,'  <Grid Name="mesh" GridType="Collection" CollectionType="Temporal">\n');
fclose(fileID);
