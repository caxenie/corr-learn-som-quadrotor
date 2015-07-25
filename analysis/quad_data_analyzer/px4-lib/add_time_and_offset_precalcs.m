function [ld_out] = add_time_and_offset_precalcs(ld)


%**************************************************************************
%% find first time stamp
%**************************************************************************

k=1;
tsmin = zeros(1,7);

if(isfield(ld,'sor'))
    tsmin(k) = ld.sor.ts(1);
    k = k + 1;
end


if(isfield(ld,'mc'))
    tsmin(k) = ld.mc.ts(1);
    k = k + 1;
end

if(isfield(ld,'ss'))
    tsmin(k) = ld.ss.ts(1);
    k = k + 1;
end


if(isfield(ld,'imu'))
    tsmin(k) = ld.imu.ts(1);
    k = k + 1;
end


if(isfield(ld,'att'))
    tsmin(k) = ld.att.ts(1);
    k = k + 1;
end


if(isfield(ld,'of'))
    tsmin(k) = ld.of.ts(1);
    k = k + 1;
end


if(isfield(ld,'rb'))
    tsmin(k) = ld.rb.ts(1);
    k = k + 1;
end

k = k -1;
ld.tsmin = min(tsmin(1:k));



%**************************************************************************
%% convert timestamps to timelines for sampled data
%**************************************************************************

if(isfield(ld,'sor'))
    ld.sor.t                = calc_t_us(ld.sor.ts, ld.tsmin);
    ld.sor.dt               = calc_dt(ld.sor.t);
    ld.sor.dt_max           = max(ld.sor.dt);
    ld.sor.dt_min           = min(ld.sor.dt);
    ld.sor.dt_mean          = mean(ld.sor.dt);
    ld.sor.freq_mean        = 1 / ld.sor.dt_mean;
    ld.sor.hrt.t_raw        = calc_t_ms(ld.sor.time_usec, ld.sor.time_usec(1));
    ld.sor.hrt.t            = sync_t(ld.sor.hrt.t_raw, ld.sor.t(1));
    ld.sor.hrt.dt           = calc_dt(ld.sor.hrt.t);
    ld.sor.hrt.dt_mean      = mean(ld.sor.hrt.dt);
    ld.sor.hrt.freq_mean    =  1 / ld.sor.hrt.dt_mean;
    ld.sor.hrt.dt_mean      = mean(ld.sor.hrt.dt);
end


if(isfield(ld,'mc'))
    ld.mc.t                 = calc_t_us(ld.mc.ts,  ld.tsmin);
    ld.mc.dt                = calc_dt(ld.mc.t);
    ld.mc.dt_max            = max(ld.mc.dt);
    ld.mc.dt_min            = min(ld.mc.dt);
    ld.mc.dt_mean           = mean(ld.mc.dt);
    ld.mc.freq_mean         = 1 / ld.mc.dt_mean;
end


if(isfield(ld,'ss'))
    ld.ss.t                 = calc_t_us(ld.ss.ts,  ld.tsmin);
    ld.ss.dt                = calc_dt(ld.ss.t);
    ld.ss.dt_max            = max(ld.ss.dt);
    ld.ss.dt_min            = min(ld.ss.dt);
    ld.ss.dt_mean           = mean(ld.ss.dt);
    ld.ss.freq_mean         = 1 / ld.ss.dt_mean;
end



if(isfield(ld,'imu'))
    ld.imu.t                = calc_t_us(ld.imu.ts, ld.tsmin);
    ld.imu.dt               = calc_dt(ld.imu.t);
    ld.imu.dt_max           = max(ld.imu.dt);
    ld.imu.dt_min           = min(ld.imu.dt);
    ld.imu.dt_mean          = mean(ld.imu.dt);
    ld.imu.freq_mean        = 1 / ld.imu.dt_mean;
    ld.imu.hrt.t_raw        = calc_t_us(ld.imu.time_usec, ld.imu.time_usec(1));
    ld.imu.hrt.t            = sync_t(ld.imu.hrt.t_raw, ld.imu.t(1));
    ld.imu.hrt.dt           = calc_dt(ld.imu.hrt.t);
    ld.imu.hrt.dt_mean      = mean(ld.imu.hrt.dt);
    ld.imu.hrt.freq_mean    =  1 / ld.imu.hrt.dt_mean;
end



