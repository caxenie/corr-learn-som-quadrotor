
function [] = plot_acc_LPF_and_FT(ld)

imu = ld.imu;
acc = ld.acc;


r = 3;
c = 2;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);


k=1;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = acc.ax;
p(k).d{2} = acc.ax_f;
p(k).title = 'acc x (m/s^2)';
p(k).legend = {'raw','filtered'};

k=2;
p(k).t{1} = acc.FT.ax.f;
p(k).t{2} = acc.FT.ax_f.f;

p(k).d{1} = acc.FT.ax.H;
p(k).d{2} = acc.FT.ax_f.H;
p(k).title = 'FT acc x (m/s^2)';
p(k).legend = {'raw','filtered'};


k=3;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = acc.ay;
p(k).d{2} = acc.ay_f;
p(k).title = 'acc y (m/s^2)';
p(k).legend = {'raw','filtered'};

k=4;
p(k).t{1} = acc.FT.ay.f;
p(k).t{2} = acc.FT.ay_f.f;

p(k).d{1} = acc.FT.ay.H;
p(k).d{2} = acc.FT.ay_f.H;
p(k).title = 'FT acc y (m/s^2)';
p(k).legend = {'raw','filtered'};


k=5;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = acc.az;
p(k).d{2} = acc.az_f;
p(k).title = 'acc z (m/s^2)';
p(k).legend = {'raw','filtered'};

k=6;
p(k).t{1} = acc.FT.az.f;
p(k).t{2} = acc.FT.az_f.f;

p(k).d{1} = acc.FT.az.H;
p(k).d{2} = acc.FT.az_f.H;
p(k).title = 'FT acc z (m/s^2)';
p(k).legend = {'raw','filtered'};



% k=3;
% p(k).t{1} = rb.t;
% p(k).t{2} = att.t;
% p(k).t{3} = imu.hrt.t;
% 
% p(k).d{1} = -rb.roll;
% p(k).d{2} = att.roll;
% p(k).d{3} = imu.acc.roll_raw;




p(1).ylim = 'auto';
% p(2).ylim = 'auto';
p(3).ylim = 'auto';
% p(4).ylim = 'auto';
p(5).ylim = 'auto';
% p(6).ylim = 'auto';

p(2).ylim = [0,0.2];
p(4).ylim = [0,0.2];
p(6).ylim = [0,0.2];


% p(3).legend = {'tracker','EKF','acc'};


for k=1:6

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


k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)


k=4;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)


k=5;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)


k=6;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'r')
% plot(p(k).t{3},p(k).d{3},'g')
% plot(p(k).t{4},p(k).d{4},'m')

legend(p(k).legend)



h = gcf;
set(h,'Name','Acc: LP filter and FT','NumberTitle','off');


end
