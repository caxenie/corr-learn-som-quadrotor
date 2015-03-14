% FUNCTION:
%   inverse RPY euler rotation (from initial cosy to current object cosy)
%   col vecs of matrix are cosy axes of initial cosy on coords. of current
%   object cosy
%
%   [R] = RPYRot(angs)
%   [R] = RPYRot(angs,mode)
%   [R] = RPYRot(phi,theta,psi)
%   [R] = RPYRot(phi,theta,psi,mode)
%
% ARGS:
%   args = [phi,theta,psi]
%   mode is 'rad' or 'deg' string; rad mode is default
%
% RETURN:
%   inverse rotation matrix
%
function [R] = RPYRot(varargin)

% default: angles in rads
angInDeg        = 0;

if nargin == 1
    angs  = varargin{1};
    
    phi     = angs(1);
    theta   = angs(2);
    psi     = angs(3); 
end

if nargin == 2
    angs    = varargin{1};
    mode    = varargin{2};
    
    if strcmp(mode,'deg')
        angInDeg = 1;
    end
    
    phi     = angs(1);
    theta   = angs(2);
    psi     = angs(3); 
end

if nargin == 3
    phi     = varargin{1};
    theta   = varargin{2};
    psi     = varargin{3}; 
end

if nargin == 4
    phi     = varargin{1};
    theta   = varargin{2};
    psi     = varargin{3};
    
    mode    = varargin{4};
    
    if strcmp(mode,'deg')
        angInDeg = 1;
    end
end

% convert to deg if not already in deg
if ~angInDeg
    phi     = phi   / pi*180;
    theta   = theta / pi*180;
    psi     = psi   / pi*180;
end

R = rotz(psi)*roty(theta)*rotx(phi);

end