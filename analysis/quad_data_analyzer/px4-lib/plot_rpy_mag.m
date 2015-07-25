
function [] = plot_rpy_mag(ld)

imu = ld.imu;
att = ld.att;
rb = ld.rb;
mag = ld.mag;

cm = colormap(jet(5));

r = 1;
c = 1;

p(1).h = subplot(r,c,1);


k=1;
p(k).t{1} = rb.t;
p(k).t{2} = att.t;
p(k).t{3} = imu.hrt.t;

p(k).d{1} = -rb.yaw;
p(k).d{2} = att.yaw - ld.yaw_off;
p(k).d{3} = mag.yaw_off - mag.yaw_f;


p(1).title = 'yaw';


p(1).ylim = 'auto';


p(1).legend = {'tracker','EKF','mag'};

for k=1:1

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

legend(p(k).legend)


h = gcf;
set(h,'Name','RPY-Mag: Compare mag raw angles to ref','NumberTitle','off');


