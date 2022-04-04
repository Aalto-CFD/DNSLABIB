% Set the Neumann boundary conditions for the
% passive scalar field

Tc(BetaXFSetThis ~= 0) = Tc(BetaXFBC ~= 0);
Tc(BetaXBSetThis ~= 0) = Tc(BetaXBBC ~= 0);
Tc(BetaYFSetThis ~= 0) = Tc(BetaYFBC ~= 0);
Tc(BetaYBSetThis ~= 0) = Tc(BetaYBBC ~= 0);
Tc(BetaZFSetThis ~= 0) = Tc(BetaZFBC ~= 0);
Tc(BetaZBSetThis ~= 0) = Tc(BetaZBBC ~= 0);

T(BetaXFSetThis ~= 0) = T(BetaXFBC ~= 0);
T(BetaXBSetThis ~= 0) = T(BetaXBBC ~= 0);
T(BetaYFSetThis ~= 0) = T(BetaYFBC ~= 0);
T(BetaYBSetThis ~= 0) = T(BetaYBBC ~= 0);
T(BetaZFSetThis ~= 0) = T(BetaZFBC ~= 0);
T(BetaZBSetThis ~= 0) = T(BetaZBBC ~= 0);
