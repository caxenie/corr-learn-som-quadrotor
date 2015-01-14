clear all;
close all;

libPath = '../px4-lib';
logPath = '../px4-logs';

dirName = 'tf3'; % {tf1, tf2}
 
addpath(libPath);
addpath(logPath);

ldata = read_log_data(logPath,dirName);
ld = add_precalcs(ldata);


%% PRELIMINARY COORDINATE TRANSOFRMATIONS AND SENSORY ANALYSIS 
% for IJCNN PAPER 

%TRACKER (GT)
t1       = ld.rb.hrt.t;
roll1    = -ld.rb.roll;
pitch1   = ld.rb.pitch;
yaw1     = -ld.rb.yaw;
T1       = ld.imu.hrt.t;

% interpolate data to imu hrt timeline
troll1    = interp1(t1,  roll1,     ld.imu.hrt.t);
tpitch1   = interp1(t1,  pitch1,    ld.imu.hrt.t);
troll1(isnan(troll1)) = 0.0;
tpitch1(isnan(tpitch1)) = 0.0;

% % ACCELEROMETER
figure; 
mfa = 50;
subplot(3,2,1); plot(ld.acc.rot.roll_lrn, -(mfa*sort(ld.acc.a_rot_f(2,:)./(- ld.g))),'.g'); 
subplot(3,2,3); plot(T1, (troll1)); hold on; plot(T1, (ld.acc.rot.roll)); 
subplot(3,2,5); plot(sort(troll1),sort(ld.acc.rot.roll)); 
subplot(3,2,2); plot(ld.acc.rot.pitch_lrn, (mfa*sort(ld.acc.a_rot_f(1,:)./(- ld.g))),'.b');
subplot(3,2,4); plot(T1, (tpitch1)); hold on; plot(T1, (ld.acc.rot.pitch)); 
subplot(3,2,6); plot(sort(tpitch1),sort(ld.acc.rot.pitch)); 

%  MAGNETOMETER

%TRACKER WITH REFS FOR MAGNETO (GT)
t2       = ld.rb.hrt.t;
roll2    = ld.rb.roll;
pitch2   = -ld.rb.pitch;
yaw2     = -ld.rb.yaw;
T2       = ld.imu.hrt.t;

% interpolate data to imu hrt timeline
troll2    = interp1(t2,  roll2,     ld.imu.hrt.t);
tpitch2   = interp1(t2,  pitch2,    ld.imu.hrt.t);
tyaw2     = interp1(t2,  yaw2,      ld.imu.hrt.t);

troll2(isnan(troll2)) = 0.0;
tpitch2(isnan(tpitch2)) = 0.0;
tyaw2(isnan(tyaw2)) = 0.0;

figure; 
mfm = 0.01;
subplot(3,1,1); plot(ld.mag.yaw_lrn, (mfm*sort(ld.mag.b_hat(2,:)./ld.mag.b_hat(1,:))),'.m'); 
subplot(3,1,2); plot(T2, (tyaw2)); hold on; plot(T2, (ld.mag.yaw_off - ld.mag.yaw)); 
subplot(3,1,3); plot(sort(tyaw2),sort(ld.mag.yaw_off - ld.mag.yaw)); 

% collect data to dump in a different structure 
% tracker (ground truth)
ddump.gt.roll1 = (troll1); ddump.gt.roll1 = normalize_var(sort(ddump.gt.roll1));
ddump.gt.pitch1 = (tpitch1); ddump.gt.pitch1 = normalize_var(sort(ddump.gt.pitch1));
ddump.gt.t1   = T1;

ddump.gt.roll2 = (troll2);  ddump.gt.roll2 = normalize_var(sort(ddump.gt.roll2));
ddump.gt.pitch2 = (tpitch2); ddump.gt.pitch2 = normalize_var(sort(ddump.gt.pitch2));
ddump.gt.yaw2 = (tyaw2); ddump.gt.yaw2 = normalize_var(sort(ddump.gt.yaw2));
ddump.gt.t2   = T2;
% accelerometer 
ddump.acc.roll.disp = (sort(ld.acc.rot.roll)); ddump.acc.roll.disp(isnan(ddump.acc.roll.disp)) = 0;
ddump.acc.roll.disp = normalize_var(ddump.acc.roll.disp);
ddump.acc.roll.lrn = sort(ld.acc.rot.roll_lrn); ddump.acc.roll.lrn(isnan(ddump.acc.roll.lrn)) = 0;
ddump.acc.roll.lrn = normalize_var(ddump.acc.roll.lrn);
ddump.acc.roll.inf = -(mfa*sort(ld.acc.a_rot_f(2,:)./(- ld.g))); ddump.acc.roll.inf(isnan(ddump.acc.roll.inf)) = 0;
ddump.acc.roll.inf= normalize_var(ddump.acc.roll.inf);
ddump.acc.pitch.disp = sort(ld.acc.rot.pitch); ddump.acc.pitch.disp(isnan(ddump.acc.pitch.disp)) = 0;
ddump.acc.pitch.disp = normalize_var(ddump.acc.pitch.disp);
ddump.acc.pitch.lrn = sort(ld.acc.rot.pitch_lrn); ddump.acc.pitch.lrn(isnan(ddump.acc.pitch.lrn)) = 0;
ddump.acc.pitch.lrn= normalize_var(ddump.acc.pitch.lrn);
ddump.acc.pitch.inf = (mfa*sort(ld.acc.a_rot_f(1,:)./(- ld.g)));  ddump.acc.pitch.inf(isnan(ddump.acc.pitch.inf)) = 0;
ddump.acc.pitch.inf = normalize_var(ddump.acc.pitch.inf);
% magneto
ddump.mag.yaw.disp = sort(ld.mag.yaw_off - ld.mag.yaw); ddump.mag.yaw.disp(isnan(ddump.mag.yaw.disp))=0;
ddump.mag.yaw.disp = normalize_var(ddump.mag.yaw.disp);
ddump.mag.yaw.lrn  = sort(ld.mag.yaw_lrn); ddump.mag.yaw.lrn(isnan(ddump.mag.yaw.lrn)) = 0;
ddump.mag.yaw.lrn = normalize_var(ddump.mag.yaw.lrn);
ddump.mag.bfield = (mfm*sort(ld.mag.b_hat(2,:)./ld.mag.b_hat(1,:)));  ddump.mag.bfield(isnan(ddump.mag.bfield)) = 0;
ddump.mag.bfield = normalize_var(ddump.mag.bfield);

