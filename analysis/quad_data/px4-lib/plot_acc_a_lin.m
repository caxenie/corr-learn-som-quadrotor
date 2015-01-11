
function [] = plot_acc_a_lin(ld)

imu = ld.imu;
rb = ld.rb;
acc = ld.acc;

r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);


k=1;
p(k).title = 'a_x  [m/s^2]';
p(k).t{1} = rb.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = -rb.az;
p(k).d{2} = acc.a_lin_f(1,:);



k=2;
p(k).title = 'a_y [m/s^2]';
p(k).t{1} = rb.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = rb.ax;
p(k).d{2} = acc.a_lin_f(2,:);

k=3;
p(k).title = 'a_z [m/s^2]' ;
p(k).t{1} = rb.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = -rb.ay;
p(k).d{2} = acc.a_lin_f(3,:);


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';
p(7).ylim = 'auto';
p(8).ylim = 'auto';
p(9).ylim = 'auto';

p(1).legend = {'tracker','imu'};
p(2).legend = {'tracker','imu'};
p(3).legend = {'tracker','imu'};
% p(4).legend = {''};
% p(5).legend = {''};
% p(6).legend = {''};

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
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
legend(p(k).legend)


k=2;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
legend(p(k).legend)


k=3;
subplot(p(k).h)
plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
legend(p(k).legend)


h = gcf;
set(h,'Name','Acc: Linear accelerations','NumberTitle','off');


end






