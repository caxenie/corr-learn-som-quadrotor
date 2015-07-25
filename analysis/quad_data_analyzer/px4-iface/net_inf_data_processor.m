% prepare dataset for the network inference algorihtm
% setup env
close all;
clearvars;

% set up paths 
libPath = '../px4-lib';
dataPath = '../px4-display';
logPath = '../px4-logs';

% load paths 
addpath(libPath);
addpath(dataPath);
addpath(logPath);

% select no optic flow dataset 
init_PX4DataNew('tf1');

% select optic flow dataset 
% init_PX4DataNew('tf2');

% load the structured dataset
load('PX4DataNew.mat','-mat');

%---------------------------------------------------------------------------------------
% % COLLECT DATA TO DUMP 
% dataplot = {dumped data plot , individual plots} = {0, 1}
dataplot = 1; 
% generate plots in separate files {yes, no} = {1, 0};
printplot = 0;
% tracker (ground truth) 
ddump.gt.roll = (data.GT.roll);
ddump.gt.pitch = (data.GT.pitch);
ddump.gt.yaw = (data.GT.yaw);
ddump.gt.t   = data.t;

% ACCELEROMETER

% plot against data.ACC.roll to see the contribution of the linear
% acceleration and how knowing it makes a better estimate
% roll (rotation along the x axis in the OF)
disproll = atan2((data.acc_filt(2,:)-data.EKF.alin(2,:)), (data.acc_filt(3,:)-data.EKF.alin(3,:)));
ddump.acc.roll.disp = (disproll); 
ddump.acc.roll.lrn = (data.GYRO.roll); 
% get the linear acceleration component from EKF
% infroll = (data.acc(2,:)-data.EKF.alin(2,:))./(data.acc(3,:)-data.EKF.alin(3,:));
infroll = get_components(data.acc(2,:)-data.EKF.alin(2,:), (data.acc_filt(3,:)-data.EKF.alin(3,:)));
% get the linear acceleration component from GT
% infroll = (data.acc(2,:)-data.GT.alin(2,:))./(data.acc(3,:)-data.GT.alin(3,:));
% normalize the range of the values and then write to struct
infroll=normalize_range(infroll, min(ddump.acc.roll.lrn), max(ddump.acc.roll.lrn));
ddump.acc.roll.inf = (infroll);

%pitch (rotation along the y axis in the OF)
% plot against data.ACC.pitch to see the contribution of the linear
% acceleration and how knowing it makes a better estimate
disppitch = -atan2((data.acc_filt(1,:)-data.EKF.alin(1,:)), (data.acc_filt(3,:)-data.EKF.alin(3,:)));
ddump.acc.pitch.disp = (disppitch); 
ddump.acc.pitch.lrn = (data.GYRO.pitch); 
% get the linear acceleration component from EKF
%infpitch = -(data.acc(1,:)-data.EKF.alin(1,:))./(data.acc(3,:)-data.EKF.alin(3,:));
infpitch = -get_components(data.acc(1,:)-data.EKF.alin(1,:), (data.acc(3,:)-data.EKF.alin(3,:)));
% get the linear acceleration component from GT
% infpitch = (data.acc(1,:)-data.GT.alin(1,:))./(data.acc(3,:)-data.GT.alin(3,:));
% normalize the range of the values and then write to struct
infpitch=normalize_range(infpitch, min(ddump.acc.pitch.lrn), max(ddump.acc.pitch.lrn));
ddump.acc.pitch.inf = (infpitch);

% % MAGNETO
% yaw 
dispyaw = data.MAG.ekf.yaw;
ddump.mag.yaw.disp = (dispyaw);
lrnyaw = data.GYRO.yaw;
ddump.mag.yaw.lrn  = (lrnyaw); 
% use directly the rotated components of the mag ic field vector
%infyaw1 = -(data.MAG.bfield(2,:))./(data.MAG.bfield(1,:));
infyaw = -get_components(data.MAG.bfield(2,:),data.MAG.bfield(1,:));
% normalize the range of the values and then write to struct
infyaw=normalize_range(infyaw, min(ddump.mag.yaw.lrn), max(ddump.mag.yaw.lrn));
ddump.mag.yaw.inf    = infyaw;

% ----------------------------------------------------
% % DUMP FILE ON DISK

%normalize data before dumping to disk 
subsampling_factor = 10; % simulation time reduction
ddump.gt.t = 1:length(ddump.gt.t)/subsampling_factor;
% normalization in [-1,1] interval
ddump.gt.roll = normalize_var(ddump.gt.roll(1:subsampling_factor:end));
ddump.gt.pitch = normalize_var(ddump.gt.pitch(1:subsampling_factor:end));
ddump.gt.yaw = normalize_var(ddump.gt.yaw(1:subsampling_factor:end));
ddump.acc.roll.disp = normalize_var(ddump.acc.roll.disp(1:subsampling_factor:end));
ddump.acc.roll.lrn =normalize_var(ddump.acc.roll.lrn(1:subsampling_factor:end));
ddump.acc.roll.inf = normalize_var(ddump.acc.roll.inf(1:subsampling_factor:end));
ddump.acc.pitch.disp = normalize_var(ddump.acc.pitch.disp(1:subsampling_factor:end));
ddump.acc.pitch.lrn =normalize_var(ddump.acc.pitch.lrn(1:subsampling_factor:end));
ddump.acc.pitch.inf = normalize_var(ddump.acc.pitch.inf(1:subsampling_factor:end));
ddump.mag.yaw.disp = normalize_var(ddump.mag.yaw.disp(1:subsampling_factor:end));
ddump.mag.yaw.lrn  = normalize_var(ddump.mag.yaw.lrn(1:subsampling_factor:end));
ddump.mag.yaw.inf   = normalize_var(ddump.mag.yaw.inf(1:subsampling_factor:end));

% dump vars to file for network inference algorithm
x = [ddump.acc.roll.lrn; ddump.acc.roll.inf; ddump.acc.pitch.lrn; ddump.acc.pitch.inf; ddump.mag.yaw.lrn; ddump.mag.yaw.inf]';
variables = {'G_r','A_r','G_p', 'A_p', 'G_y', 'M_y'};
save('test_corr_learn_net','x','variables');