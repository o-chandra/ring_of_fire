function out = profile_ode(~,y,speed,p)
    
    out = [y(2); (p.a-speed)*y(2)-p.vstar*react(y(1))+p.l*y(1)];