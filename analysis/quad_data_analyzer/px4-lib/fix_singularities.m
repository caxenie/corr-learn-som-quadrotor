% fix singularities in the atan computation 
function y = fix_singularities(in)
while(any(isnan(in)))
    in(isnan(in)) = in(find(isnan(in))-1);
end
y = in;
end