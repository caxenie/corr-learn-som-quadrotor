
function [] = plot_rpy_acc(ld)

imu = ld.imu;
att = ld.att;
rb = ld.rb;

acc = ld.acc;

cm = colormap(jet(5));

r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);


k=1;
p(k).title = 'roll';
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;
% p(k).t{4} = imu.hrt.t(imu.acc.valid);
p(k).t{4} = imu.hrt.t;
p(k).t{5} = imu.hrt.t;

p(k).d{1} = -rb.roll;
p(k).d{2} = att.roll;
p(k).d{3} = acc.raw.roll;
% p(k).d{4} = imu.acc.roll_raw(imu.acc.valid);
p(k).d{4} = acc.rot.roll;
p(k).d{5} = ld.KF.roll.x(1,:);


k=2;
p(k).title = 'pitch';
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;
% p(k).t{4} = imu.hrt.t(imu.acc.valid);
p(k).t{4} = imu.hrt.t;
p(k).t{5} = imu.hrt.t;


p(k).d{1} = rb.pitch;
p(k).d{2} = att.pitch;
p(k).d{3} = acc.raw.pitch;
% p(k).d{4} = imu.acc.pitch_raw(imu.acc.valid);
p(k).d{4} = acc.rot.pitch;
p(k).d{5} = ld.KF.pitch.x(1,:);

k=3;
p(k).title = 'norm(a)';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = acc.a_norm;
p(k).d{2} = acc.a_lin_norm;


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';

p(1).legend = {'tracker','EKF','acc_{LP}','angle(a_{rot})','KF'};
p(2).legend = {'tracker','EKF','acc_{LP}','angle(a_{rot})','KF'};
p(3).legend = {'norm(a)',' norm(a_{lin})'};

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


k=2;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
plot(p(k).t{4},p(k).d{4},'-','Color','g')
plot(p(k).t{5},p(k).d{5},'-','Color','c')

legend(p(k).legend)


k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')

legend(p(k).legend)


h = gcf;
set(h,'Name','RPY-Acc: Compare acc raw angles to ref','NumberTitle','off');

end





