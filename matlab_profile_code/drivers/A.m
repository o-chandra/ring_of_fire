function out = A(x,lambda,s,p)

temp = soln(x,s);

u = temp(1);
v = temp(3);


[ru,dru] = react(u);


wx = Wz(x,p.wx);
c = p.wave_speed;

out = [ 0, 1, 0, 0;
    lambda+s.xi^2-v*dru+p.l, wx-c, -ru, 0;
    0, 0, 0, 1;
    (lambda+p.beta*v*dru)/p.eps,0, p.beta*ru/p.eps+s.xi^2,-c/p.eps];


