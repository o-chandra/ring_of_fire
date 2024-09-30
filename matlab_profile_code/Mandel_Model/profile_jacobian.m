function out = profile_jacobian(y,pars,p)

u = y(1);
v = y(3);

[ru,dru] = react(u);

out = [0, 1, 0; 
    p.l-v*dru, p.wx-pars, -ru; 
    (p.beta/pars)*v*dru,0,(p.beta/pars)*ru];