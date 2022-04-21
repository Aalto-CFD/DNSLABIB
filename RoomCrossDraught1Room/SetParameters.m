UseRestart = 0; % Set to 1 if restarting a simulation by loading a "room.mat" file

parallel.gpu.enableCUDAForwardCompatibility(true);

PermutationMatrix = [2 1 3];

if (UseRestart == 1)
    load('room.mat');
    xOld = x; yOld = y; zOld = z;
    XOld = X; YOld = Y; ZOld = Z;
end
UseRestart = 0;

finalRun = 1;

% Nx          = 430;
% Ny          = 430;
% Nz          = 180;

Nx          = 86;
Ny          = 86;
Nz          = 36;

Lx          = 8.6;    % Domain length
Ly          = 8.6;    % Domain width
Lz          = 3.6;    % Domain depth

nu = 1.6e-5;

WallSmoothingFactor = 50.0;

Umax = 1.0;
Vmax = 0.0;
Wmax = 0.0;

Tset = 0.0;

dx = Lx/(Nx);     % grid spacing dx
dy = Ly/(Ny);     % grid spacing dy
dz = Lz/(Nz);	  % grid spacing dz

CoEstMaxConv = 0.1; %Evaluate the appropriate timestep dt based on the Courant number regarding convective and diffusive transport
CoEstMaxDiff = 0.1;
dt = min(min(dx,dy),dz)*CoEstMaxConv/max(max(abs(Umax),abs(Vmax)),abs(Wmax));
dtDiff = (min(min(dx,dy),dz).^2)*CoEstMaxDiff/nu;
dt = min(dt,dtDiff);
dt = 1.0e-5*dt;

simutimeSeconds = 201.001;
simutimeSteps   = round(simutimeSeconds/dt); % how many timesteps altogether
visualize       = 0; % set 0 for speed-up

printTimeBegin = 0.02;
printTimeStop = 200.2;
setHDF5TimeStepCountMax = 10;
setHDF5TimeStepArray = linspace(printTimeBegin,printTimeStop,setHDF5TimeStepCountMax+1);
setHDF5TimeStepCount = 0;
dtPrint = abs(printTimeStop-printTimeBegin)/(setHDF5TimeStepCountMax-1);
dtCO2TimeAveragingInterval = abs(printTimeStop-printTimeBegin)/(420);
updateMeanCO2Field = printTimeBegin;

%%%%%%%%%%%%%%%%%%%%
% create the 3D grid
%%%%%%%%%%%%%%%%%%%%
x = (Lx-dx)*(0:(Nx-1))/(Nx-1); % to be precise, dx is subtracted here
y = (Ly-dy)*(0:(Ny-1))/(Ny-1); % otherwise the derivative of
                               % e.g. sin(x) wouldnt be
                               % differentiable on this periodic
                               % grid
z = (Lz-dz)*(0:(Nz-1))/(Nz-1);

dnoz = 0.014;

useHDF5 = 1;
UseGPU = 1;

[X,Y,Z] = meshgrid(x,y,z);

TPartSet = 0;

xMinPart = min(x); xMaxPart = max(x); yMinPart = min(y);
yMaxPart = max(y); zMinPart = min(z); zMaxPart = max(z);
