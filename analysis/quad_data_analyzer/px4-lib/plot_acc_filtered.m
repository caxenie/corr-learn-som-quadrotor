
function [] = plot_acc_filtered(ld)

imu = ld.imu;
acc = ld.acc;

r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);

k=1;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = imu.xacc;
p(k).d{2} = acc.ax_f;


k=2;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = imu.yacc;
p(k).d{2} = acc.ay_f;


k=3;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = imu.zacc;
p(k).d{2} = acc.az_f;


p(1).title = 'acc x (m/s^2)';
p(2).title = 'acc y (m/s^2)';
p(3).title = 'acc z (m/s^2)';

p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';

p(1).legend = {'raw','filtered'};
p(2).legend = {'raw','filtered'};
p(3).legend = {'raw','filtered'};



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
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)


k=2;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')

legend(p(k).legend)

k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')

legend(p(k).legend)


h = gcf;
set(h,'Name','ACC: Filtered data','NumberTitle','off');


