
function [] = plot_servo_output_raw(sor, tsmin)


ts = sor.ts;

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


k=1;
p(k).t{1} = t;
p(k).d{1} = sor.servo1_raw;

k=2;
p(k).t{1} = t;
p(k).d{1} = sor.servo2_raw;

k=3;
p(k).t{1} = t;
p(k).d{1} = sor.servo3_raw;

k=4;
p(k).t{1} = t;
p(k).d{1} = sor.servo4_raw;




p(1).title = 'motor 1 (fl)';
p(2).title = 'motor 2 (fr)';
p(3).title = 'motor 3 (br)';
p(4).title = 'motor 4 (bl)';



p(1).ylim = 'auto';
p(2).ylim = 'auto';
p(3).ylim = 'auto';
p(4).ylim = 'auto';


linkaxes([p(1:4).h],'y')

for k=1:4

    subplot(p(k).h)
    plot(p(k).t{1}, p(k).d{1})
    
    title(p(k).title)
    grid on
    ylim(p(k).ylim)
    xlabel('t in secs')
    
end


h = gcf;
set(h,'Name','Motor outputs','NumberTitle','off');


end