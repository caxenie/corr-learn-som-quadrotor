function [rpyts] = read_mavlink_msg_roll_pitch_yaw_thrust_setpoint(filename)

data = dlmread(filename);

%{

    uint32_t time_boot_ms; ///< Timestamp in milliseconds since system boot
    float roll; ///< Desired roll angle in radians
    float pitch; ///< Desired pitch angle in radians
    float yaw; ///< Desired yaw angle in radians
    float thrust; ///< Collective thrust, normalized to 0 .. 1

%}


%{

    utils_us_since_epoch(),
    rpyts.time_boot_ms,
    rpyts.roll,
    rpyts.pitch,
    rpyts.yaw,
    rpyts.thrust

%}


rpyts.ts                = data(:,1);
rpyts.time_boot_ms      = data(:,2);
rpyts.roll              = data(:,3);
rpyts.pitch             = data(:,4);
rpyts.yaw               = data(:,5);
rpyts.thrust            = data(:,6);

rpyts.n = length(rpyts.ts);


end