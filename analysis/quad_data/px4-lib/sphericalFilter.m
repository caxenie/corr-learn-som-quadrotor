% quick and dirty way to ignore acc vectors > g
function [valid] = sphericalFilter(x,y,z,r,delta)

r_hat = x.*x + y.*y + z.*z;

d1 = r - delta;
d2 = r + delta;

sqdelta1 = d1*d1;
sqdelta2 = d2*d2;


valid = ones(size(x));

for k=1:length(x)
    
    if(r_hat(k) < sqdelta1 || r_hat(k) > sqdelta2)
        valid(k) = 0;  % ignore
    end
end

valid = logical(valid);

end