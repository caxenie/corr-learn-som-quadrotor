
function [] = plot_acc_angle_vel(ld)

imu = ld.imu;
acc = ld.acc;

r = 2;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);



k=1;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = imu.xgyro;
p(k).d{2} = acc.raw.droll;

p(k).title = 'roll';
p(k).legend = {'gyro','acc'};
p(k).ylim = 'auto';


k=2;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = imu.ygyro;
p(k).d{2} = acc.raw.dpitch;

p(k).title = 'roll';
p(k).legend = {'gyro','acc'};
p(k).ylim = 'auto';



for k=1:2

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
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)


k=2;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)



h = gcf;
set(h,'Name','ACC: compare rotational vel','NumberTitle','off');


end