if(isfield(ld,'att'))
    ld.att.t                = calc_t_us(ld.att.ts, ld.tsmin);
    ld.att.dt               = calc_dt(ld.att.t);
    ld.att.dt_max           = max(ld.att.dt);
    ld.att.dt_min           = min(ld.att.dt);
    ld.att.dt_mean          = mean(ld.att.dt);
    ld.att.freq_mean        = 1 / ld.att.dt_mean;
    ld.att.hrt.t_raw        = calc_t_ms(ld.att.time_boot_ms, ld.att.time_boot_ms(1));
    ld.att.hrt.t            = sync_t(ld.att.hrt.t_raw, ld.att.t(1));
    ld.att.hrt.dt           = calc_dt(ld.att.hrt.t);
    ld.att.hrt.dt_mean      = mean(ld.att.hrt.dt);
    ld.att.hrt.freq_mean    =  1 / ld.att.hrt.dt_mean;
end


if(isfield(ld,'of'))
    ld.of.t                 = calc_t_us(ld.of.ts,  ld.tsmin);
    ld.of.dt                = calc_dt(ld.of.t);
    ld.of.dt_max            = max(ld.of.dt);
    ld.of.dt_min            = min(ld.of.dt);
    ld.of.dt_mean           = mean(ld.of.dt);
    ld.of.freq_mean         = 1 / ld.of.dt_mean;
    ld.of.hrt.t_raw         = calc_t_us(ld.of.time_usec, ld.of.time_usec(1));
    ld.of.hrt.t             = sync_t(ld.of.hrt.t_raw, ld.of.t(1));
    ld.of.hrt.dt            = calc_dt(ld.of.hrt.t);
    ld.of.hrt.dt_mean       = mean(ld.of.hrt.dt);
    ld.of.hrt.freq_mean     =  1 / ld.of.hrt.dt_mean;
end



if(isfield(ld,'rb'))
    ld.rb.t             = calc_t_us(ld.rb.ts,  ld.tsmin);
    ld.rb.dt            = calc_dt(ld.rb.t);
    ld.rb.dt_max        = max(ld.rb.dt);
    ld.rb.dt_mean       = mean(ld.rb.dt);
    ld.rb.dt_min        = min(ld.rb.dt);
    ld.rb.freq_mean     = 1 / ld.rb.dt_mean;
    ld.rb.hrt.t_raw     = calc_t_s(ld.rb.tracker_ts, ld.rb.tracker_ts(1));
    ld.rb.hrt.t         = sync_t(ld.rb.hrt.t_raw, ld.rb.t(1));
    ld.rb.hrt.dt        = calc_dt(ld.rb.hrt.t);
    ld.rb.hrt.dt_mean   = mean(ld.rb.hrt.dt);
    ld.rb.hrt.freq_mean =  1 / ld.rb.hrt.dt_mean;
end

% calc yaw offset (attitude and rigid body)
if(isfield(ld,'att') && isfield(ld,'rb'))
    ld.yaw_off = mean(ld.att.yaw(1:100)+ld.rb.yaw(1:100));
else
    if(isfield(ld,'att'))
        ld.yaw_off = mean(ld.att.yaw(1:100));
    else
        ld.yaw_off = 0;
    end
end


if(isfield(ld,'att'))
    ld.att.roll_off = mean(ld.att.roll(1:100));
    ld.att.pitch_off = mean(ld.att.pitch(1:100));
end


if(isfield(ld,'imu'))
    
    % estimate B vector of earth magnetic field
    bx = mean(ld.imu.xmag(1:100));
    by = mean(ld.imu.ymag(1:100));
    bz = mean(ld.imu.zmag(1:100));
    
    ld.b = [bx;by;bz];
    
    
    % estimate graviational acceleration
    ld.g = -mean(ld.imu.zacc(1:100));
end

ld_out = ld;

end


function [t] = calc_t_us(ts, tsmin)
t = (ts - tsmin)*1e-6;
end

function [t] = calc_t_ms(ts, tsmin)
t = (ts - tsmin)*1e-3;
end

function [t] = calc_t_s(ts, tsmin)
t = (ts - tsmin);
end

function [t_new] = sync_t(t, t_start)

diff = t(1) - t_start;
t_new = t - diff;
end

function [dt] = calc_dt(t)
dt = t - [0; t(1:(end-1))];  % t1 - 0, t2 - t1, ...
end





