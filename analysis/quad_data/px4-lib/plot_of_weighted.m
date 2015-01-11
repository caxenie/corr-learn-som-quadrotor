
function [] = plot_of_weighted(ld)

of = ld.of;

t = of.t;


r = 3;
c = 2;


p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);

p(3).h = subplot(r,c,3);
p(4).h = subplot(r,c,4);

p(5).h = subplot(r,c,5:6);


p(1).d{1} = of.flow_comp_m_x;
p(2).d{1} = of.flow_comp_m_y;

p(3).d{1} = of.vx_th;
p(4).d{1} = of.vy_th;

p(5).d{1} = of.h_th;


p(3).d{2} = of.vx_f;
p(4).d{2} = of.vy_f;

p(3).d{3} = of.vx_ra;
p(4).d{3} = of.vy_ra;


p(1).title = 'flow-x [m] (with angular compensation)';
p(2).title = 'flow-y [m] (with angular compensation)';

p(3).title = 'flow-x [m] (90% quality threshold)';
p(4).title = 'flow-y [m] (90% quality threshold)';

p(5).title = 'height [m] (90% quality threshold)';


p(3).legend = {'v_{x,th}', 'v_{x,f}', 'v_{x,ra}'};
p(4).legend = {'v_{y,th}', 'v_{y,f}', 'v_{y,ra}'};


p(1).ylim = 'auto';
p(2).ylim = 'auto';

p(3).ylim = 'auto';
p(4).ylim = 'auto';

p(5).ylim = 'auto';


linkaxes([p(1:2).h],'y')
linkaxes([p(3:4).h],'y')

for k=1:5

    subplot(p(k).h)
    plot(t, p(k).d{1})
    
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end

k=3;
subplot(p(k).h)
hold on
plot(t, p(k).d{2}, 'r')
plot(t, p(k).d{3}, 'g')

legend(p(k).legend)


k=4;
subplot(p(k).h)
hold on
plot(t, p(k).d{2}, 'r')
plot(t, p(k).d{3}, 'g')

legend(p(k).legend)

% adjust axes
% allYLim = get([p(1:2).h], {'YLim'});
% allYLim = cat(2, allYLim{:});
% set([p(1:2).h], 'YLim', [min(allYLim), max(allYLim)]);
% set([p(1:2).h], 'YTick', linspace(min(allYLim),max(allYLim),11));

h = gcf;
set(h,'Name','Optical Flow: Weighted data','NumberTitle','off');

end
