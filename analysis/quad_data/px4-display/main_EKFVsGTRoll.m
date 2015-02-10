clear all

load('PX4DataNew.mat','-mat');



n           = data.n;
t           = data.t;

int         = data.int;

t           = data.t(int) - data.t(int(1));
GT.roll     = data.GT.roll(int);
roll        = data.EKF.roll(int);

err         = radToDeg(calcRMSErr(GT.roll,roll));

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = ['roll angle'];
fig.p(k).x          = t;
fig.p(k).y{1}       = GT.roll;
fig.p(k).y{2}       = roll;
fig.p(k).legend.str = {'GT','EKF-QR'};
fig.p(k).ylim       = [-0.25,0.25];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$\phi$ is roll angle in rad';

k=1;
plot(fig.p(k).x,fig.p(k).y{1},'b');
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter', 'Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str,  'Interpreter', 'Latex');
ylim(fig.p(k).ylim);
plot(fig.p(k).x,fig.p(k).y{2},'r');
fig.p(k).title.h    = title(fig.p(k).title.str);
fig.p(k).legend.h   = legend(fig.p(k).legend.str);
set(fig.p(k).title.h,'FontSize',12, 'Interpreter', 'Latex');
