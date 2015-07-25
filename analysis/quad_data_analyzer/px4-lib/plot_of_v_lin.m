function [] = plot_of_v_lin(ld)

of = ld.of;
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


p(1).t{1} = rb.t;
p(2).t{1} = rb.t;
p(3).t{1} = rb.t;
p(4).t{1} = rb.t;
p(5).t{1} = rb.t;
p(6).t{1} = rb.t;
p(7).t{1} = rb.t;
p(8).t{1} = rb.t;
p(9).t{1} = rb.t;

p(1).d{1} = rb.x;
p(2).d{1} = rb.y -0.12;
p(3).d{1} = rb.z;
p(4).d{1} = rb.raw.vx;
p(5).d{1} = rb.raw.vy;
p(6).d{1} = rb.raw.vz;
p(7).d{1} = rb.vx;
p(8).d{1} = rb.vy;
p(9).d{1} = rb.vz;


p(2).t{2} = of.t;
p(4).t{2} = rb.t;
p(5).t{2} = rb.t;
p(6).t{2} = rb.t;
p(7).t{2} = of.t;
p(8).t{2} = of.t;
p(9).t{2} = of.t;

p(2).d{2} = of.h_th;
p(4).d{2} = rb.vx;
p(5).d{2} = rb.vy;
p(6).d{2} = rb.vz;
p(7).d{2} = -of.vy_f;
p(9).d{2} = of.vx_f;

p(2).t{3} = of.t(of.i_quality_ok);
p(7).t{3} = of.t(of.i_quality_ok);
p(9).t{3} = of.t(of.i_quality_ok);

p(2).d{3} = of.h_th(of.i_quality_ok);
p(7).d{3} = -of.vy_f(of.i_quality_ok);
p(9).d{3} = of.vx_f(of.i_quality_ok);



p(1).title = 'x [m]';
p(2).title = 'y [m] (height)';
p(3).title = 'z [m]';

p(4).title = 'v_x - tracker';
p(5).title = 'v_y - tracker';
p(6).title = 'v_z - tracker';

p(7).title = 'v_x';
p(8).title = 'v_y';
p(9).title = 'v_z';


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';

p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';

p(7).ylim = 'auto';
p(8).ylim = 'auto';
p(9).ylim = 'auto';


p(2).legend = {'tracker', 'sonar', sprintf('quality > %3i%%',ld.of.qth*100)};

p(4).legend = {'v_{x,raw}', 'v_{x,filtered}'};
p(5).legend = {'v_{y,raw}', 'v_{y,filtered}'};
p(6).legend = {'v_{z,raw}', 'v_{z,filtered}'};

p(7).legend = {'tracker', 'optical flow', sprintf('quality > %3i%%',ld.of.qth*100)};
p(8).legend = {'tracker', 'optical flow', sprintf('quality > %3i%%',ld.of.qth*100)};
p(9).legend = {'tracker', 'optical flow', sprintf('quality > %3i%%',ld.of.qth*100)};

% linkaxes([p(1:6).h],'x')
% linkaxes([p(4:5).h],'y')

for k=1:9

    subplot(p(k).h)
    plot(p(k).t{1}, p(k).d{1})
    
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    title(p(k).title)
    
end


k = 2;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')
plot(p(k).t{3}, p(k).d{3}, 'g.')

legend(p(k).legend)


k = 4;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')

legend(p(k).legend)


k = 5;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')

legend(p(k).legend)


k = 6;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')

legend(p(k).legend)


k = 7;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')
plot(p(k).t{3}, p(k).d{3}, 'g.')

legend(p(k).legend)


k = 9;
subplot(p(k).h)
hold on
plot(p(k).t{2}, p(k).d{2}, 'r')
plot(p(k).t{3}, p(k).d{3}, 'g.')

legend(p(k).legend)


% adjust axes
% allYLim = get([p(1:2).h], {'YLim'});
% allYLim = cat(2, allYLim{:});
% set([p(1:2).h], 'YLim', [min(allYLim), max(allYLim)]);
% set([p(1:2).h], 'YTick', linspace(min(allYLim),max(allYLim),11));


h = gcf;
set(h,'Name','Optical Flow: Compare linear velocities','NumberTitle','off');

end
