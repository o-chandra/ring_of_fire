clc;  beep off;
close all; 
clear all;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

p.vstar = 0.1;
p.l = 0.02688; % always fixed
speed_guess = -0.0854708;

a = 0.05;

N = 30;
alpha_vals = linspace(0,1,N+2);
alpha_vals = alpha_vals(2:end-1);

% -------------------------------------------------------------------------
% get the fixed points
% -------------------------------------------------------------------------

u = linspace(1e-3,3,1000);
Y = p.vstar*exp(-1./u)-p.l*u;
% plot(u,Y,'LineWidth',2);

index = find(Y(1:end-1).*Y(2:end) < 0);

fun = @(u) p.vstar*exp(-1./u)-p.l*u;

fp1 =  find_zero(u(index(1)),u(index(1)+1),fun);
fp2 = find_zero(u(index(2)),u(index(2)+1),fun);

s.UL = [0;0];
s.UR = [fp2;0];

% -------------------------------------------------------------------------
% solve the profile equation for c_star
% -------------------------------------------------------------------------

p.alpha = 0.5;

p.a = a;

x = 10;
y = [0.5*s.UR(1);0.1;0.5*s.UR(1);0.1];
c = speed_guess;

profile_ode(x,y,c,p)
-profile_ode(-x,y,c,p)

ya = [1,2,3,4].';
yb = [-4,-3,2,1].';
s.I = 150
s.L = -s.I;
s.R = s.I;
s.side = 1;
s.rarray = [1,2];
s.larray = [3,4];
s.phase = p.alpha*s.UL(1)+(1-p.alpha)*s.UR(1);
s.bvp_options = bvpset('RelTol', 1e-10, 'AbsTol', 1e-10,'Nmax', 20000);



bc_fun(ya,yb,speed_guess,p,s)

return

s.I = 150;
s.scale = 0.1;


guess_fun = @(x)guess(x,s);
s = solve_profile(s,p,speed_guess,guess_fun);
p.cstar = s.sol.parameters;

plot_profile(s);



p.a = a;

p.alpha = 0.5
    
guess_fun = @(x)[soln(x,s);soln(-x,s)];


s = solve_profile(s,p,speed_guess,guess_fun);
p.c = s.sol.parameters;


hold on;
dom = linspace(s.L,s.R,4000);
y = zeros(2,length(dom));
for j = 1:length(dom)
    y(:,j) = soln(dom(j),s);
end
plot(dom,y,'-r','LineWidth',2);
h = xlabel('x');
set(h,'FontSize',18);
h = ylabel("u,u'");
set(h,'FontSize',18);
h = gca;
set(h,'FontSize',18);


