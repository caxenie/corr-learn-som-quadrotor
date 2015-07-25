
function [] = plot_rpy(ld)

imu = ld.imu;
att = ld.att;

if(isfield(ld,'rb'))
    rb = ld.rb;
else
    rb.t        = 0;
    rb.roll     = 0;
    rb.pitch    = 0;
    rb.yaw      = 0;
end


acc = ld.acc;
gyro = ld.gyro;

cm = colormap(jet(5));

r = 3;
c = 2;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5:6);


k=1;
p(k).t{1} = att.t;
p(k).t{2} = rb.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = att.roll-att.roll_off;
p(k).d{2} = -rb.roll;
p(k).d{3} = gyro.raw.roll;


k=2;
p(k).t{1} = att.t;
p(k).t{2} = rb.t;
p(k).t{3} = imu.hrt.t;
p(k).t{4} = imu.hrt.t(acc.valid);

p(k).d{1} = att.roll-att.roll_off;
p(k).d{2} = -rb.roll;
p(k).d{3} = acc.raw.roll;
p(k).d{4} = acc.raw.roll(acc.valid);


k=3;
p(k).t{1} = att.t;
p(k).t{2} = rb.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = att.pitch - att.pitch_off;
p(k).d{2} = rb.pitch;
p(k).d{3} = gyro.raw.pitch;


k=4;
p(k).t{1} = att.t;
p(k).t{2} = rb.t;
p(k).t{3} = imu.hrt.t;
p(k).t{4} = imu.hrt.t(acc.valid);

p(k).d{1} = att.pitch - att.pitch_off;
p(k).d{2} = rb.pitch;
p(k).d{3} = acc.raw.pitch;
p(k).d{4} = acc.raw.pitch(acc.valid);

k=5;
p(k).t{1} = att.t;
p(k).t{2} = rb.t;
p(k).t{3} = imu.hrt.t;
p(k).t{4} = imu.hrt.t;

p(k).d{1} = att.yaw - ld.yaw_off;
p(k).d{2} = -rb.yaw;
p(k).d{3} = gyro.raw.yaw;
p(k).d{4} = -(ld.mag.yaw - ld.mag.yaw_off);


p(1).title = 'roll';
p(2).title = 'roll';
p(3).title = 'pitch';
p(4).title = 'pitch';
p(5).title = 'yaw';



p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';
p(5).ylim = 'auto';



p(1).legend = {'EKF','tracker','int(v_{roll, gyro})'};
p(2).legend = {'EKF','tracker','acc_{roll}','quality'};

p(3).legend = {'EKF','tracker','int(v_{pitch, gyro})'};
p(4).legend = {'EKF','tracker','acc_{pitch}','quality'};

p(5).legend = {'EKF','tracker','int(v_{yaw, gyro})','mag'};

for k=1:5

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
plot(p(k).t{3},p(k).d{3},'-','Color','m')
plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','c')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


k=4;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','m')
plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


k=5;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','c')
plot(p(k).t{4},p(k).d{4},'-','Color','m')

legend(p(k).legend)


h = gcf;
set(h,'Name','RPY: attitude overview','NumberTitle','off');

end
