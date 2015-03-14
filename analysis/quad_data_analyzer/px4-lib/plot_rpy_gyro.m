
function [] = plot_rpy_gyro(ld)

imu = ld.imu;
att = ld.att;
rb = ld.rb;

gyro = ld.gyro;



r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);


k=1;
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = -rb.roll;
p(k).d{2} = att.roll;
p(k).d{3} = gyro.raw.roll;



k=2;
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = rb.pitch;
p(k).d{2} = att.pitch;
p(k).d{3} = gyro.raw.pitch;



k=3;
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = -rb.yaw;
p(k).d{2} = att.yaw - ld.yaw_off;
p(k).d{3} = gyro.raw.yaw;


p(1).title = 'roll';
p(2).title = 'pitch';
p(3).title = 'yaw';

p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';


p(1).legend = {'tracker','EKF','int(v_{roll, gyro})'};
p(2).legend = {'tracker','EKF','int(v_{pitch, gyro})'};
p(3).legend = {'tracker','EKF','int(v_{yaw, gyro})'};

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
plot(p(k).t{3},p(k).d{3},'-','Color','c')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


k=2;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','c')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','c')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


h = gcf;
set(h,'Name','RPY-Gyro: Compare gyro raw angles to ref','NumberTitle','off');

end
