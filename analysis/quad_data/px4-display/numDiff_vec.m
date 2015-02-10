function [dvec] = numDiff_vec(vec, dt)

n = size(vec,2);

s = size(dt);

if(s(1) == 1 && s(2) == 1)
    dt = ones(1,n)*dt;
end


dvec = zeros(3,n);

for k=2:n
    dvec(:,k) = (vec(:,k) - vec(:,k-1)) ./ dt(k);
end



end