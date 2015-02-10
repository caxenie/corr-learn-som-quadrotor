clear all;
close all;

libPath = '../px4-lib';
dataPath = '../px4-display';

addpath(libPath);
addpath(dataPath);

load('PX4DataNew.mat','-mat');
%----------------------------------------------------
% PLOT DATA ASSOCIATED WITH EACH SENSOR 
% ACCELEROMETER
% main_AccVsGTRoll
% main_AccVsGTPitch
% 
% main_EKFLinAccVsGTAccX
% main_EKFLinAccVsGTAccY
% main_EKFLinAccVsGTAccZ
% 
% main_GTLinAccVsGTAccX
% main_GTLinAccVsGTAccY
% main_GTLinAccVsGTAccZ

% main_AccRawX
% main_AccRawY
% main_AccRawZ
% main_GTArotObjCosyX
% main_GTArotObjCosyY
% main_GTArotObjCosyZ
% 
% % MAGNETO
% main_MagEKFVsGTYaw
% main_MagGTVsGTYaw
% 
% main_MagBackCalcEKFMagX
% main_MagBackCalcEKFMagY
% main_MagBackCalcEKFMagZ
% 
% main_MagBackCalcGTMagX
% main_MagBackCalcGTMagY
% main_MagBackCalcGTMagZ
% 
% main_MagBackCalcAllMagX
% main_MagBackCalcAllMagY
% main_MagBackCalcAllMagZ
% 
% % GYRO
% main_GyroVsGTRoll
% main_GyroVsGTPitch
% main_GyroVsGTYaw
% 
% % OPTIC FLOW
% if isfield(data,'OF')==1
%     main_OFVsGTHeight
%     main_OFVsGTVelX
%     main_OFVsGTVelY
% end
% 
% % ALL
% main_AllVsGTYaw

%---------------------------------------------------------------------------------------
% % COLLECT DATA TO DUMP 
% tracker (ground truth) 
ddump.gt.roll = (data.GT.roll);
ddump.gt.pitch = (data.GT.pitch);
ddump.gt.yaw = (data.GT.pitch);
ddump.gt.t   = data.t;
 
% ACCELEROMETER

% plot against data.ACC.roll to see the contribution of the linear
% acceleration and how knowing it makes a better estimate
% roll (rotation along the x axis in the OF)
disproll = atan2((data.acc_filt(2,:)-data.EKF.alin(2,:)), (data.acc_filt(3,:)-data.EKF.alin(3,:)));
ddump.acc.roll.disp = (disproll); 
ddump.acc.roll.lrn = (data.GYRO.roll); 
% get the linear acceleration component from EKF
infroll = (data.acc(2,:)-data.EKF.alin(2,:))./(data.acc(3,:)-data.EKF.alin(3,:));
% get the linear acceleration component from GT
% infroll = (data.acc(2,:)-data.GT.alin(2,:))./(data.acc(3,:)-data.GT.alin(3,:));
ddump.acc.roll.inf = (infroll);

%pitch (rotation along the y axis in the OF)
% plot against data.ACC.pitch to see the contribution of the linear
% acceleration and how knowing it makes a better estimate
disppitch = -atan2((data.acc_filt(1,:)-data.EKF.alin(1,:)), (data.acc_filt(3,:)-data.EKF.alin(3,:)));
ddump.acc.pitch.disp = (disppitch); 
ddump.acc.pitch.lrn = (data.GYRO.pitch); 
% get the linear acceleration component from EKF
infpitch = (data.acc(1,:)-data.EKF.alin(1,:))./(data.acc(3,:)-data.EKF.alin(3,:));
% get the linear acceleration component from GT
% infpitch = (data.acc(1,:)-data.GT.alin(1,:))./(data.acc(3,:)-data.GT.alin(3,:));
ddump.acc.pitch.inf = (infpitch);

% % MAGNETO
% yaw 
dispyaw = data.MAG.ekf.yaw;
ddump.mag.yaw.disp = (dispyaw);
lrnyaw = data.GYRO.yaw;
ddump.mag.yaw.lrn  = (lrnyaw); 
infyaw = -(data.MAG.bfield(2,:))./(data.MAG.bfield(1,:));
ddump.mag.yaw.inf   = (infyaw); 

%----------------------------------------------------
% PLOT DATA TO DUMP TO FILE
% ACCELEROMETER
figure; 
set(gcf, 'color', 'white');

subplot(3,3,1);
plot(sort(ddump.acc.roll.inf), sort(ddump.acc.roll.lrn),'g', 'LineWidth', 3); grid on; box off; 
title('Learned roll correlation: Acc (raw net acc) VS. Gyro');

subplot(3,3,4); plot(ddump.gt.t, ddump.gt.roll); hold on; 
plot(ddump.gt.t, ddump.acc.roll.disp); hold on;
plot(ddump.gt.t, ddump.acc.roll.lrn);grid on; box off;
title('Roll angle: Ground truth, Acc, Gyro');


subplot(3,3,7); 
plot(sort(ddump.gt.roll),sort(ddump.acc.roll.disp)); hold on;
plot(sort(ddump.acc.roll.lrn),sort(ddump.acc.roll.disp)); grid on; box off;
title('Roll angle:Acc VS. Ground truth, Acc VS. Gyro');

