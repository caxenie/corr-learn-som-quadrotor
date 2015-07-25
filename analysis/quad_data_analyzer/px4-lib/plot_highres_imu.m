
function [] = plot_highres_imu(imu, tsmin)


ts = imu.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end


r = 3;
c = 3;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);

p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);

p(7).h = subplot(r,c,7);
p(8).h = subplot(r,c,8);
p(9).h = subplot(r,c,9);

% p(10).h = subplot(r,c,10);
% p(11).h = subplot(r,c,11);



p(1).d = imu.xacc;
p(2).d = imu.yacc;
p(3).d = imu.zacc;

p(4).d = imu.xgyro;
p(5).d = imu.ygyro;
p(6).d = imu.zgyro;

p(7).d = imu.xmag;
p(8).d = imu.ymag;
p(9).d = imu.zmag;

% p(10).d = imu.abs_pressure;
% p(11).d = imu.pressure_alt;



p(1).title = 'acc x (m/s^2)';
p(2).title = 'acc y (m/s^2)';
p(3).title = 'acc z (m/s^2)';

p(4).title = 'gyro x (rad/s)';
p(5).title = 'gyro y (rad/s)';
p(6).title = 'gyro z (rad/s)';

p(7).title = 'mag x (Gauss)';
p(8).title = 'mag y (Gauss)';
p(9).title = 'mag z (Gauss)';

% p(10).title = 'abs pressure (mBar)';
% p(11).title = 'pressure alt (m)';


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';

p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';

p(7).ylim = 'auto';
p(8).ylim = 'auto';
p(9).ylim = 'auto';


% p(1).ylim = [-10, 10];
% p(2).ylim = [-10, 10];
% p(3).ylim = [-10, 10] -10;
% 
% p(4).ylim = [-3, 3];
% p(5).ylim = [-3, 3];
% p(6).ylim = [-3, 3];
% 
% p(7).ylim = [-0.6, 0.6];
% p(8).ylim = [-0.6, 0.6];
% p(9).ylim = [-0.6, 0.6];
% 
% p(10).ylim = [0, 1100];
% p(11).ylim = [0, 1000];



for k=1:9

    subplot(p(k).h)
    plot(t, p(k).d)
    
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end


h = gcf;
set(h,'Name','IMU raw data','NumberTitle','off');
