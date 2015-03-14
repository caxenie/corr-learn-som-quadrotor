
function [] = plot_KF_roll(ld)

imu = ld.imu;
att = ld.att;
acc = ld.acc;

if(isfield(ld,'rb'))
    rb = ld.rb;
else
    rb.t        = 0;
    rb.roll     = 0;
    rb.pitch    = 0;
    rb.yaw      = 0;
end

r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);
% p(4).h = subplot(r,c,4);
% p(5).h = subplot(r,c,5);

k=1;
p(k).title = 'roll';
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;
p(k).t{4} = imu.hrt.t;
p(k).t{5} = imu.hrt.t;

p(k).d{1} = -rb.roll;
p(k).d{2} = att.roll;
p(k).d{3} = acc.raw.roll;
p(k).d{4} = ld.KF.roll.x(1,:);
p(k).d{5} = ld.gyro.raw.roll;


k=2;
p(k).title = 'KF - drift';
p(k).t{1} = imu.hrt.t;
p(k).d{1} = ld.KF.roll.x(2,:);

% k=3;
% p(k).title = 'KF - gyro/acc ratio';
% p(k).t{1} = imu.hrt.t;
% p(k).d{1} = ld.KF.roll.K(1,:);
% 
% 
% k=4;
% p(k).title = 'KF - error to drift weight';
% p(k).t{1} = imu.hrt.t;
% p(k).d{1} = ld.KF.roll.K(2,:);


k=3;
p(k).title = 'KF - prediction error';
p(k).t{1} = imu.hrt.t;
p(k).d{1} = ld.KF.roll.y;


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';
p(5).ylim = 'auto';


p(1).legend = {'tracker','EKF','acc_{LP}','KF','gyro_{raw}'};
p(2).legend = {'drift','K1','K2'};

for k=1:3
    
    subplot(p(k).h)
    plot(p(k).t{1},p(k).d{1},'b')
    hold on
    
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
    
end


k=1;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
plot(p(k).t{4},p(k).d{4},'-','Color','g')
plot(p(k).t{5},p(k).d{5},'-','Color','c')

legend(p(k).legend)


% k=2;
% subplot(p(k).h)
% plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% % plot(p(k).t{4},p(k).d{4},'.','Color','g')
% plot(p(k).t{4},p(k).d{4},'-','Color','g')
% % plot(p(k).t{5},p(k).d{5},'-','Color','c')
% 
% legend(p(k).legend)


% k=3;
% subplot(p(k).h)
% plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% % plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
% legend(p(k).legend)


h = gcf;
set(h,'Name','Kalman filter roll','NumberTitle','off');

end





