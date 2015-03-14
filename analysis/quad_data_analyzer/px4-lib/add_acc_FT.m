function [ld_out] = add_acc_FT(ld)

if(isfield(ld,'imu') == 0)
    ld_out = ld;
    return;
end

dt = ld.imu.hrt.dt_mean;

ax = ld.imu.xacc;
ay = ld.imu.yacc;
az = ld.imu.zacc;


[f,H] = f_trafo(ax, dt);
ld.acc.FT.ax.f = f;
ld.acc.FT.ax.H = H;

[f,H] = f_trafo(ay, dt);
ld.acc.FT.ay.f = f;
ld.acc.FT.ay.H = H;

[f,H] = f_trafo(az, dt);
ld.acc.FT.az.f = f;
ld.acc.FT.az.H = H;


ax_f = ld.acc.ax_f;
ay_f = ld.acc.ay_f;
az_f = ld.acc.az_f;


[f,H] = f_trafo(ax_f, dt);
ld.acc.FT.ax_f.f = f;
ld.acc.FT.ax_f.H = H;

[f,H] = f_trafo(ay_f, dt);
ld.acc.FT.ay_f.f = f;
ld.acc.FT.ay_f.H = H;

[f,H] = f_trafo(az_f, dt);
ld.acc.FT.az_f.f = f;
ld.acc.FT.az_f.H = H;


ld_out = ld;


end