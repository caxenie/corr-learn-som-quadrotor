function [ld_out] = add_KF_roll_pitch(ld)


if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

%**************************************************************************
%%      KALMAN filter: gyro, acc;    ROLL, PITCH
%**************************************************************************

n = ld.imu.n;

% roll
ld.KF.roll.x = zeros(2,n);
ld.KF.roll.y = zeros(1,n);
ld.KF.roll.K = zeros(2,n);

s.flag = 0;
for k=1:n
       
    s =  kalman_filter_gyro(s,ld.imu.xgyro(k),ld.acc.raw.roll(k),ld.imu.hrt.dt(k));
    
    ld.KF.roll.x(1,k) = s.x(1); 
    ld.KF.roll.x(2,k) = s.x(2);
    ld.KF.roll.y(k) = s.y;
    ld.KF.roll.K(1,k) = s.K1;
    ld.KF.roll.K(2,k) = s.K2;
end


% pitch
ld.KF.pitch.x = zeros(2,n);
ld.KF.pitch.K = zeros(2,n);

s.flag = 0;
for k=1:n
       
    s =  kalman_filter_gyro(s,ld.imu.ygyro(k),ld.acc.raw.pitch(k),ld.imu.hrt.dt(k));
    
    ld.KF.pitch.x(1,k) = s.x(1); 
    ld.KF.pitch.x(2,k) = s.x(2);
    ld.KF.pitch.K(1,k) = s.K1;
    ld.KF.pitch.K(2,k) = s.K2;
    
end

ld_out = ld;

end




function [nState] = kalman_filter_gyro(state, gAngle, aAngle, dt)

% init
if(state.flag == 0)
    state.P = [0 0; 0 0];
    state.Q = [2 0; 0 0.0003];
    
    % a lower value gives the error more weight
    state.R = 1000; % 300 => 4 per mill weight
    state.x = [0 0];
    state.flag = 1;
end

P = state.P;
Q = state.Q;
R = state.R;
x = state.x;


% predict system state
    x(1) = x(1) - x(2)*dt + gAngle*dt;
    x(2) = x(2);
    
    
% update P matrix 
    P(1,1) = P(1,1) - (P(2,1) + P(1,2))*dt + P(2,2)*dt^2 + Q(1,1)*dt;
    P(1,2) = P(1,1) - P(2,2) * dt;
    P(2,1) = P(2,1) - P(2,2) * dt;
    P(2,2) = P(2,2) + Q(2,2) * dt;
   
    
% update step
    
    y = aAngle - x(1);  % error: model state - measurement

    S = P(1,1) + R;     % covariance: model state - measurement
    
    K1 = P(1,1) / S;    % optimal Kalman gain    
    K2 = P(2,2) / S;

    x(1) = x(1) + K1*y;     % update system state
    x(2) = x(2) + K2*y;     
    
    
% update covariance matrix P
    
    P(1,1) = P(1,1) - K1 * P(1,1);
    P(1,2) = P(1,2) - K1 * P(1,2);
    P(2,1) = P(2,1) - K2 * P(1,1);
    P(2,2) = P(2,2) - K2 * P(1,2);
  

    state.P = P;
    state.x = x;
    state.y = y;
    state.K1 = K1;
    state.K2 = K2;

    nState = state;
end








