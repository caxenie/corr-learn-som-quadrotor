function [mc] = read_mavlink_msg_manual_control(filename)

if(exist(filename,'file') == 0)
    mc = [];
    return;
end

data = dlmread(filename);

%{
    int16_t x; ///< X-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to forward(1000)-backward(-1000) movement on a joystick and the pitch of a vehicle.
    int16_t y; ///< Y-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to left(-1000)-right(1000) movement on a joystick and the roll of a vehicle.
    int16_t z; ///< Z-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to a separate slider movement with maximum being 1000 and minimum being -1000 on a joystick and the thrust of a vehicle.
    int16_t r; ///< R-axis, normalized to the range [-1000,1000]. A value of INT16_MAX indicates that this axis is invalid. Generally corresponds to a twisting of the joystick, with counter-clockwise being 1000 and clockwise being -1000, and the yaw of a vehicle.
    uint16_t buttons; ///< A bitfield corresponding to the joystick buttons' current state, 1 for pressed, 0 for released. The lowest bit corresponds to Button 1.
    uint8_t target; ///< The system to be controlled.

    x = roll        [-600,600]
    y = pitch       [-600,600]
    z = yaw         [-2000,2000]
    r = thrust      [0,1000]

%}

%{

    utils_us_since_epoch(),
    mc.x,
    mc.y,
    mc.z,
    mc.r,
    mc.buttons,
    mc.target

%}


mc.ts               = data(:,1);
mc.x                = data(:,2);
mc.y                = data(:,3);
mc.z                = data(:,4);
mc.r                = data(:,5);
mc.buttons          = data(:,6);
mc.target           = data(:,7);

mc.n = length(mc.ts);

end