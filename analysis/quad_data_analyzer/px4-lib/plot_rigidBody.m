
function [] = plot_rigidBody(rb, tsmin)


ts = rb.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end


r = 3;
c = 3;


% for k=1:(r*c)
%     p(k).h = subplot(r,c,k);   
% end


p(1).h = subplot(r,c,1);  
p(2).h = subplot(r,c,2);  
p(3).h = subplot(r,c,3);  

p(4).h = subplot(r,c,4);
p(5).h = subplot(r,c,5);  
p(6).h = subplot(r,c,6);  

p(7).h = subplot(r,c,7:9);  


p(1).d = rb.x;
p(2).d = rb.y;
p(3).d = rb.z;

p(4).d = rb.roll;
p(5).d = rb.pitch;
p(6).d = rb.yaw;

p(7).d = rb.mean_error;



p(1).title = 'x [m]';
p(2).title = 'y [m]';
p(3).title = 'z [m]';

p(4).title = 'roll [rad]';
p(5).title = 'pitch [rad]';
p(6).title = 'yaw [rad]';

p(7).title = 'error';


p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';


p(4).ylim = 'auto';
p(5).ylim = 'auto';
p(6).ylim = 'auto';

% p(4).ylim =[-1,1] * 0.5 * pi;
% p(5).ylim =[-1,1] * 0.5 * pi;
% p(6).ylim =[-1,1] * 0.5 * pi;

p(7).ylim = 'auto';

% for k=1:(r*c)
%     p(k).ylim = 'auto';
% end


% linkaxes([p(1:2).h],'y')

linkaxes([p(1:6).h],'x')
linkaxes([p(4:5).h],'y')

for k=1:7

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
% set([p(1:2).h], 'YTick', linspace(min(allYLim),max(allYLim),11));

h = gcf;
set(h,'Name','Tracker data','NumberTitle','off');

end
