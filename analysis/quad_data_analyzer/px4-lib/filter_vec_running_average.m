function [vec_f] = filter_vec_running_average(vec, N)

vec_f(1,:) = filter(ones(1,N)/N,1,vec(1,:));
vec_f(2,:) = filter(ones(1,N)/N,1,vec(2,:));
vec_f(3,:) = filter(ones(1,N)/N,1,vec(3,:));

end