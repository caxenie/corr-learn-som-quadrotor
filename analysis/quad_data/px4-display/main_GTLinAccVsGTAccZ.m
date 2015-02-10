clear all

load('PX4DataNew.mat','-mat');
% load('PX4DataNew_tf7.mat','-mat');


n           = data.n;
t           = data.t;

int         = data.int;
% int         = 1:n;

t           = data.t(int) - data.t(int(1));
GT.a        = data.GT.acc(3,int);
a           = data.GT.alin(3,int);

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = 'acceleration in z direction $\left[{}_0\mathbf{a}_\mathrm{lin}\right]_3$';
fig.p(k).x          = t;
fig.p(k).y{1}       = GT.a;
fig.p(k).y{2}       = a;
fig.p(k).legend.str = {'GT','GT RPY and $\mathbf{a}_\mathrm{net}$'};
fig.p(k).ylim       = [-10,10];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$\left[{}_0\mathbf{a}_\mathrm{lin}\right]_3$ is acceleration in $\frac{\mathrm{m}}{\mathrm{s}^2}$';

k=1;
plot(fig.p(k).x,fig.p(k).y{1},'b');
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter', 'Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str, 'Interpreter', 'Latex');
ylim(fig.p(k).ylim);
plot(fig.p(k).x,fig.p(k).y{2},'r');
fig.p(k).title.h    = title(fig.p(k).title.str, 'Interpreter', 'Latex');
fig.p(k).legend.h   = legend(fig.p(k).legend.str, 'Interpreter', 'Latex');
set(fig.p(k).title.h,'FontSize',12, 'Interpreter', 'Latex');

set(fig.p(k).legend.h,'units','pixels');
