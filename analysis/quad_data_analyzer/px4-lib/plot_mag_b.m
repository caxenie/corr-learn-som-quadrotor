
function [] = plot_mag_b(ld)

imu = ld.imu;
rb = ld.rb;
mag = ld.mag;

r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);


k=1;
p(k).title = 'b_x  [Gauss]';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.b_ref(1,:);
p(k).d{2} = mag.bx;




k=2;
p(k).title = 'b_y  [Gauss]';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.b_ref(2,:);
p(k).d{2} = mag.by;


k=3;
p(k).title = 'b_z  [Gauss]';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.b_ref(3,:);
p(k).d{2} = mag.bz;



p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';


p(1).legend = {'ref','imu'};
p(2).legend = {'ref','imu'};
p(3).legend = {'ref','imu'};


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
set(h,'Name','MAG: Compare meas. to ref','NumberTitle','off');


end






