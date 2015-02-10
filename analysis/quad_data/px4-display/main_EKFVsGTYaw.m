clear all


load('PX4DataNew.mat','-mat');



n           = data.n;
t           = data.t;

int         = data.int;

t           = data.t(int) - data.t(int(1));
GT.yaw      = data.GT.yaw(int);
yaw         = data.EKF.yaw(int);

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = 'yaw angle $\psi$';
fig.p(k).x          = t;
fig.p(k).y{1}       = GT.yaw;
fig.p(k).y{2}       = yaw;
fig.p(k).legend.str = {'GT','EKF-drone'};
fig.p(k).ylim       = [-0.5,1];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$\psi$ is yaw angle in rad';

k=1;
plot(fig.p(k).x,fig.p(k).y{1},'b');
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter', 'Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str, 'Interpreter', 'Latex');
ylim(fig.p(k).ylim);
plot(fig.p(k).x,fig.p(k).y{2},'r');
fig.p(k).title.h    = title(fig.p(k).title.str);
fig.p(k).legend.h   = legend(fig.p(k).legend.str);
set(fig.p(k).title.h,'FontSize',12, 'Interpreter', 'Latex');
