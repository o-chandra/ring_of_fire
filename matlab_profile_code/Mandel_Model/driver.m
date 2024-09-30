clc;  beep off;
close all; 
clear all;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

p.l = 0.02688; % always fixed
p.wx = 0.05;
p.beta = 0.1;

% -------------------------------------------------------------------------
% controls
% -------------------------------------------------------------------------

L = 100;

p.v_mid = 0.5;

speed_guess = -0.0854708;

x_dom = linspace(-L,0,31);

ode_fun = @(x,y,c) [profile_ode(x,y(1:3),c,p);-profile_ode(-x,y(4:6),c,p)];

bc_fun = @(ya,yb,c)profile_bc(ya,yb,c,p);

scl = 0.1;
guess_fun = @(x) [sech(scl*x); ...
    -scl*tanh(scl*x).*sech(scl*x); ...
    0.5*(1-tanh(scl*x));...
    sech(-scl*x); ...
    -scl*tanh(-scl*x).*sech(-scl*x); ...
    0.5*(1-tanh(-scl*x))];

bvp_options = bvpset('RelTol', 1e-8, 'AbsTol', 1e-8,'Nmax', 20000);

solinit = bvpinit(x_dom,guess_fun,speed_guess);

sol = bvp5c(ode_fun,bc_fun,solinit,bvp_options);
p.wave_speed = sol.parameters;

s.sol = sol;
s.side = -1;
s.L = -L;
s.R = L;
s.I = L;
s.larray = [1 2 3 ];
s.rarray = [4 5 6];





figure;
hold on;
plot(sol.x,sol.y([1,3],:),'-k','LineWidth',2);
plot(-sol.x,sol.y([4,6],:),'-k','LineWidth',2);
h = xlabel('x');
set(h,'FontSize',18);




figure;
hold on;
plot(sol.y(1,:),sol.y(3,:),'-k','LineWidth',2);
plot(sol.y(4,:),sol.y(6,:),'-k','LineWidth',2);
h = xlabel('u');
set(h,'FontSize',18);
h = ylabel('v');
set(h,'FontSize',18);