% Include this in the main simulation loop
% if you wish to extract the rate of change for the kinetic energy

EKinOld = EKin; % Save the old kinetic energy content
EKin = 0.5*sum(sum(sum((U.^2 + V.^2 + W.^2)*dx*dy*dz))); % Evaluate the new kinetic energy content
EKinDt = [EKinDt; (EKin - EKinOld)/dt]; % Update the time derivative of the kinetic energy and append it to an array
[UX,UY,UZ] = Grad(U(iny,east,inz),U(iny,west,inz),U(north,inx,inz),U(south,inx,inz),U(iny,inx,front),U(iny,inx,back),dx,dy,dz); % Calculate the gardients for the x-component of the velocity
[VX,VY,VZ] = Grad(V(iny,east,inz),V(iny,west,inz),V(north,inx,inz),V(south,inx,inz),V(iny,inx,front),V(iny,inx,back),dx,dy,dz); % Calculate the gardients for the y-component of the velocity
[WX,WY,WZ] = Grad(W(iny,east,inz),W(iny,west,inz),W(north,inx,inz),W(south,inx,inz),W(iny,inx,front),W(iny,inx,back),dx,dy,dz); % Calculate the gardients for the z-component of the velocity
Chi = [Chi; -nu.*sum(sum(sum((sqrt(UX.^2 + UY.^2 + UZ.^2 + VX.^2 + VY.^2 + VZ.^2 + WX.^2 + WY.^2 + WZ.^2).^2)*dx*dy*dz)))]; % Evaluate and append the viscous dissipation of energy in the flow domain to an array
EkinProd = [EkinProd; sum(sum(sum((SU.*U + SV.*V + SW.*W)*dx*dy*dz)))]; % Calculate the kinetic energy increase/decrease produced by the momentum source terms
EKinTime = [EKinTime; SimulationTime]; % Keep a record of the simulation time at which these values were obtained
