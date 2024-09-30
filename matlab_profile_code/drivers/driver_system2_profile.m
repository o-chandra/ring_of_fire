clc;  beep off;
close all; 
clear all;

% -------------------------------------------------------------------------
% parameters
% -------------------------------------------------------------------------

p.vstar = 0.1;
p.l = 0.02688; % always fixed
speed_guess = -0.0854708;
p.c = speed_guess;
p.wx = 0.05;
p.beta = 0.1;
p.eps = 0.1;
L = 100;

beta_vals = linspace(0.1,0.01,30);

x_dom = linspace(-L,0,31);

ode_fun = @(x,y,c) [profile_ode(x,y(1:4),c,p);-profile_ode(-x,y(5:8),c,p)];

bc_fun = @(ya,yb,c)profile_bc(ya,yb,c,p);

scl = 0.1;
guess_fun = @(x) [sech(scl*x);-scl*tanh(scl*x).*sech(scl*x);0.5*(1-tanh(scl*x));...
    -0.5*scl*sech(scl*x).^2;...
    sech(-scl*x);-scl*tanh(-scl*x).*sech(-scl*x); 0.5*(1-tanh(-scl*x));...
    -0.5*scl*sech(-scl*x).^2];

bvp_options = bvpset('RelTol', 1e-10, 'AbsTol', 1e-10,'Nmax', 20000);

solinit = bvpinit(x_dom,guess_fun,speed_guess);

sol = bvp5c(ode_fun,bc_fun,solinit,bvp_options);
p.wave_speed = sol.parameters;

s.sol = sol;
s.side = -1;
s.L = -L;
s.R = L;
s.I = L;
s.larray = [1 2 3 4];
s.rarray = [5 6 7 8];

figure;
for j = 1:length(beta_vals)

    disp(j);

    clf;
    hold on;
    plot(sol.x,sol.y([1,3],:),'-k','LineWidth',2);
    plot(-sol.x,sol.y([5,7],:),'-k','LineWidth',2);
    h = xlabel('x');
    set(h,'FontSize',18);
    drawnow;

    
    p.beta = beta_vals(j);
    % p.eps = eps_vals(j);
    % p.wx = 1.1*p.wx;

    x_dom = linspace(-L,0,31);

    ode_fun = @(x,y,c) [profile_ode(x,y(1:4),c,p); ...
        -profile_ode(-x,y(5:8),c,p)];

    bc_fun = @(ya,yb,c)profile_bc(ya,yb,c,p);

    guess_fun = @(x) deval(sol,x);
    
    solinit = bvpinit(x_dom,guess_fun,p.wave_speed);

    sol = bvp5c(ode_fun,bc_fun,solinit,bvp_options);
    p.wave_speed = sol.parameters;

end


figure;
hold on;
plot(sol.x,sol.y([1,3],:),'-k','LineWidth',2);
plot(-sol.x,sol.y([5,7],:),'-k','LineWidth',2);
h = xlabel('x');
set(h,'FontSize',18);




figure;
hold on;
plot(sol.y(1,:),sol.y(3,:),'-k','LineWidth',2);
plot(sol.y(5,:),sol.y(7,:),'-k','LineWidth',2);
h = xlabel('u');
set(h,'FontSize',18);
h = ylabel('v');
set(h,'FontSize',18);









return


%--------------------------------------------------------------------------
% Evans function computation
%--------------------------------------------------------------------------

xi = 1;

s.xi = xi;

% This choice solves the right hand side via exterior product
[s,e,m,c] = emcset(s,'front',LdimRdim(@A,s,p),'default');

% display a waitbar
c.stats = 'print'; % 'on', 'print', or 'off' (parallel matlab does not work with 'on' option)
c.ksteps = 2^8;

m.ode_fun = @ode15s;

%
% preimage contour
%

% This is a semi circle. You can also do a semi annulus or a rectangle (look in bin_main)
% circpnts=30; imagpnts=30; R=10; spread=2; zerodist=10^(-2);
% preimage=semicirc(circpnts,imagpnts,c.ksteps,R,spread,zerodist);

circpnts=20; imagpnts=20; innerpnts = 50; r=10; spread=4; zerodist=10^(-3);
preimage=semicirc2(circpnts,imagpnts,innerpnts,c.ksteps,r,spread,zerodist,c.lambda_steps);


%
% compute Evans function
%

tstart = tic;
halfw=contour(c,s,p,m,e,preimage);
tstop = toc(tstart);
fprintf('\nRun time = %4.4g seconds.\n',tstop);
w = halfw/halfw(1);
w = [w fliplr(conj(w))]; % We compute the Evans function on half of contour then reflect

% 
% process and display data
%

wnd=winding_number(w); % determine the number of roots inside the contour
fprintf('Winding Number: %1.1d\n',wnd);

% plot the Evans function (normalized)
plot_evans(w)





