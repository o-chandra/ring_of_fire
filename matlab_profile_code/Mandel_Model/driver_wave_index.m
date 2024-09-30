
clc;  beep off;
close all; 
clear all;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

p.l = 0.02688; % always fixed
p.wx = -0.05;
p.beta = 0.1;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

% tspan = [0,600];
% c_left = 1.1;
% c_right = 0.01;
% S0 = 0.99;


p.l = 1;
p.beta = 1;
p.wx = 0;

tspan = [0,33];
c_left = 1.3;
c_right = 1.37;
S0 = 0.99;

options=odeset('AbsTol',10^(-10),'RelTol',10^(-10));

[p,sol] = determine_c(p,S0,c_left,c_right,tspan,options,'on');

p.SL = sol.y(3,1);
p.SR = sol.y(3,end);

L = tspan(2)/2;
temp = deval(sol,L);
p.Smid = temp(3);

ode = @(x,y,c)[profile_ode(x,y(1:3),c,p);profile_ode(x+L,y(4:6),c,p)];


    figure
    hold on;
    plot3(sol.y(1,:),sol.y(2,:),sol.y(3,:),'-k','LineWidth',2);
    h = xlabel('T');
    set(h,'FontSize',18);
    h = ylabel('T_x');
    set(h,'FontSize',18);
    h = zlabel('S');
    set(h,'FontSize',18);
    h = gca;
    set(h,'FontSize',18);











