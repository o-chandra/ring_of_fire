function [ru,dru] = react(u)

if u > 0
    ru = exp(-1/u);
    dru = ru/u^2;
else
    ru = 0;
    dru = 0;
end



