
clear all


load('PX4DataNew.mat','-mat');
% load('PX4DataNew_tf7.mat','-mat');


n           = data.n;
t           = data.t;

int         = data.int;
% int         = 1:n;

t           = data.t(int) - data.t(int(1));
mag         = data.mag(3,int);
EKF.b       = data.EKF.mag(3,int);

% roll KF vs EKF
fig.h           = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

k=1;
fig.p(k).title.str  = 'magnetic field magnitude in z direction $b_\mathrm{z}$';
fig.p(k).x          = t;
fig.p(k).y{1}       = mag;
fig.p(k).y{2}       = EKF.b;
fig.p(k).legend.str = {'mag.','EKF RPY and $\mathbf{b}_\mathrm{0}$'};
fig.p(k).ylim       = [0.2,0.6];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$b_\mathrm{z}$ is magnetic field magnitude in Gauss';

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

