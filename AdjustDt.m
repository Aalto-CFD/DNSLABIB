%Adjust the time step based on the condition provided by the Courant number 

% Increment the simulation time based on the previous value of dt
SimulationTime = SimulationTime + dt;

% Increase dt
dt = dt*1.1;

% Now define the new Courant number in each direction independently
CoX = max(max(max(abs(U))))*dt/dx;
CoY = max(max(max(abs(V))))*dt/dy;
CoZ = max(max(max(abs(W))))*dt/dz;

% Check whether the set Courant number is violated with the increased time-step dt
% Reduce the time-step by multiplying with a factor of 0.8 as long as the condition is violated
while (CoX > CoEstMaxConv | CoY > CoEstMaxConv | CoZ > CoEstMaxConv)
    dt = dt*0.8;
CoX = max(max(max(abs(U))))*dt/dx;
CoY = max(max(max(abs(V))))*dt/dy;
CoZ = max(max(max(abs(W))))*dt/dz;
end

% Additionally, check that the diffusive time scale or the print interval is not exceeded
dt = min(dt,dtDiff);
dt = min(dt,dtPrint/2.0);
