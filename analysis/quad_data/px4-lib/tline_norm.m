function [norm] = tline_norm(vec)

n = size(vec,2);
norm = zeros(n,1);

for l =1:n    
    norm(l) = sqrt(vec(:,l)'*vec(:,l));
end

end