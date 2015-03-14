% precise atan2 computation http://en.wikipedia.org/wiki/Atan2
% prepare args as for an atan2 call
function y = get_components(c1, c2)
    y=((sqrt(c1.^2+c2.^2)-c2)./c1)/2;
end