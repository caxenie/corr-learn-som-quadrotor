clear all;
close all;

libPath = '../px4-lib';
dataPath = '../px4-display';

addpath(libPath);
addpath(dataPath);

load('PX4DataNew.mat','-mat');
%----------------------------------------------------
% PLOT DATA ASSOCIATED WITH EACH SENSOR 
%
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

% main_AccRawY
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng accrawroll.png

% main_AccRawX
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng accrawpitch.png

% main_AccRawZ
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng accrawyaw.png

% main_GTArotObjCosyX
% main_GTArotObjCosyY
% main_GTArotObjCosyZ
% 
% % MAG O
% main_MagEKFVsGTYaw
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng mag.png

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
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng gyrorawroll.png

% main_GyroVsGTPitch
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng gyrorawpitch.png
% 
% main_GyroVsGTYaw
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% print -dpng gyrorawyaw.png

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

% % MAG O
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

%----------------------------------------------------
% PLOT DATA TO DUMP TO FILE
% ACCELEROMETER
figure; 
set(gcf, 'color', 'white');

subplot(5,3,1);
plot(sort(ddump.acc.roll.inf), sort(ddump.acc.roll.lrn),'.g', 'LineWidth', 3); grid on; box off; 
title('Roll relation: Acc (raw   acc) VS. Gyro');

subplot(5,3,4);
hist(ddump.acc.roll.inf, 50); box off;
title('Acc (raw   acc) data distribution for roll');

subplot(5,3,7);
hist(ddump.acc.roll.lrn, 50); box off;
title('Gyro data distribution for roll');

subplot(5,3,10); plot(ddump.gt.t, ddump.gt.roll); hold on; 
plot(ddump.gt.t, ddump.acc.roll.disp); hold on;
plot(ddump.gt.t, ddump.acc.roll.lrn);grid on; box off;
title('Roll angle'); legend('Ground truth', 'Acc', 'Gyro');


subplot(5,3,13); 
plot(sort(ddump.gt.roll),sort(ddump.acc.roll.disp),'.r'); hold on;
plot(sort(ddump.acc.roll.lrn),sort(ddump.acc.roll.disp), '.b'); grid on; box off;
title('Roll angle'); legend('Acc VS. Ground truth', 'Acc VS. Gyro');

subplot(5,3,2); 
plot(sort(ddump.acc.pitch.inf), sort(ddump.acc.pitch.lrn),'.b', 'LineWidth', 3);grid on; box off;
title('Pitch relation: Acc (raw   acc) VS. Gyro');

subplot(5,3,5);
hist(ddump.acc.pitch.inf, 50); box off;
title('Acc (raw   acc) data distribution for pitch');

subplot(5,3,8);
hist(ddump.acc.pitch.lrn, 50); box off;
title('Gyro data distribution for pitch');

subplot(5,3,11); 
plot(ddump.gt.t, ddump.gt.pitch); hold on; 
plot(ddump.gt.t, ddump.acc.pitch.disp); hold on;
plot(ddump.gt.t, ddump.acc.pitch.lrn); grid on; box off;
title('Pitch angle'); legend('Ground truth', 'Acc', 'Gyro');

subplot(5,3,14); 
plot(sort(ddump.gt.pitch),sort(ddump.acc.pitch.disp),'.r'); hold on;
plot(sort(ddump.acc.pitch.lrn),sort(ddump.acc.pitch.disp),'.b'); grid on; box off;
title('Pitch angle'); legend('Acc VS. Ground truth', 'Acc VS. Gyro');

% MAG OMETER
subplot(5,3,3); 
plot(sort(ddump.mag.yaw.inf), sort(ddump.mag.yaw.lrn),'.m', 'LineWidth', 3); grid on; box off;
title('Yaw relation: Mag (raw mag field) VS. Gyro');

subplot(5,3,6);
hist(ddump.mag.yaw.inf, 50); box off;
title('Mag o (raw mag field) data distribution for yaw');

subplot(5,3,9);
hist(ddump.mag.yaw.lrn, 50); box off;
title('Gyro data distribution for yaw');

subplot(5,3,12); 
plot(ddump.gt.t, ddump.gt.yaw); hold on; 
plot(ddump.gt.t, ddump.mag.yaw.disp); hold on;
plot(ddump.gt.t, ddump.mag.yaw.lrn); grid on; box off;
title('Yaw angle'); legend('Ground truth', 'Mag', 'Gyro');

subplot(5,3,15); plot(sort(ddump.gt.yaw),sort(ddump.mag.yaw.disp),'.r'); hold on;
plot(sort(ddump.mag.yaw.lrn),sort(ddump.mag.yaw.disp),'.b'); grid on; box off;
title('Yaw angle'); legend('Mag VS. Ground truth', 'Mag VS. Gyro');

%% individual plots

