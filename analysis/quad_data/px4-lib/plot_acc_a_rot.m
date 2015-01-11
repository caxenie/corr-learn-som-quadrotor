
function [] = plot_acc_a_rot(ld)

imu = ld.imu;
acc = ld.acc;


r = 3;
c = 1;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);


k=1;
p(k).title = 'a_x  [m/s^2]';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.a_rot_ref(1,:);
p(k).d{2} = acc.a_rot_f(1,:);



k=2;
p(k).title = 'a_y [m/s^2]';
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.a_rot_ref(2,:);
p(k).d{2} = acc.a_rot_f(2,:);

k=3;
p(k).title = 'a_z [m/s^2]' ;
p(k).t{1} = imu.hrt.t;
p(k).t{2} = imu.hrt.t;

p(k).d{1} = ld.a_rot_ref(3,:);
p(k).d{2} = acc.a_rot_f(3,:);
% p(k).d{2} = 0.1*(imu.acc.a_rot_rb_f(3,:))-imu.acc.g;

% p(1).ylim = 'auto';
% p(2).ylim = 'auto';
% p(3).ylim = [-12, -8];
p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';
p(7).ylim = 'auto';
p(8).ylim = 'auto';
p(9).ylim = 'auto';

% p(1).ylim = [-2, 2];
% p(2).ylim = [-2, 2];
% p(3).ylim = [-12, -8];

p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';


p(1).legend = {'ref','imu, tracker'};
p(2).legend = {'ref','imu, tracker'};
p(3).legend = {'ref','imu, tracker'};
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
set(h,'Name','Acc: Rotational-gravitational accelerations','NumberTitle','off');


end






