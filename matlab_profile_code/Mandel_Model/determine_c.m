function [p,sol] = determine_c(p,S0,c_left,c_right,tspan,options,plot_it)


[term_left,sol] = get_wave_index(p,S0,c_left,tspan,options,plot_it);


% figure
% hold on;
% plot(sol.y(1,:),sol.y(2,:),'-k','LineWidth',2);
fail



[term_right,sol] = get_wave_index(p,S0,c_right,tspan,options,plot_it);

if term_right*term_left >= 0
    [term_left,sol] = get_wave_index(p,S0,c_left,tspan,options,'on');
    [term_right,sol] = get_wave_index(p,S0,c_right,tspan,options,'on');
   error('Not opposite signs'); 
end

count = 0;
while (norm(sol.y(1:2,end))>1e-6) && (count < 30)
    
    count = count+1;
    
    c_mid = 0.5*(c_left+c_right);
    
    [term_mid,sol] = get_wave_index(p,S0,c_mid,tspan,options,plot_it);

    if term_mid*term_right > 0
       c_right = c_mid;
    else
       c_left = c_mid;
    end
    
    if strcmp(plot_it,'on')
        if count > 3
           fail 
        end
    end
    
        
end

p.c = c_mid;