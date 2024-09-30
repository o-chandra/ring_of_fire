function out = profile_bc(ya,yb,c,p)

fp2 = [0;0;0;0];

jacL = profile_jacobian([0;0;1;0],p,c,-1);
jacR = profile_jacobian(fp2,p,c,1);

PL = real(orth(projection1(jacL,-1,1e-12))).';

PR = real(orth(projection1(jacR,1,-1e-12))).';

out = [PL*(ya(1:4)-[0;0;1;0]);PR*(ya(5:8)-fp2);yb(1:4)-yb(5:8)];
