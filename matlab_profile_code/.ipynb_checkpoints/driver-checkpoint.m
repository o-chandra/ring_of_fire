clc;  close all; beep off; clear all;

% parameters
p.vstar = 0.1;
p.l = 0.02688; % always fixed

u = linspace(1e-3,3,1000);
Y = p.vstar*exp(-1./u)-p.l*u;
plot(u,Y,'LineWidth',2);




index = find(Y(1:end-1).*Y(2:end) < 0);

fun = @(u) p.vstar*exp(-1./u)-p.l*u;

fp1 =  find_fixed_point(u(index(1)),u(index(1)+1),fun)
fp2 = find_fixed_point(u(index(2)),u(index(2)+1),fun)

Jac = @(u,s,c_star) [0, 1; -p.vstar*exp(-1/u)/u^2+p.l, -c_star];









% return

% solve the profile
speed_guess = -1.085;

L = 100;

s.UL = [0;0];
s.UR = [2.489577798082896;0];

s.larray = [3,4];
s.rarray = [1,2];
s.phase = 0.5*(s.UL(1)+s.UR(1));

ode = @(x,y,speed)profile_ode(x,y,speed,p);

pre_bc = @(ya,yb,speed)bc_fun(ya,yb,speed_guess,p,s);

x_dom = linspace(0,L,30);

pre_guess = @(x)guess(x,s);

s.bvp_options = bvpset('RelTol', 1e-6, 'AbsTol', 1e-8,'Nmax', 20000);
solinit = bvpinit(x_dom,pre_guess,speed_guess);
s.sol = bvp5c(ode,pre_bc,solinit,s.bvp_options);



