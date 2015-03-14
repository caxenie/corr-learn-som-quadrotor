
function [] = plot_sys_status(ss, tsmin)


ts = ss.ts;

if nargin == 2
    t = (ts - tsmin)*1e-6;
else
    t = (ts - ts(1))*1e-6;
end


r = 1;
c = 2;

p(1).h = subplot(r,c,1);
p(2).h = subplot(r,c,2);
% p(3).h = subplot(r,c,3);
% p(4).h = subplot(r,c,4);

p(1).d = ss.load / 10;               % system cpu load
p(2).d = ss.voltage_battery / 1000;  
% p(3).d = ss.current_battery * 10; 
% p(4).d = ss.battery_remaining / 100; 

p(1).title = 'cpu-load (%)';
p(2).title = 'battery voltage (V)';
% p(3).title = 'battery current (mA)';
% p(4).title = 'battery remaining (%)';

p(1).ylim = [0, 1] * 100;
p(2).ylim = [0, 13];
% p(3).ylim = [0, 10] * 1000;
% p(4).ylim = [0, 1] * 100;


for k=1:2

    subplot(p(k).h)
    plot(t, p(k).d)
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end

h = gcf;
set(h,'Name','System status','NumberTitle','off');

end