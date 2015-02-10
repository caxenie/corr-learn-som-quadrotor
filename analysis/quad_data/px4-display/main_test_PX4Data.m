clear all
close all

load('PX4DataNew.mat','-mat');


% figure
% x = data.t;
% y1 = data.EKF.yaw;
% y2 = data.MAG.gt.yaw;
% y3 = data.MAG.ekf.yaw;
% y4 = data.GYRO.yaw;
% y5 = data.GT.yaw;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% plot(x,y3,'g');
% plot(x,y4,'m');
% plot(x,y5,'c');
% 
% figure
% x = data.t;
% y1 = data.mag(1,:);
% y2 = data.EKF.mag(1,:);
% y3 = data.GT.mag(1,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% plot(x,y3,'g');
% 
% figure
% x = data.t;
% y1 = data.mag(2,:);
% y2 = data.EKF.mag(2,:);
% y3 = data.GT.mag(2,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% plot(x,y3,'g');
% 
% figure
% x = data.t;
% y1 = data.mag(3,:);
% y2 = data.EKF.mag(3,:);
% y3 = data.GT.mag(3,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% plot(x,y3,'g');

% figure
% x = data.t;
% y1 = data.GT.roll;
% y2 = data.EKF.roll;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% figure
% x = data.t;
% y1 = data.GT.pitch;
% y2 = data.EKF.pitch;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% figure
% x = data.t;
% y1 = data.GT.yaw;
% y2 = data.EKF.yaw;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
figure
x = data.t;
y1 = data.GT.acc(1,:);
y2 = data.EKF.alin(1,:);
y3 = data.GT.alin(1,:);

plot(x,y1,'b');
grid on
hold on
plot(x,y2,'r');
plot(x,y3,'g');

figure
x = data.t;
y1 = data.GT.acc(2,:);
y2 = data.EKF.alin(2,:);
y3 = data.GT.alin(2,:);

plot(x,y1,'b');
grid on
hold on
plot(x,y2,'r');
plot(x,y3,'g');


figure
x = data.t;
y1 = data.GT.acc(3,:);
y2 = data.EKF.alin(3,:);
y3 = data.GT.alin(3,:);

plot(x,y1,'b');
grid on
hold on
plot(x,y2,'r');
plot(x,y3,'g');



figure
x = data.t;
y1 = data.GT.arot(3,:);

plot(x,y1,'b');
grid on
hold on
% plot(x,y2,'r');
% plot(x,y3,'g');


% figure
% x = data.t;
% y1 = data.vel(1,:);
% y2 = data.vel(2,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% figure
% x = data.t;
% y1 = data.GT.roll;
% y2 = data.GYRO.roll;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% figure
% x = data.t;
% y1 = data.GT.pitch;
% y2 = data.GYRO.pitch;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');



% figure
% x = data.t;
% y1 = data.EKF.roll;
% y2 = data.ACC.roll;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% 
% figure
% x = data.t;
% y1 = data.EKF.pitch;
% y2 = data.ACC.pitch;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');




% figure
% x = data.t;
% y1 = data.GT.pos(1,:);
% y2 = data.GT.pos(2,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% 
% figure
% x = data.t;
% y1 = data.acc_filt(1,:);
% y2 = data.acc_filt(2,:);
% y3 = data.acc_filt(3,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% plot(x,y3,'g');




% figure
% x = data.t;
% y1 = data.GT.h;
% y2 = data.OF.h;
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% figure
% x = data.t;
% y1 = data.GT.vel(1,:);
% y2 = data.OF.vel(1,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
% 
% figure
% x = data.t;
% y1 = data.GT.vel(2,:);
% y2 = data.OF.vel(2,:);
% 
% plot(x,y1,'b');
% grid on
% hold on
% plot(x,y2,'r');
