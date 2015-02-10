clear all


load('PX4DataNew.mat','-mat');



n           = data.n;
t           = data.t;

int         = data.int;

t           = data.t(int) - data.t(int(1));
a           = data.GT.arot(1,int);

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = 'rotated gravitational acceleration in x direction $\left[\mathbf{a}_\mathrm{rot}\right]_1$';
fig.p(k).x          = t;
fig.p(k).y{1}       = a;
fig.p(k).legend.str = {'GT RPY and $\mathbf{g}$'};
fig.p(k).ylim       = [-2,2];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$\left[\mathbf{a}_\mathrm{rot}\right]_1$ is acceleration in $\frac{\mathrm{m}}{\mathrm{s}^2}$';

k=1;
plot(fig.p(k).x,fig.p(k).y{1},'b');
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter', 'Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str, 'Interpreter', 'Latex');
ylim(fig.p(k).ylim);
fig.p(k).title.h    = title(fig.p(k).title.str, 'Interpreter', 'Latex');
fig.p(k).legend.h   = legend(fig.p(k).legend.str, 'Interpreter', 'Latex');
set(fig.p(k).title.h,'FontSize',12, 'Interpreter', 'Latex');
set(fig.p(k).legend.h,'units','pixels');

