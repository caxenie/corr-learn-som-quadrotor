function [data] = init_PX4DataNew()

warning('off','all');

libPath = '../px4-lib';
logPath = '../px4-logs';

dirName = 'tf1';   % without optic flow data 
% dirName = 'tf2'; % with optic flow data

addpath(libPath);
addpath(logPath);

fprintf('Load PX4 log raw data ...\n')
ld = read_log_data(logPath,dirName);
fprintf('Finished.\n')

fprintf('Preprocess PX4 log data ...\n')
ld              = add_time_and_offset_precalcs(ld);

% ld              = add_rigid_body_precalcs(ld);
% ld              = add_acc_precalcs(ld);
% ld              = add_gyro_precalcs(ld);
% ld              = add_mag_precalcs(ld);
fprintf('Finished.\n')


t               = ld.imu.hrt.t;
dt              = ld.imu.hrt.dt;
n               = ld.imu.n;

if strcmp(dirName,'tf1')==1
    int             = 6000:(n-4000);
    disp 'No Optic Flow dataset';
else
    int             = 1:n;              %tf7
    disp 'Optic Flow dataset';
end

intOff          = 1:100;    % interval for offset


g               = ld.g;
b0               = ld.b;

vel             = [ld.imu.xgyro';ld.imu.ygyro';ld.imu.zgyro'];
acc             = -[ld.imu.xacc';ld.imu.yacc';ld.imu.zacc'];

accOff(1,1)     = mean(acc(1,intOff));
accOff(2,1)     = mean(acc(2,intOff));
accOff(3,1)     = 0;

N = 2;
Fc = 3;
acc_filt        = filtfilt_BWLP_vec(acc-accOff*ones(1,size(acc,2)),N,Fc,ld.imu.hrt.freq_mean);

ACC.roll        = atan2(acc_filt(2,:),acc_filt(3,:));
ACC.pitch       = -atan2(acc_filt(1,:),acc_filt(3,:));

gyroOff(1,1)    = mean(vel(1,intOff));
gyroOff(2,1)    = mean(vel(2,intOff));
gyroOff(3,1)    = mean(vel(3,intOff));

GYRO.roll       = zeros(1,n);
GYRO.pitch      = zeros(1,n);
GYRO.yaw        = zeros(1,n);

% numerically integrate angular velocities
for k=2:n
    GYRO.roll(k)     = GYRO.roll(k-1)   + (ld.imu.xgyro(k-1)-gyroOff(1)) * ld.imu.hrt.dt(k);
    GYRO.pitch(k)    = GYRO.pitch(k-1)  + (ld.imu.ygyro(k-1)-gyroOff(2)) * ld.imu.hrt.dt(k);
    GYRO.yaw(k)      = GYRO.yaw(k-1)    + (ld.imu.zgyro(k-1)-gyroOff(3)) * ld.imu.hrt.dt(k);
end




EKF.rollOff     = mean(ld.att.roll(intOff));
EKF.roll(1,:)   = interpolateData(ld.att.roll-EKF.rollOff, ld.att.hrt.t, t);

EKF.pitchOff    = mean(ld.att.pitch(intOff));
EKF.pitch(1,:)  = interpolateData(ld.att.pitch-EKF.pitchOff, ld.att.hrt.t, t); 

EKF.yawOff      = mean(ld.att.yaw(intOff));
EKF.yaw(1,:)    = interpolateData(ld.att.yaw-EKF.yawOff, ld.att.hrt.t, t); 

EKF.alin        = zeros(3,n);
GT.alin         = zeros(3,n);
GT.arot         = zeros(3,n);

GT              = pprc_GTData(ld,t,intOff);
if strcmp(dirName,'tf2')==1
    OF              = pprc_OFData(ld,t,intOff);
end

for k=1:n
 R              = RPYRot([EKF.roll(k), EKF.pitch(k), EKF.yaw(k)]);

 % in object cosy
 EKF.alin(:,k)  = acc_filt(:,k) - R'*[0 0 1]'*g; 
     
 % in world cosy                               
 EKF.alin(:,k) = R * EKF.alin(:,k);
end


for k=1:n
 R              = RPYRot([GT.roll(k), GT.pitch(k), GT.yaw(k)]);
 
 GT.arot(:,k)   = R'*[0 0 1]'*g;
 
 % in object cosy
 GT.alin(:,k)  = acc_filt(:,k) - GT.arot(:,k); 
     
 % in world cosy                               
 GT.alin(:,k) = R * GT.alin(:,k);
end


mag = [ld.imu.xmag';ld.imu.ymag';ld.imu.zmag'];

N = 2;
Fc = 3;
mag_filt            = filtfilt_BWLP_vec(mag,N,Fc,ld.imu.hrt.freq_mean);

MAG.gt.yaw          = zeros(1,n);
MAG.ekf.yaw         = zeros(1,n);

EKF.mag             = zeros(3,n);
GT.mag              = zeros(3,n);

for k=1:n
    R               = RPYRot([GT.roll(k), GT.pitch(k), 0]);

    % transform back to world coords; no rotations around z-axis
    b_0             = R * mag_filt(:,k);

    % geometric transformation 
    MAG.gt.yaw(k)   = -atan2(b_0(2),b_0(1));
    
    
    R               = RPYRot([EKF.roll(k), EKF.pitch(k), 0]);

    % transform back to world coords; no rotations around z-axis
    b_0             = R * mag_filt(:,k);
    
    % magnetic field values
    MAG.bfield(:,k)   = b_0;
    
    MAG.ekf.yaw(k)   = -atan2(b_0(2),b_0(1));
      
end

MAG.gt.yawOff       = mean(MAG.gt.yaw(intOff));
MAG.gt.yaw          = MAG.gt.yaw-MAG.gt.yawOff;
MAG.ekf.yawOff      = mean(MAG.ekf.yaw(intOff));
MAG.ekf.yaw         = MAG.ekf.yaw-MAG.ekf.yawOff;

for k=1:n
    R               = RPYRot([EKF.roll(k), EKF.pitch(k), EKF.yaw(k)]);
    EKF.mag(:,k)    = R' * b0;
    
    R               = RPYRot([GT.roll(k), GT.pitch(k), GT.yaw(k)]);
    GT.mag(:,k)     = R' * b0;
    
end


data.t          = t;
data.dt         = dt;
data.n          = n;
data.g          = g;
data.b0         = b0;
data.vel        = vel;
data.acc        = acc;
data.acc_filt   = acc_filt;
data.mag        = mag;
data.mag_filt   = mag_filt;
data.EKF        = EKF;
data.ACC        = ACC;
data.GYRO       = GYRO;
data.MAG        = MAG;
data.GT         = GT;
if strcmp(dirName,'tf2')==1
    data.OF         = OF;
end
data.int        = int;

save('PX4DataNew.mat','data');


rmpath(libPath);
rmpath(logPath);


end