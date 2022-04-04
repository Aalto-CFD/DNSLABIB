%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DNSLABIB code shared under a license, see LICENSE.
% The code may or may not function on a GPU. Nevertheless, the code
% may be executable also on newer Matlab versions on a regular CPU without
% compatible GPU.
% This code was used in a publication to study the turbulent flow associated
% with ventilation setups.
% https://www.sciencedirect.com/science/article/pii/S0925753520302630
% The code is based on the pseudo-spectral solution of incompressible
% Navier-Stokes equations with RK4 time integration utilizing the
% projection method. The model represents low speed isothermal air.
% The fluid solver is an extension of the NS3dLab
% code https://www.sciencedirect.com/science/article/pii/S0010465516300388,
% implementing the Immersed Boundary (IB) method to incorporate solid obstacles.
% A scalar transport equation is solved to mimic a passive scalar/aerosol
% concentration.
% A lagrangian droplet tracking approach is used to simulate droplets in
% turbulence.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CheckRestartStatus;

while(SimulationTime < simutimeSeconds)
t = t + 1;
SolveNavierStokes;
SolveScalar;
AdvanceDrops;

if(floor(t/100)==t/100)
disp('Time = ');
disp(SimulationTime);
end

AdjustDt;

CalcTemporalMeans;

if (useHDF5==1)
	WriteHDF5;
end

end

if (finalRun == 1 & useHDF5 == 1)
	EndXDMF;
end
save ('room.mat','-v7.3','U','V','W','UMean','VMean','WMean','CO2MeanTimes','CO2Mean','CO2MeanVar', ...
'UVWMagMean','P','T','x','y','z','X','Y','Z','SimulationTime','t','Chi','xd','yd', ...
'zd','ud','vd','wd','ug','vg','wg','Nd','dd','gd','rhog','rhod','RRR','Rep','Cd','alp','bet','taup', ...
'EKin','EKinDt','EkinProd','EKinTime','Beta','SourceMaskFunction1','SourceMaskFunction2','SourceMaskFunction3','SourceMaskFunction4');
