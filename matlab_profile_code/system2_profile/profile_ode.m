function out = profile_ode(x,U,c,p)

U

u = U(1);
u_der = U(2);
v = U(3);
v_der = U(4);

[ru,~] = react(u);

out = [u_der;
    p.l*u-v*ru+(Wz(x,p.wx)-c)*u_der; 
    v_der; 
    (p.beta*v*ru-c*v_der)/p.eps];





