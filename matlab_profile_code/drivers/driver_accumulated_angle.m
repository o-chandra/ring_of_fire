clc;  beep off;
close all; 
clear all;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

p.vstar = 0.1;
p.l = 0.02688; % always fixed

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
% solve the profile
% -------------------------------------------------------------------------

p.a = 0.05;

N = 30;
alpha_vals = linspace(1e-3,1-1e-3,N);
eig_vals = zeros(size(alpha_vals));
c_vals = zeros(size(alpha_vals));

for j=1:length(alpha_vals)

    j

    p.alpha = alpha_vals(j);
     
    [p,s] = get_profile(p,s);
    
    fun_acc = @(omega)get_acc_angle(omega,s,p);

    eig_vals(j) = find_zero(-0.01,0,fun_acc);

    c_vals(j) = p.c;

end
  % plot_profile(s);

plot(c_vals,eig_vals,'-k','LineWidth',2);
h = xlabel('c');
set(h,'FontSize',18);
h = ylabel('eigenvalue');
set(h,'FontSize',18);

return

% -------------------------------------------------------------------------
% solve the accumulated angle
% -------------------------------------------------------------------------

% omega = 0;
% 
% 
% ode = @(x,theta) angle_ode(x,theta,omega,s,p);
% 
% options = odeset('RelTol',1e-8,'AbsTol',1e-8);
% 
% % eigenvalues of A = [0, 1; -dfv+omega,-p.c+Wz(-infty,p)]
% [fv,dfv] = f(s.UL(1),p);
% eg_LH_pos = (Wz(-1,p)-p.c+sqrt((p.c-Wz(-1,p))^2-4*(dfv-omega)))/2;
% eg_LH_neg = (Wz(-1,p)-p.c-sqrt((p.c-Wz(-1,p))^2-4*(dfv-omega)))/2;
% 
% % eigenvalues of A = [0, 1; -dfv+omega,-p.c+Wz(+infty,p)]
% [fv,dfv] = f(s.UR(1),p);
% eg_RH_pos = (Wz(1,p)-p.c+sqrt((p.c-Wz(1,p))^2-4*(dfv-omega)))/2;
% eg_RH_neg = (Wz(1,p)-p.c-sqrt((p.c-Wz(1,p))^2-4*(dfv-omega)))/2;
% 
% sol_angle = ode15s(ode,[s.L,s.R],eg_LH_pos,options);
% 
% figure;
% plot(sol_angle.x,sol_angle.y,'-k','LineWidth',2);
% 
% 
% 
% out = mod(sol_angle.y(end)-eg_RH_neg-pi,2*pi)-pi;
% 
% omega = 0;
% [~,dfv] = f(s.UL(1),p);
% 
% eg_LH_pos = (Wz(-1,p)-p.c+sqrt((p.c-Wz(-1,p))^2-4*(dfv-omega)))/2;
% atan(eg_LH_pos)
% 
% x = -10;
% theta = 0.2;
% omega = -0.01;
% angle_ode(x,theta,omega,s,p)
% 
% get_acc_angle(0,s,p);
% 
% 
% return


omega_vals = linspace(-0.01,0,100);
acc_omega = zeros(size(omega_vals));

for j = 1:length(acc_omega)
    j
    acc_omega(j) = get_acc_angle(omega_vals(j),s,p);
end

figure;
plot(omega_vals,acc_omega,'-k','LineWidth',2);