subplot(3,3,2); 
plot(sort(ddump.acc.pitch.inf), sort(ddump.acc.pitch.lrn),'b', 'LineWidth', 3);grid on; box off;
title('Learned pitch correlation: Acc (raw net acc) VS. Gyro');

subplot(3,3,5); 
plot(ddump.gt.t, ddump.gt.pitch); hold on; 
plot(ddump.gt.t, ddump.acc.pitch.disp); hold on;
plot(ddump.gt.t, ddump.acc.pitch.lrn); grid on; box off;
title('Pitch angle: Ground truth, Acc, Gyro');

subplot(3,3,8); 
plot(sort(ddump.gt.pitch),sort(ddump.acc.pitch.disp)); hold on;
plot(sort(ddump.acc.pitch.lrn),sort(ddump.acc.pitch.disp)); grid on; box off;
title('Pitch angle:Acc VS. Ground truth,  Acc VS. Gyro');

% MAGNETOMETER
subplot(3,3,3); 
plot(sort(ddump.mag.yaw.inf), sort(ddump.mag.yaw.lrn),'m', 'LineWidth', 3); grid on; box off;
title('Learned yaw correlation: Mag (raw mag field) VS. Gyro');

subplot(3,3,6); 
plot(ddump.gt.t, ddump.gt.yaw); hold on; 
plot(ddump.gt.t, ddump.mag.yaw.disp); hold on;
plot(ddump.gt.t, ddump.mag.yaw.lrn); grid on; box off;
title('Yaw angle: Ground truth, Mag, Gyro');

subplot(3,3,9); plot(sort(ddump.gt.yaw),sort(ddump.mag.yaw.disp)); hold on;
plot(sort(ddump.mag.yaw.lrn),sort(ddump.mag.yaw.disp)); grid on; box off;
title('Yaw angle: Mag VS. Ground truth, Mag VS. Gyro');

% ----------------------------------------------------
% % DUMP FILE ON DISK

%normalize data before dumping to disk 
ddump.gt.roll = normalize_var(ddump.gt.roll);
ddump.gt.pitch = normalize_var(ddump.gt.pitch);
ddump.gt.yaw = normalize_var(ddump.gt.yaw);
ddump.acc.roll.disp = normalize_var(ddump.acc.roll.disp);
ddump.acc.roll.lrn =normalize_var(ddump.acc.roll.lrn);
ddump.acc.roll.inf = normalize_var(ddump.acc.roll.inf);
ddump.acc.pitch.disp = normalize_var(ddump.acc.pitch.disp);
ddump.acc.pitch.lrn =normalize_var(ddump.acc.pitch.lrn);
ddump.acc.pitch.inf = normalize_var(ddump.acc.pitch.inf);
ddump.mag.yaw.disp = normalize_var(ddump.mag.yaw.disp);
ddump.mag.yaw.lrn  = normalize_var(ddump.mag.yaw.lrn);
ddump.mag.yaw.inf   = normalize_var(ddump.mag.yaw.inf);

data_dump = fopen('quad_data_raw_roll_tf.dat','wb');

data_pts = length(ddump.acc.roll.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.roll.lrn)
   fwrite(data_dump, ddump.acc.roll.inf(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.roll.lrn)
   fwrite(data_dump, ddump.acc.roll.lrn(id), 'double'); 
end

fclose(data_dump);
% ----------------------------------------------------

data_dump = fopen('quad_data_raw_roll_eval.dat','wb');
data_pts = length(ddump.gt.t);
% ddump.gt.roll=sort(ddump.gt.roll);
% ddump.acc.roll.disp = sort(ddump.acc.roll.disp);

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.gt.roll(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.acc.roll.disp(id), 'double'); 
end
fclose(data_dump);

%-----------------------------------------------------

data_dump = fopen('quad_data_raw_pitch_tf.dat','wb');
data_pts = length(ddump.acc.pitch.lrn);

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.acc.pitch.inf(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.acc.pitch.lrn(id), 'double'); 
end
fclose(data_dump);

%----------------------------------------------------

data_dump = fopen('quad_data_raw_pitch_eval.dat','wb');
data_pts = length(ddump.gt.t);
% ddump.gt.pitch = sort(ddump.gt.pitch);
% ddump.acc.pitch.disp = sort(ddump.acc.pitch.disp);

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.gt.pitch(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.acc.pitch.disp(id), 'double'); 
end
fclose(data_dump);

% %----------------------------------------------------

data_dump = fopen('quad_data_raw_yaw_tf.dat','wb');
data_pts = length(ddump.mag.yaw.lrn);

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.mag.yaw.inf(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.mag.yaw.lrn(id), 'double'); 
end
fclose(data_dump);

% % %-----------------------------------------------------

data_dump = fopen('quad_data_raw_yaw_eval.dat','wb');
data_pts = length(ddump.gt.t);
% ddump.gt.yaw = sort(ddump.gt.yaw);
% ddump.mag.yaw.disp = sort(ddump.mag.yaw.disp);

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.gt.yaw(id), 'double'); 
end

fwrite(data_dump, data_pts, 'int');
for id = 1:data_pts
   fwrite(data_dump, ddump.mag.yaw.disp(id), 'double'); 
end
fclose(data_dump);

