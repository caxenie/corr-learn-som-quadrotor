

function [] = main_mag_analysis()


clear all
close all


phi = 0;
theta = 5;
psi = 30;



B = [0.25;0;0.39];

% test rotation
Bm = rot_euler(phi,theta,psi)*B;

% find out yaw angle

% undo roll and pitch rotations
B_hat = roty(-theta)*rotx(-phi)*Bm;

% get yaw rotation
yaw = toDeg(atan2(B_hat(2),B_hat(1)));



fprintf('[phi, theta, psi] = [%2.2f, %2.2f, %2.2f]\n',phi,theta,psi);
fprintf('yaw = %2.2f\n',yaw);

% n=1000;
% 
% pPhi = 20 * randn(n);
% pTheta = 20 * randn(n);
% pPsi = psi + 0.2* randn(n);
% 
% 
% pB_hat = zeros(3,n);
% err = zeros(1,n);
% 
% for k=1:n
%     
%     pB_hat(:,k) = rot_euler(pPhi(k),pTheta(k),pPsi(k)) * B;
%     err(k) = norm(Bm - pB_hat(k));
%     
%     if(err(k) < 0.18)
%         fprintf('error = %2.2f\n',err(k));
%         fprintf('est. [phi, theta, psi] = [%2.2f, %2.2f, %2.2f]\n',pPhi(k),pTheta(k),pPsi(k));
%     end
% end



end



function [R] = rot_euler(phi,theta,psi)

R = rotx(phi)*roty(theta)*rotz(psi);

end

function [deg] = toDeg(rad)

deg = rad/pi*180;

end


function [rad] = toRad(deg)

rad = rad/180*pi;

end