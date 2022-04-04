% Enforce the set value Tset in the passive scalar equation
% in the desired region conveyed by SourceMaskFunction

function [ST] = CreatePSSourceMask(SourceMaskFunction,ST,T,Tset,dt)

ST = ST + (1.0/(3.0*dt)).*(Tset-T).*SourceMaskFunction;

end

