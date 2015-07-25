function [y] = filter_running_average(x, N)
y = filter(ones(1,N)/N,1,x);
end