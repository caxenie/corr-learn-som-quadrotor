function [t_new, x_new] = simple_resampling(t, x, t_start, Ts)

%**************************************************************************
%% simple resampling to constant sample rate (NO interpolation)
%**************************************************************************

%%ATTENTION: only oversampling is allowed
dt = t - [0; t(1:(end-1))];
dt = mean(dt);

if(dt < Ts)
    error('NOTE: down-sampling is not allowed! (Ts = %d > %d)',Ts,dt);
end

% [t_new, x_new] = without_interpolation(t, x, t_start, Ts);


% with linear interpolation
t_new = t_start:Ts:t(end);
x_new = interp1(t,x,t_new);


end


function [t_new, x_new] = without_interpolation(t, x, t_start, Ts)

ind = find(t >= t_start);
iStart = ind(1);

n = length(t);
m = ceil(t(end)-t_start);

t_new = zeros(m,1);
x_new = zeros(m,1);

index = iStart;

if(iStart ~= 1)
    t_c = t_start - Ts;
    sValue = x(index-1);
else
    t_c = t_start;     
    sValue = 0;
end

k=1;
while(t_c < t(end))
    if( t_c >= t(index))
        sValue = x(index);
        index = index + 1;
    end
    
    t_new(k) = t_c;
    x_new(k) = sValue;
    t_c = t_c + Ts;
    k = k + 1;
end

end


