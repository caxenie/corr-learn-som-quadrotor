
function [] = plot_attitude(att, tsmin)


ts = att.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end

r = 2;
c = 3;


p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
p(3).h = subplot(r,c,3);

p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);



p(1).d = att.roll;
p(2).d = att.pitch;
p(3).d = att.yaw;

p(4).d = att.rollspeed;
p(5).d = att.pitchspeed;
p(6).d = att.yawspeed;



p(1).title = 'roll (rad)';
p(2).title = 'pitch (rad)';
p(3).title = 'yaw (rad)';

p(4).title = 'roll-rate (rad/s)';
p(5).title = 'pitch-rate (rad/s)';
p(6).title = 'yaw-rate (rad/s)';



p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';

p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';

% p(1).ylim = [-1,1] * pi;
% p(2).ylim = [-1,1] * 0.5 * pi;
% p(3).ylim = [-1,1] * 0.5 * pi;


% p(4).ylim = [-1,1] * 0.5 * pi;
% p(5).ylim = [-1,1] * 0.5 * pi;
% p(6).ylim = [-1,1] * 0.5 * pi;

for k=1:6

    subplot(p(k).h)
    plot(t, p(k).d)
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end

% adjust axes
allYLim = get([p(1:2).h], {'YLim'});
allYLim = cat(2, allYLim{:});
set([p(1:2).h], 'YLim', [min(allYLim), max(allYLim)]);


allYLim = get([p(4:6).h], {'YLim'});
allYLim = cat(2, allYLim{:});
set([p(4:6).h], 'YLim', [min(allYLim), max(allYLim)]);


h = gcf;
set(h,'Name','Attitude (EKF)','NumberTitle','off');

end
