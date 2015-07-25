
function [] = plot_time_analysis(ld)

imu = ld.imu;
att = ld.att;
of = ld.of;
rb = ld.rb;


r = 4;
c = 2;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);

p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);

p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);

p(7).h = subplot(r,c,7);
p(8).h = subplot(r,c,8);


k = 1;
p(k).title = 't - imu';
p(k).x{1} = 1:imu.n;
p(k).x{2} = 1:imu.n;

p(k).y{1} = imu.t;
p(k).y{2} = imu.hrt.t;

k = 2;
p(k).title = 'dt - imu';
p(k).x{1} = 1:imu.n;
p(k).x{2} = p(k).x{1};
p(k).x{3} = p(k).x{1};
p(k).x{4} = p(k).x{1};
p(k).x{5} = p(k).x{1};

E = ones(imu.n,1);
p(k).y{1} = imu.dt;
p(k).y{2} = imu.hrt.dt;
p(k).y{3} = imu.dt_min * E;
p(k).y{4} = imu.dt_max * E;
p(k).y{5} = imu.dt_mean * E;


k = 3;
p(k).title = 't - attitude';
p(k).x{1} = 1:att.n;
p(k).x{2} = 1:att.n;

p(k).y{1} = att.t;
p(k).y{2} = att.hrt.t;

k = 4;
p(k).title = 'dt - attitude';
p(k).x{1} = 1:att.n;
p(k).x{2} = p(k).x{1};
p(k).x{3} = p(k).x{1};
p(k).x{4} = p(k).x{1};
p(k).x{5} = p(k).x{1};

E = ones(att.n,1);
p(k).y{1} = att.dt;
p(k).y{2} = att.hrt.dt;
p(k).y{3} = att.dt_min * E;
p(k).y{4} = att.dt_max * E;
p(k).y{5} = att.dt_mean * E;


k = 5;
p(k).title = 't - optical flow';
p(k).x{1} = 1:of.n;
p(k).x{2} = 1:of.n;

p(k).y{1} = of.t;
p(k).y{2} = of.hrt.t;

k = 6;
p(k).title = 't - optical flow';
p(k).x{1} = 1:of.n;
p(k).x{2} = p(k).x{1};
p(k).x{3} = p(k).x{1};
p(k).x{4} = p(k).x{1};
p(k).x{5} = p(k).x{1};

E = ones(of.n,1);
p(k).y{1} = of.dt;
p(k).y{2} = of.hrt.dt;
p(k).y{3} = of.dt_min * E;
p(k).y{4} = of.dt_max * E;
p(k).y{5} = of.dt_mean * E;


k = 7;
p(k).title = 't - rigid body';
p(k).x{1} = 1:rb.n;
p(k).x{2} = 1:rb.n;

p(k).y{1} = rb.t;
p(k).y{2} = rb.hrt.t;

k = 8;
p(k).title = 'dt - rigid body';
p(k).x{1} = 1:rb.n;
p(k).x{2} = p(k).x{1};
p(k).x{3} = p(k).x{1};
p(k).x{4} = p(k).x{1};
p(k).x{5} = p(k).x{1};

E = ones(rb.n,1);
p(k).y{1} = rb.dt;
p(k).y{2} = rb.hrt.dt;
p(k).y{3} = rb.dt_min * E;
p(k).y{4} = rb.dt_max * E;
p(k).y{5} = rb.dt_mean * E;


start = 1000;
stop = 1020;

p(1).xlim = [start stop];
p(2).xlim = [start stop];
p(3).xlim = [start stop];
p(4).xlim = [start stop];
p(5).xlim = [start stop];
p(6).xlim = [start stop];
p(7).xlim = [start stop];
p(8).xlim = [start stop];


% p(1).xlim = 'auto';
% p(2).xlim = 'auto';
% p(3).xlim = 'auto';
% p(4).xlim = 'auto';
% p(5).xlim = 'auto';
% p(6).xlim = 'auto';
% p(7).xlim = 'auto';
% p(8).xlim = 'auto';


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';
p(7).ylim = 'auto';
p(8).ylim = 'auto';


p(1).legend = {'pc','hrt'};
p(2).legend = {'pc','hrt'};
p(3).legend = {'pc','hrt'};
p(4).legend = {'pc','hrt'};
p(5).legend = {'pc','hrt'};
p(6).legend = {'pc','hrt'};
p(7).legend = {'pc','hrt'};
p(8).legend = {'pc','hrt'};



for k=1:8
    
    subplot(p(k).h)
    plot(p(k).x{1}, p(k).y{1})
    
    hold on
    grid on
    
    xlim(p(k).xlim)
    ylim(p(k).ylim)
    
    xlabel('samples')
    
    title(p(k).title)
end


k = 1;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')

legend(p(k).legend)


k = 2;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')
plot(p(k).x{3}, p(k).y{3},'r')
plot(p(k).x{4}, p(k).y{4},'r')
plot(p(k).x{5}, p(k).y{5},'r')

legend(p(k).legend)


k = 3;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')

legend(p(k).legend)


k = 4;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')
plot(p(k).x{3}, p(k).y{3},'r')
plot(p(k).x{4}, p(k).y{4},'r')
plot(p(k).x{5}, p(k).y{5},'r')

legend(p(k).legend)


k = 5;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')

legend(p(k).legend)


k = 6;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')
plot(p(k).x{3}, p(k).y{3},'r')
plot(p(k).x{4}, p(k).y{4},'r')
plot(p(k).x{5}, p(k).y{5},'r')

legend(p(k).legend)


k = 7;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')

legend(p(k).legend)


k = 8;
subplot(p(k).h)
plot(p(k).x{2}, p(k).y{2},'g')
plot(p(k).x{3}, p(k).y{3},'r')
plot(p(k).x{4}, p(k).y{4},'r')
plot(p(k).x{5}, p(k).y{5},'r')

legend(p(k).legend)


h = gcf;
set(h,'Name','Time analysis','NumberTitle','off');
