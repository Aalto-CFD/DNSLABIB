taup =  (rhod*dd.^2)/(18*rhog*nu); % droplet timescale
Rep = sqrt( abs(vd-vg).^2 + abs(ud-ug).^2+ abs(wd-wg).^2).*dd/nu; % Re

Cd = (1+(1/6)*Rep.^(2/3)); % drag coefficient
Ndactive = Nd;

TPartSet = TPartSet + 1;

% Euler impl.
alp = 1./(1+dtd*Cd./taup); bet = dtd*(Cd./taup)./(1+dtd*Cd./taup);
ud(1:Ndactive) = alp.*ud(1:Ndactive) + bet.*ug(1:Ndactive);
vd(1:Ndactive) = alp.*vd(1:Ndactive) +  bet.*vg(1:Ndactive);
wd(1:Ndactive) = alp.*wd(1:Ndactive) +  bet.*wg(1:Ndactive) + gd*dtd*alp;

if (TPartSet == 300)
    ud(1:Ndactive) = ug(1:Ndactive);
    vd(1:Ndactive) = vg(1:Ndactive);
    wd(1:Ndactive) = wg(1:Ndactive);
end

xd(1:Ndactive)=xd(1:Ndactive) + ud(1:Ndactive)*dtd;
yd(1:Ndactive)=yd(1:Ndactive) + vd(1:Ndactive)*dtd;
zd(1:Ndactive)=zd(1:Ndactive) + wd(1:Ndactive)*dtd;
