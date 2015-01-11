
function [] = plot_optical_flow(of, tsmin)

ts = of.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end


r = 3;
c = 2;


p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);

p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);

p(5).h = subplot(r,c,5);
p(6).h = subplot(r,c,6);



p(1).d = of.flow_comp_m_x;
p(2).d = of.flow_comp_m_y;

p(3).d = of.flow_x;
p(4).d = of.flow_y;


p(5).d = of.ground_distance;
p(6).d = of.quality / 255 * 100;



p(1).title = 'flow-x [m/s] (with angular compensation)';
p(2).title = 'flow-y [m/s] (with angular compensation)';

p(3).title = 'flow-x [px/s]';
p(4).title = 'flow-y [px/s]';

p(5).title = 'height [m]';
p(6).title = 'quality [%]';



p(1).ylim = 'auto';
p(2).ylim = 'auto';

p(3).ylim = 'auto';
p(4).ylim = 'auto';

p(5).ylim = 'auto';
p(6).ylim = 'auto';


% linkaxes([p(1:2).h],'y')

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
% set([p(1:2).h], 'YTick', linspace(min(allYLim),max(allYLim),11));

h = gcf;
set(h,'Name','Optical flow sensor','NumberTitle','off');


end
