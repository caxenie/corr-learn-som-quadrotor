function [of] = read_mavlink_msg_optical_flow(filename)

if(exist(filename,'file') == 0)
    of = [];
    return;
end

data = dlmread(filename);

%{

    uint64_t time_usec; ///< Timestamp (UNIX)
    float flow_comp_m_x; ///< Flow in meters in x-sensor direction, angular-speed compensated
    float flow_comp_m_y; ///< Flow in meters in y-sensor direction, angular-speed compensated
    float ground_distance; ///< Ground distance in meters. Positive value: distance known. Negative value: Unknown distance
    int16_t flow_x; ///< Flow in pixels in x-sensor direction
    int16_t flow_y; ///< Flow in pixels in y-sensor direction
    uint8_t sensor_id; ///< Sensor ID
    uint8_t quality; ///< Optical flow quality / confidence. 0: bad, 255: maximum quality

%}

%{
    
    utils_us_since_epoch(),
    of.time_usec,
    of.flow_comp_m_x,
    of.flow_comp_m_y,
    of.ground_distance,
    of.flow_x,
    of.flow_y,
    of.sensor_id,
    of.quality

%}


of.ts               = data(:,1);
of.time_usec        = data(:,2);
of.flow_comp_m_x    = data(:,3);
of.flow_comp_m_y    = data(:,4);
of.ground_distance  = data(:,5);
of.flow_x           = data(:,6);
of.flow_y           = data(:,7);
of.sensor_id        = data(:,8);
of.quality          = data(:,9);

of.n = length(of.ts);

end