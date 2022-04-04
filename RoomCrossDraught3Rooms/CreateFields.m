%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% File for initializing simulation parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (UseRestart==0)
 U = (zeros(Ny, Nx, Nz));  % x-velocity
 V = (zeros(Ny, Nx, Nz));  % y-velocity
 W = (zeros(Ny, Nx, Nz));  % temperature
 P = (zeros(Ny, Nx, Nz));  % pressure
 T = (zeros(Ny, Nx, Nz));  % transported scalar
 UVWMag = (zeros(Ny, Nx, Nz));  % velocity mag
end

SU = (zeros(Ny, Nx, Nz)); %Initialize the source terms in the momentum equation (x-direction)
SV = (zeros(Ny, Nx, Nz)); %Initialize the source terms in the momentum equation (y-direction)
SW = (zeros(Ny, Nx, Nz)); %Initialize the source terms in the momentum equation (z-direction)
ST = (zeros(Ny, Nx, Nz));
Beta = (ones(Ny, Nx, Nz));  % The obstacle matrix

DivDivUXX = (zeros(Ny,Nx, Nz)); % Placeholders for the high-order spatial derivatives required by hyperviscity model
DivDivUYY = (zeros(Ny,Nx, Nz));
DivDivUZZ = (zeros(Ny,Nx, Nz));
DivDivVXX = (zeros(Ny,Nx, Nz));
DivDivVYY = (zeros(Ny,Nx, Nz));
DivDivVZZ = (zeros(Ny,Nx, Nz));
DivDivWXX = (zeros(Ny,Nx, Nz));
DivDivWYY = (zeros(Ny,Nx, Nz));
DivDivWZZ = (zeros(Ny,Nx, Nz));
DivDivTXX = (zeros(Ny,Nx, Nz));
DivDivTYY = (zeros(Ny,Nx, Nz));
DivDivTZZ = (zeros(Ny,Nx, Nz));

UX = (zeros(Ny, Nx, Nz));  % Gradient components of the velocity (x-direction)
UY = (zeros(Ny, Nx, Nz));
UZ = (zeros(Ny, Nx, Nz));
VX = (zeros(Ny, Nx, Nz));  % Gradient components of the velocity (y-direction)
VY = (zeros(Ny, Nx, Nz));
VZ = (zeros(Ny, Nx, Nz));
WX = (zeros(Ny, Nx, Nz));  % Gradient components of the velocity (z-direction)
WY = (zeros(Ny, Nx, Nz));
WZ = (zeros(Ny, Nx, Nz));

UMean = (zeros(Ny, Nx, Nz));  % Temporally averaged x-velocity
VMean = (zeros(Ny, Nx, Nz));  % Temporally averaged y-velocity
WMean = (zeros(Ny, Nx, Nz));  % Temporally averaged z-velocity
UVWMagMean = (zeros(Ny, Nx, Nz));  % Temporally averaged magnitude of velocity

CO2Mean = []; % Temporally averaged mean CO2 content
CO2MeanVar = []; % Temporally averaged variance in the CO2 content
CO2MeanTimes = []; % Averaging sampling time

SimulationTime = 0.0;

%%%%%%%%%%%%%%
% wave vectors
%%%%%%%%%%%%%%
kx1 = mod(1/2 + (0:(Nx-1))/Nx, 1 ) - 1/2;
ky1 = mod(1/2 + (0:(Ny-1))/Ny, 1 ) - 1/2;
kz1 = mod(1/2 + (0:(Nz-1))/Nz, 1 ) - 1/2;
kx  = kx1*(2*pi/dx); % wavenumbers
ky  = ky1*(2*pi/dy); % wavenumbers
kz  = kz1*(2*pi/dy); % wavenumbers

inx = 1:Nx; iny = 1:Ny; inz = 1:Nz;
east = inx + 1; east(Nx) = 1;
west = inx - 1; west(1) = Nx;
north = iny + 1; north(Ny) = 1;
south = iny - 1; south(1) = Ny;
front = inz + 1; front(Nz) = 1;
back = inz - 1; back(1) = Nz;

[KX,KY,KZ] = meshgrid(kx,ky,kz);

clear kx1 ky1 kz1 kx ky kz;

minX = min(min(min(X)));
maxX = max(max(max(X)));
minY = min(min(min(Y)));
maxY = max(max(max(Y)));
minZ = min(min(min(Z)));
maxZ = max(max(max(Z)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runge-Kutta 4 coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a1= 1/6; a2 = 1/3; a3 = 1/3; a4 = 1/6;
b1=0.5; b2=0.5; b3=1; b4=1;
a=[a1 a2 a3 a4]; b=[b1 b2 b3 b4];

if (UseRestart==0)
 CreateGeometry;
end

CreateSourceMasks;

ObstacleVels;
[U,V,W,P] = Project(U,V,W,KX,KY,KZ,P,Beta,dx,dy,dz,east,west,north,south,front,back,inx,iny,inz);

Uold=(U); Vold=(V); Wold=(W);
Uc=(U); Vc=(V); Wc=(W);
dU=(0*U); dV=(0*V); dW=(0*W);
