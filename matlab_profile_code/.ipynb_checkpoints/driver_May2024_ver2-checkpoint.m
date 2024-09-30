clc;  close all; beep off; clear all;

% parameters
p.vstar = 0.1;
p.l = 0.02688; % always fixed
p.a = 0;

% speed_guess = -0.0855;

speed_guess = -0.0854708;



u = linspace(1e-3,3,1000);
Y = p.vstar*exp(-1./u)-p.l*u;
% plot(u,Y,'LineWidth',2);

index = find(Y(1:end-1).*Y(2:end) < 0);

fun = @(u) p.vstar*exp(-1./u)-p.l*u;

fp1 =  find_fixed_point(u(index(1)),u(index(1)+1),fun);
fp2 = find_fixed_point(u(index(2)),u(index(2)+1),fun);


Jac = @(u,p,c_star) [0, 1; -p.vstar*exp(-1/u(1)+1e-10)/(u(1)+1e-10)^2+p.l, -c_star];







% return

% solve the profile

AM = profile_jacobian_neg_inf([0;0],speed_guess,p);
[V,D] = eigs(AM);
index = find(diag(D)==max(real(diag(D))));
vec = V(:,index);

y0 = -1e-5*vec;

ode = @(x,y)profile_ode_phase(x,y,speed_guess,p);

options = odeset('RelTol',1e-10,'AbsTol',1e-10);

sol = ode15s(ode,[0,110],y0,options);

figure;
hold on;
plot(0,0,'.k','MarkerSize',18);
plot(fp2,0,'.k','MarkerSize',18);
plot(sol.y(1,:),sol.y(2,:),'-k','LineWidth',2);






% s.something = 0;
% ode = @(x,y,s,p)profile_ode_phase(x,y,speed_guess,p);
% 
% restpnt = [0,0; fp1,0; fp2,0];
% 
% box = [-0.1,1.1*fp2,-0.1,0.5];
% time =100;
% plot_more = 'on';
% num1 = 5;
% num2 = 5;
% phase_portrait2(ode,@(u,p)Jac(u,p,speed_guess),restpnt,box,time,plot_more,num1,num2,p,s);
% return

%
% Solve BVP
%

ode = @(x,y,speed)profile_ode(x,y,speed,p);

L = 55;

s.UL = [0;0];
s.UR = [fp2;0];

s.larray = [3,4];
s.rarray = [1,2];
s.phase = 0.5*(s.UL(1)+s.UR(1));

pre_bc = @(ya,yb,speed)bc_fun(ya,yb,speed,p,s);

x_dom = linspace(0,L,55);

% pre_guess = @(x)guess(x,s);

pre_guess = @(x)[deval(sol,x+55);deval(sol,55-x)];

s.bvp_options = bvpset('RelTol', 1e-10, 'AbsTol', 1e-10,'Nmax', 20000);
solinit = bvpinit(x_dom,pre_guess,speed_guess);
s.sol = bvp5c(ode,pre_bc,solinit,s.bvp_options);
s.side = 1;
s.I = L;
s.R = L;
s.L = -L;


figure; hold on;
dom = linspace(-L,L,4000);
y = zeros(2,length(dom));
for j = 1:length(dom)
    y(:,j) = soln(dom(j),s);
end
plot(dom,y,'-k','LineWidth',2);
% plot(s.sol.x,s.sol.y(1:2,:),'-r','LineWidth',2);



scale = 1.1;

for j = 1:10

    old_L = s.R;
    new_L = old_L*scale;
    
    x_dom = linspace(0,new_L,30);
    
    guess = @(x)deval(s.sol,(x/new_L)*old_L);
    
    solinit = bvpinit(x_dom,guess,s.sol.parameters);
    
    s.sol = bvp5c(ode,pre_bc,solinit,s.bvp_options);
    s.side = 1;
    s.I = new_L;
    s.R = new_L;
    s.L = -new_L;
    
    clf;
    hold on;

    dom = linspace(-new_L,new_L,4000);
    y = zeros(2,length(dom));
    for j = 1:length(dom)
        y(:,j) = soln(dom(j),s);
    end
    plot(dom,y,'-k','LineWidth',2);
    drawnow;

end



s




figure;
hold on;

dom = linspace(-new_L,new_L,4000);
y = zeros(2,length(dom));
for j = 1:length(dom)
    y(:,j) = soln(dom(j),s);
end
plot(dom,y,'-b','LineWidth',2);
drawnow;

old_c = s.sol.parameters


p.a = -0.05;


x_dom = linspace(0,s.R,30);

guess = @(x)deval(s.sol,x);


alpha = 0.5;
s.phase=(alpha*s.UL(1)+(1-alpha)*s.UR(1));


pre_bc = @(ya,yb,speed)bc_fun(ya,yb,speed,p,s);

ode = @(x,y,speed)profile_ode(x,y,speed,p);

solinit = bvpinit(x_dom,guess,s.sol.parameters);

s.sol = bvp5c(ode,pre_bc,solinit,s.bvp_options);



y = zeros(2,length(dom));
for j = 1:length(dom)
    y(:,j) = soln(dom(j),s);
end
plot(dom,y,'-k','LineWidth',2);
drawnow;

new_c = s.sol.parameters


p.c = new_c;

lambda_min = -p.l-(p.a+p.c)^2/4
% lambda_min_right = -p.l-(-p.a+p.c)^2/4

% lambda_min = max(lambda_min_left,lambda_min_right);


lambda = 0;


evans_fun = @(lambda) evans_function(lambda,s,p,options);

lambda_vals = linspace(-0.01,0.01,200);
D = zeros(size(lambda_vals));
for j = 1:length(lambda_vals)
    D(j) = evans_fun(lambda_vals(j));
end

figure;
hold on;
plot(lambda_vals,D,'-k','LineWidth',2);
plot([lambda_vals(1),lambda_vals(end)],[0,0],'-g','LineWidth',2);
plot([0,0],[min(D),max(D)],'-g','LineWidth',2);






% % plot the evans system solutions
% figure
% hold on
% plot(evans_left.x,evans_left.y,'-k','LineWidth',2);
% plot(evans_right.x,evans_right.y,'-b','LineWidth',2);

