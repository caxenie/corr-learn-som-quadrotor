clear all

load('PX4DataNew.mat','-mat');

n           = data.n;
t           = data.t;

int         = data.int;
% int         = 1:n;

t           = data.t(int) - data.t(int(1));
GT.a        = data.GT.acc(2,int);
a           = data.EKF.alin(2,int);

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = 'acceleration in y direction $a_\mathrm{y}$';
fig.p(k).x          = t;
fig.p(k).y{1}       = GT.a;
fig.p(k).y{2}       = a;
fig.p(k).legend.str = {'GT','EKF RPY and $\mathbf{a}_\mathrm{net}$'};
fig.p(k).ylim       = [-1.5,1.5];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$a_\mathrm{y}$ is acceleration in $\frac{\mathrm{m}}{\mathrm{s}^2}$';

k=1;
plot(fig.p(k).x,fig.p(k).y{1},'b');
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter','Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str,'Interpreter','Latex');
ylim(fig.p(k).ylim);
plot(fig.p(k).x,fig.p(k).y{2},'r');
fig.p(k).title.h    = title(fig.p(k).title.str, 'Interpreter','Latex');
fig.p(k).legend.h   = legend(fig.p(k).legend.str, 'Interpreter','Latex');
set(fig.p(k).title.h,'FontSize',12);
set(fig.p(k).title.h,'Interpreter','Latex');

set(fig.p(k).legend.h,'units','pixels');


