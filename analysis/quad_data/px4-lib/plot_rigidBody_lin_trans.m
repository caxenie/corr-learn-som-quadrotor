
function [] = plot_rigidBody_lin_trans(ld)

imu = ld.imu;
att = ld.att;
rb = ld.rb;


r = 3;
c = 3;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);
p(7).h = subplot(r,c,7);
p(8).h = subplot(r,c,8);
p(9).h = subplot(r,c,9);

k=1;
p(k).title = 'x [m]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.x;


k=2;
p(k).title = 'y [m]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.y -0.12;

k=3;
p(k).title = 'z [m]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.z;


k=4;
p(k).title = 'v_x [m/s]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.vx;


k=5;
p(k).title = 'v_y [m/s]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.vy;

k=6;
p(k).title = 'v_z [m/s]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.vz;


k=7;
p(k).title = 'a_x  [m/s^2]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.ax;


k=8;
p(k).title = 'a_y [m/s^2]';
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.ay;

k=9;
p(k).title = 'a_z [m/s^2]' ;
p(k).t{1} = rb.hrt.t;
p(k).d{1} = rb.az;



p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';
p(7).ylim = 'auto';
p(8).ylim = 'auto';
p(9).ylim = 'auto';

% p(1).legend = {''};
% p(2).legend = {''};
% p(3).legend = {''};
% p(4).legend = {''};
% p(5).legend = {''};
% p(6).legend = {''};

for k=1:9
    
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
% plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
% legend(p(k).legend)


k=2;
subplot(p(k).h)
% plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
% legend(p(k).legend)


k=3;
subplot(p(k).h)
% plot(p(k).t{2},p(k).d{2},'-','Color','r')
% plot(p(k).t{3},p(k).d{3},'-','Color','m')
% plot(p(k).t{4},p(k).d{4},'.','Color','g')
% 
% legend(p(k).legend)


h = gcf;
set(h,'Name','Tracker: rigidBody - linear translations','NumberTitle','off');


end






