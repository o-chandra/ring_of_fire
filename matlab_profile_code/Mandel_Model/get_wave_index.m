function [term,sol] = get_wave_index(p,S0,c_value,tspan,options,plot_it)

p.c = c_value; % wave speed 
ode = @(x,y)profile_ode(x,y,p.c,p); % profile ODE

% obtain the projections at negative infinity
M = [0, 1; 
    p.l, p.wx-p.c];


[V,D] = eigs(M);
ind_pos = find(real(diag(D))>0);

% obtain the initial condition
% y_pos = [1e-5*V(:,ind_pos)/V(1,ind_pos);S0];
y_pos = [-1e-5*V(:,ind_pos);S0]


% compute the ODE solution
sol=ode15s(ode,tspan,y_pos,options);

% copmute the index 
term = dot(sol.y(1:2,2)-sol.y(1:2,1),sol.y(1:2,end)-sol.y(1:2,end-1));

if strcmp(plot_it,'on')
    
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
    
end


