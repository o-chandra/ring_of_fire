function out = profile_ode(~,y,pars,p)

u = y(1);
z = y(2);
v = y(3);

ru = react(u);

out = [z;
    (p.wx-pars)*z-v*ru+p.l*u;
    (p.beta/pars)*v*ru];








