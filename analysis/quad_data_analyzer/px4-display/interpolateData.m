function [yDest] = interpolateData(y, xSrc, xDest)

yDest         = interp1(xSrc, y, xDest);
yDest(~isfinite(yDest))     = 0; 

end