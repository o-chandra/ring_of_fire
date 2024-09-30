function out = profile_bc(ya,yb,pars,p)

fp = zeros(3,1);
jac = profile_jacobian(fp,pars,p);

PL = real(orth(projection1(jac,-1,1e-12))).';

PR = real(orth(projection1(jac,1,1e-12))).';

out = [PL*(ya(1:3)-[0;0;1]);...
    PR*(ya(4:6)-[0;0;0]); ...
    yb(3)-p.v_mid; ...
    yb(1:3)-yb(4:6)];