% figure; 
% set(gcf, 'color', 'white');
% plot(sort(ddump.acc.roll.inf), sort(ddump.acc.roll.lrn),'.g', 'LineWidth', 3); grid on; box off; 
% title('Roll relation: Acc (raw   acc) VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng rollrelation.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(ddump.gt.t, (ddump.acc.roll.inf),'r', 'LineWidth', 3); grid on; box off; 
% title('Roll from Acc (raw   acc)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng rollinf.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.acc.roll.inf, 50); box off;
% title('Acc (raw   acc) data distribution for roll');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng rollaccdistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.acc.roll.lrn, 50); box off;
% title('Gyro data distribution for roll');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng rollgyrodistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(ddump.gt.t, ddump.gt.roll); hold on; 
% plot(ddump.gt.t, ddump.acc.roll.disp); hold on;
% plot(ddump.gt.t, ddump.acc.roll.lrn);grid on; box off;
% title('Roll angle'); legend('Ground truth', 'Acc', 'Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng rollall.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(sort(ddump.gt.roll),sort(ddump.acc.roll.disp),'.r'); hold on;
% plot(sort(ddump.acc.roll.lrn),sort(ddump.acc.roll.disp), '.b'); grid on; box off;
% title('Roll angle'); legend('Acc VS. Ground truth', 'Acc VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng rolleval.png
% close
% 
% figure; 
% set(gcf, 'color', 'white'); 
% plot(sort(ddump.acc.pitch.inf), sort(ddump.acc.pitch.lrn),'.b');grid on; box off;
% title('Pitch relation: Acc (raw   acc) VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng pitchrelation.png
% close
% 
% figure; 
% set(gcf, 'color', 'white'); 
% plot(ddump.gt.t, (ddump.acc.pitch.inf),'r', 'LineWidth', 3);grid on; box off;
% title('Pitch from Acc (raw   acc)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng pitchinf.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.acc.pitch.inf, 50); box off;
% title('Acc (raw   acc) data distribution for pitch');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng pitchaccdistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.acc.pitch.lrn, 50); box off;
% title('Gyro data distribution for pitch');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng pitchgyrodistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white'); 
% plot(ddump.gt.t, ddump.gt.pitch); hold on; 
% plot(ddump.gt.t, ddump.acc.pitch.disp); hold on;
% plot(ddump.gt.t, ddump.acc.pitch.lrn); grid on; box off;
% title('Pitch angle'); legend('Ground truth', 'Acc', 'Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng pitchall.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(sort(ddump.gt.pitch),sort(ddump.acc.pitch.disp),'.r'); hold on;
% plot(sort(ddump.acc.pitch.lrn),sort(ddump.acc.pitch.disp),'.b'); grid on; box off;
% title('Pitch angle'); legend('Acc VS. Ground truth', 'Acc VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng pitcheval.png
% close
% 
% % MAG OMETER
% figure; 
% set(gcf, 'color', 'white');
% plot(sort(ddump.mag.yaw.inf), sort(ddump.mag.yaw.lrn),'.m'); grid on; box off;
% title('Yaw relation: Mag (raw mag field) VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng yawrelation.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(ddump.gt.t,(ddump.mag.yaw.inf),'m', 'LineWidth', 3); grid on; box off;
% title('Yaw from Mag (raw mag field)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng yawinf.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.mag.yaw.inf, 50); box off;
% title('Mag (raw mag field) data distribution for yaw');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng yawmagdistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% hist(ddump.mag.yaw.lrn, 50); box off;
% title('Gyro data distribution for yaw');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng yawgyrodistr.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(ddump.gt.t, ddump.gt.yaw); hold on; 
% plot(ddump.gt.t, ddump.mag.yaw.disp); hold on;
% plot(ddump.gt.t, ddump.mag.yaw.lrn); grid on; box off;
% title('Yaw angle'); legend('Ground truth', 'Mag', 'Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng yawall.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(sort(ddump.gt.yaw),sort(ddump.mag.yaw.disp),'.r'); hold on;
% plot(sort(ddump.mag.yaw.lrn),sort(ddump.mag.yaw.disp),'.b'); grid on; box off;
% title('Yaw angle'); legend('Mag VS. Ground truth', 'Mag VS. Gyro');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5]);
% print -dpng yaweval.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t, (data.acc_filt(2,:)-data.EKF.alin(2,:)),'.r', 'LineWidth', 3); grid on; box off; 
% title('Acc (raw acc y axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');
% set(gcf, 'PaperUnits','centimeters');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng  accyraw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,(data.acc_filt(3,:)-data.EKF.alin(3,:)),'.r', 'LineWidth', 3); grid on; box off; 
% title('Acc (raw acc z axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng acczraw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,(data.acc_filt(1,:)-data.EKF.alin(1,:)),'.r', 'LineWidth', 3); grid on; box off; 
% title('Acc (raw acc x axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng accxraw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.GYRO.roll,'.g'); grid on; box off; hold on;
% plot(data.t,data.GT.roll,'.b');grid on; box off;
% legend('Gyro roll','GT roll');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng gyrorawroll.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.GYRO.pitch,'.g'); grid on; box off; hold on;
% plot(data.t,data.GT.pitch,'.b');grid on; box off;
% legend('Gyro pitch','GT pitch');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng gyrorawpitch.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.GYRO.yaw,'.g'); grid on; box off; hold on;
% plot(data.t,data.GT.yaw,'.b');grid on; box off;
% legend('Gyro yaw','GT yaw');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng gyrorawyaw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.MAG.bfield(1,:),'.m'); grid on; box off; 
% title('Mag (raw mag x axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng magxraw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.MAG.bfield(2,:),'.m'); grid on; box off; 
% title('Mag (raw mag y axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto');xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng magyraw.png
% close
% 
% figure; 
% set(gcf, 'color', 'white');
% plot(data.t,data.MAG.bfield(3,:),'.m'); grid on; box off; 
% title('Mag (raw mag z axis)');
% set(gca, 'LooseInset', get(gca, 'TightInset') ,'FontWeight','Bold','LineWidth',2);
% set(gcf, 'PaperPositionMode', 'auto'); xlabel('time (s)');
% set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 5]);
% print -dpng magzraw.png
% close

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

