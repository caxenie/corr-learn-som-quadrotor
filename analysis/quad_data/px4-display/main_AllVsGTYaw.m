clear all

load('PX4DataNew.mat','-mat');



n           = data.n;
t           = data.t;

int         = data.int;

t           = data.t(int) - data.t(int(1));
GT.yaw     	= data.GT.yaw(int);
EKF.yaw     = data.EKF.yaw(int);
GYRO.yaw    = data.GYRO.yaw(int);
MAG.gt.yaw  = data.MAG.gt.yaw(int);
MAG.ekf.yaw = data.MAG.ekf.yaw(int);

% roll KF vs EKF
fig.h               = figure;

% pos = get(fig.h,'Position');
set(fig.h, 'Position', [500 400 800 300]); % x,y,width,height

cmap                = colormap(lines(5));

k=1;
fig.p(k).title.str  = 'yaw angle';
fig.p(k).x{1}       = t;
fig.p(k).x{2}       = t;
fig.p(k).x{3}       = t;
fig.p(k).x{4}       = t;
fig.p(k).x{5}       = t;
fig.p(k).y{1}       = GT.yaw;
fig.p(k).y{2}       = EKF.yaw;
fig.p(k).y{3}       = GYRO.yaw;
fig.p(k).y{4}       = MAG.gt.yaw;
fig.p(k).y{5}       = MAG.ekf.yaw;
fig.p(k).legend.str = {'GT','EKF-QR','gyro.','mag. and RP of GT','mag. and RP of EKF'};
fig.p(k).ylim       = [-0.5,1.5];
fig.p(k).xlabel.str = '$t$ in sec.';
fig.p(k).ylabel.str = '$\psi$ is yaw angle in rad';
fig.p(k).prop{1}    = {'LineStyle','Color'};
fig.p(k).prop{2}    = {'LineStyle','Color'};
fig.p(k).prop{3}    = {'LineStyle','Color'};
fig.p(k).prop{4}    = {'LineStyle','Color'};
fig.p(k).prop{5}    = {'LineStyle','Color'};
fig.p(k).val{1}     = {'-',     cmap(1,:)};
fig.p(k).val{2}     = {'-',     cmap(2,:)};
fig.p(k).val{3}     = {'-',     cmap(3,:)};
fig.p(k).val{4}     = {'-',     cmap(4,:)};
fig.p(k).val{5}     = {'--',     cmap(5,:)};


k=1;
fig.p(k).plot.h(1) = plot(fig.p(k).x{1},fig.p(k).y{1});
grid on
hold on
fig.p(k).xlabel.h = xlabel(fig.p(k).xlabel.str, 'Interpreter','Latex');
fig.p(k).xlabel.h = ylabel(fig.p(k).ylabel.str,'Interpreter','Latex');
ylim(fig.p(k).ylim);

fig.p(k).plot.h(2) = plot(fig.p(k).x{2},fig.p(k).y{2});
fig.p(k).plot.h(3) = plot(fig.p(k).x{3},fig.p(k).y{3});
fig.p(k).plot.h(4) = plot(fig.p(k).x{4},fig.p(k).y{4});
fig.p(k).plot.h(5) = plot(fig.p(k).x{5},fig.p(k).y{5});

fig.p(k).title.h    = title(fig.p(k).title.str,'Interpreter','LaTex');
fig.p(k).legend.h   = legend(fig.p(k).legend.str, 'Interpreter','Latex');

set(fig.p(k).title.h,'FontSize',12);

set(fig.p(k).legend.h,'units','pixels');


set(fig.p(k).plot.h(1),fig.p(k).prop{1},fig.p(k).val{1});
set(fig.p(k).plot.h(2),fig.p(k).prop{2},fig.p(k).val{2});
set(fig.p(k).plot.h(3),fig.p(k).prop{3},fig.p(k).val{3});
set(fig.p(k).plot.h(4),fig.p(k).prop{4},fig.p(k).val{4});
set(fig.p(k).plot.h(5),fig.p(k).prop{5},fig.p(k).val{5});
set(fig.p(k).title.h,'Interpreter','Latex');
