function [hb] = read_mavlink_msg_heartbeat(filename)

data = dlmread(filename);

%{

    uint32_t custom_mode; ///< A bitfield for use for autopilot-specific flags.
    uint8_t type; ///< Type of the MAV (quadrotor, helicopter, etc., up to 15 types, defined in MAV_TYPE ENUM)
    uint8_t autopilot; ///< Autopilot type / class. defined in MAV_AUTOPILOT ENUM
    uint8_t base_mode; ///< System mode bitfield, see MAV_MODE_FLAGS ENUM in mavlink/include/mavlink_types.h
    uint8_t system_status; ///< System status flag, see MAV_STATE ENUM
    uint8_t mavlink_version; ///< MAVLink version, not writable by user, gets added by protocol because of magic data type: uint8_t_mavlink_version

%}


%{
    utils_us_since_epoch(),
    hb.custom_mode,
    hb.type,
    hb.autopilot,
    hb.base_mode,
    hb.system_status,
    hb.mavlink_version
%}


hb.ts               = data(:,1);
hb.custom_mode      = data(:,2);
hb.type             = data(:,3);
hb.autopilot        = data(:,4);
hb.base_mode        = data(:,5);
hb.system_status    = data(:,6);
hb.mavlink_version  = data(:,7);

hb.n = length(hb.ts);

end