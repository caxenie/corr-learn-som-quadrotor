
function [] = plot_manual_control(mc)


ts = mc.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end


r = 2;
c = 2;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);

p(1).d = mc.x;  % roll
p(2).d = mc.y;  % pitch  
p(3).d = mc.z;  % yaw
p(4).d = mc.r;  % thrust


p(1).title = 'roll';
p(2).title = 'pitch';
p(3).title = 'yaw';
p(4).title = 'thrust';


% p(1).ylim = [-1, 1] * 1000;
% p(2).ylim = [-1, 1] * 1000;
% p(3).ylim = [-1, 1] * 2000;
% p(4).ylim = [0, 1] * 1000;


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';


for k=1:4

    subplot(p(k).h)
    plot(t, p(k).d)
    
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end

h = gcf;
set(h,'Name','Manual control','NumberTitle','off');

end