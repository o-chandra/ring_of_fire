function out = profile_jacobian(U,p,c,x)

u = U(1);
v = U(3);

[ru,dru] = react(u);

out = [0,1,0,0;
    p.l-v*dru, Wz(x,p.wx)-c,-ru,0;
    0,0,0,1;
    p.beta*v*dru/p.eps,0,p.beta*ru/p.eps,-c/p.eps];





