function [] = plot_roll_spectrogram(ld)

r = 3;
c = 3;

p(1).h = subplot(r,c,1:3);
p(2).h = subplot(r,c,4);
p(3).h = subplot(r,c,5);
p(4).h = subplot(r,c,6);
p(5).h = subplot(r,c,7:9);


k=1;
p(k).t{1} = ld.imu.hrt.t;
p(k).t{2} = ld.imu.hrt.t;
p(k).t{3} = ld.att.hrt.t;

p(k).d{1} = ld.acc.raw.uf.roll;
p(k).d{2} = ld.acc.raw.roll;
p(k).d{3} = ld.att.roll-ld.att.roll_off;

p(k).title = 'roll';
p(k).legend = {'unfiltered','filtered','EKF'};


k=2;
p(k).title = 'ACC: roll raw, unfiltered';

k=3;
p(k).title = 'ACC: roll raw, filtered';

k=4;
p(k).title = 'EKF roll';


k=5;
p(k).t{1} = ld.acc.SG.roll.T;
p(k).t{2} = ld.att.SG.roll.T;
p(k).t{3} = ld.att.hrt.t;

p(k).d{1} = ld.acc.SG.roll.H(3,:);
p(k).d{2} = ld.att.SG.roll.H(3,:);
p(k).d{3} = abs(ld.att.roll);

p(k).title = 'first freq component';
p(k).legend = {'acc','att','abs(roll, EKF)'};



linkaxes([p(2:4).h],'y')


k=1;
subplot(p(k).h);
plot(p(k).t{1}, p(k).d{1})

hold on
grid on

plot(p(k).t{2}, p(k).d{2},'c')
plot(p(k).t{3}, p(k).d{3},'r')
% plot(p(k).t{4}, p(k).d{4},'g')

title(p(k).title);
legend(p(k).legend);



k=2;
subplot(p(k).h);

W = ld.acc.SG.roll.W;

x = ld.acc.raw.uf.roll;
n = ld.imu.n;
Fs = ld.imu.hrt.freq_mean;
spectrogram(x,W,[],n,Fs,'yaxis')

title(p(k).title);


k=3;
subplot(p(k).h);

W = ld.acc.SG.roll.W;

x = ld.acc.raw.roll;
n = ld.imu.n;
Fs = ld.imu.hrt.freq_mean;
spectrogram(x,W,[],n,Fs,'yaxis')

title(p(k).title);



k=4;
subplot(p(k).h);

W = ld.att.SG.roll.W;
x = ld.att.roll-ld.att.roll_off;
n = ld.att.n;
Fs = ld.att.hrt.freq_mean;
spectrogram(x,W,[],n,Fs,'yaxis')

title(p(k).title);


k=5;
subplot(p(k).h);
plot(p(k).t{1}, p(k).d{1})

hold on
grid on

plot(p(k).t{2}, p(k).d{2},'c')
plot(p(k).t{3}, p(k).d{3},'r')

title(p(k).title);
legend(p(k).legend);


h = gcf;
set(h,'Name','Roll spectrogram','NumberTitle','off');

end


