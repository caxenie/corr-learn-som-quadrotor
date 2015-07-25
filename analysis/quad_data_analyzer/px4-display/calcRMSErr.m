function [errRMS] = calcRMSErr(x1,x2)

n = length(x1);
err = x1-x2;

errRMS = sqrt(sum(err.^2)/n);

end