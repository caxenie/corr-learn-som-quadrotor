function [vh] = read_mavlink_msg_vfr_hud(filename)

data = dlmread(filename);

%{

    float airspeed; ///< Current airspeed in m/s
    float groundspeed; ///< Current ground speed in m/s
    float alt; ///< Current altitude (MSL), in meters
    float climb; ///< Current climb rate in meters/second
    int16_t heading; ///< Current heading in degrees, in compass units (0..360, 0=north)
    uint16_t throttle; ///< Current throttle setting in integer percent, 0 to 100

%}

%{

    utils_us_since_epoch(),
    vh.airspeed,
    vh.groundspeed,
    vh.alt,
    vh.climb,
    vh.heading,
    vh.throttle

%}


vh.ts               = data(:,1);
vh.airspeed         = data(:,2);
vh.groundspeed      = data(:,3);
vh.alt              = data(:,4);
vh.climb            = data(:,5);
vh.heading          = data(:,6);
vh.throttle         = data(:,7);

vh.n = length(vh.ts);

end