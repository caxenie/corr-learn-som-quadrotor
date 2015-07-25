function [rpyrts] = read_mavlink_msg_roll_pitch_yaw_rates_thrust_setpoint(filename)

data = dlmread(filename);

%{

    uint32_t time_boot_ms; ///< Timestamp in milliseconds since system boot
    float roll_rate; ///< Desired roll rate in radians per second
    float pitch_rate; ///< Desired pitch rate in radians per second
    float yaw_rate; ///< Desired yaw rate in radians per second
    float thrust; ///< Collective thrust, normalized to 0 .. 1

%}

%{
    
    utils_us_since_epoch(),
    rpyrts.time_boot_ms,
    rpyrts.roll_rate,
    rpyrts.pitch_rate,
    rpyrts.yaw_rate,
    rpyrts.thrust

%}


rpyrts.ts               = data(:,1);
rpyrts.time_boot_ms     = data(:,2);
rpyrts.roll_rate        = data(:,3);
rpyrts.pitch_rate       = data(:,4);
rpyrts.yaw_rate         = data(:,5);
rpyrts.thrust           = data(:,6);

rpyrts.n = length(rpyrts.ts);

end