% dump in a binary file 
data_dump = fopen('quad_data_raw.dat','wb');

data_pts = length(ddump.acc.roll.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.roll.lrn)
   fwrite(data_dump, ddump.acc.roll.lrn(id), 'double'); 
end

data_pts = length(ddump.acc.roll.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.roll.lrn)
   fwrite(data_dump, ddump.acc.roll.inf(id), 'double'); 
end

% ----------------------------------------------------

data_pts = length(ddump.gt.t1);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t1)
   fwrite(data_dump, ddump.gt.roll1(id), 'double'); 
end

data_pts = length(ddump.gt.t1);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t1)
   fwrite(data_dump, ddump.acc.roll.disp(id), 'double'); 
end

%-----------------------------------------------------

data_pts = length(ddump.acc.pitch.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.pitch.lrn)
   fwrite(data_dump, ddump.acc.pitch.lrn(id), 'double'); 
end

data_pts = length(ddump.acc.pitch.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.acc.pitch.lrn)
   fwrite(data_dump, ddump.acc.pitch.inf(id), 'double'); 
end

%----------------------------------------------------

data_pts = length(ddump.gt.t1);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t1)
   fwrite(data_dump, ddump.gt.pitch1(id), 'double'); 
end

data_pts = length(ddump.gt.t1);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t1)
   fwrite(data_dump, ddump.acc.pitch.disp(id), 'double'); 
end
%----------------------------------------------------

data_pts = length(ddump.mag.yaw.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.mag.yaw.lrn)
   fwrite(data_dump, ddump.mag.yaw.lrn(id), 'double'); 
end

data_pts = length(ddump.mag.yaw.lrn);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.mag.yaw.lrn)
   fwrite(data_dump, ddump.mag.bfield(id), 'double'); 
end

%-----------------------------------------------------

data_pts = length(ddump.gt.t2);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t2)
   fwrite(data_dump, ddump.gt.yaw2(id), 'double'); 
end

data_pts = length(ddump.gt.t2);
fwrite(data_dump, data_pts, 'int');
for id = 1:length(ddump.gt.t2)
   fwrite(data_dump, ddump.mag.yaw.disp(id), 'double'); 
end

fclose(data_dump);
%----------------------------------------------------

%%
% figure
% plot_servo_output_raw(ld.sor);

% figure
% plot_manual_control(ld.mc);

% 
% figure
% plot_sys_status(ld.ss);

% figure
% plot_highres_imu(ld.imu, ld.tsmin);


% figure
% plot_attitude(ld.att, ld.tsmin);

% figure
% plot_optical_flow(ld.of, ld.tsmin);

% figure
% plot_rigidBody(ld.rb, ld.tsmin);

% figure
% plot_rigidBody_lin_trans(ld);

% figure
% plot_of_weighted(ld);
% 
% figure
% plot_of_v_lin(ld);

% figure
% plot_acc_filtered(ld); 

% figure
% plot_acc_angle_vel(ld);

% figure
% plot_acc_LPF_and_FT(ld);
% 
% 
% figure
% plot_acc_a_lin(ld);
% 
% figure
% plot_acc_a_rot(ld);

% figure
% plot_mag_b(ld);

% 
% figure
% plot_rpy(ld);

% 
% figure
% plot_rpy_gyro(ld);
%   
% figure
% plot_rpy_acc(ld);
% 
% 
% figure
% plot_rpy_mag(ld);


% figure
% plot_KF_roll(ld);



% figure
% plot_time_analysis(ld);



% figure
% plot_roll_spectrogram(ld);



% figure
% plot(ld.imu.hrt.t,ld.imu.xgyro)
% grid on
% hold on
% plot(ld.imu.hrt.t,ld.gyro.vr_f,'r')
% 
% 
% 
% figure
% plot(ld.imu.hrt.t,ld.imu.xmag)
% grid on
% hold on
% plot(ld.imu.hrt.t,ld.mag.bx_f,'r')
% 
% 
% 
% figure
% plot(ld.imu.hrt.t,ld.imu.ymag)
% grid on
% hold on
% plot(ld.imu.hrt.t,ld.mag.by_f,'r')