% Clear the particle-related variables if in memory
clear ud vd wd xd yd zd dd ug vg wg gd rhog rhod Nd RRR Rep Cd alp bet taup;
% Set the total amount of Lagrangian particles to be tracked
Nd = 200;
% Set initial velocities if required
ud = 0.1*rand(Nd,1); vd = 0.01*(rand(Nd,1)-0.5); wd = 0.01*(rand(Nd,1)-0.5);
% Set the particle sizes
dd(1:180,1) = (1+29*rand(180,1))*10^(-6);
dd((181):Nd,1) = (90+10*rand(20,1))*10^(-6);
% Define the density of the interstitial medium
rhog = 1;
% Define the density of the particles
rhod = 1000;

% Define the gravitational constant
gd = -9.81;

% Provide the region in which the particle are initially created
xc = min(x) + 0.0125.*(max(x)-min(x));
yc = min(y) + 0.0125.*(max(y)-min(y));
zc = min(z) + (max(z)-min(z))/2;

% Create the particles. Make sure the particles are created within a radius of dnoz
% from xc, yc and zc

for(kkk=1:Nd)
    RRR=1000;
    while(RRR > dnoz)
    xd(kkk) = xc + 2*(rand-0.5)*dnoz;
    yd(kkk) = yc + 2*(rand-0.5)*dnoz;
    zd(kkk) = zc + 2*(rand-0.5)*dnoz;
    RRR = sqrt( (xd(kkk)-xc).^2 + (yd(kkk)-yc).^2 + (zd(kkk)-zc).^2 );
    end
end
xd=xd'; yd=yd'; zd=zd';
