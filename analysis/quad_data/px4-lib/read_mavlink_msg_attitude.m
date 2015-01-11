function [att] = read_mavlink_msg_attitude(filename)

if(exist(filename,'file') == 0)
    att = [];
    return;
end

data = dlmread(filename);

%{
    uint32_t time_boot_ms; ///< Timestamp (milliseconds since system boot)
    float roll; ///< Roll angle (rad, -pi..+pi)
    float pitch; ///< Pitch angle (rad, -pi..+pi)
    float yaw; ///< Yaw angle (rad, -pi..+pi)
    float rollspeed; ///< Roll angular speed (rad/s)
    float pitchspeed; ///< Pitch angular speed (rad/s)
    float yawspeed; ///< Yaw angular speed (rad/s)
%}


%{
   microsSinceEpoch(),
   att.time_boot_ms,
   att.roll,
   att.pitch,
   att.yaw,
   att.rollspeed,
   att.pitchspeed,
   att.yawspeed);
%}


att.ts              = data(:,1);
att.time_boot_ms    = data(:,2);
att.roll            = data(:,3);
att.pitch           = data(:,4);
att.yaw             = data(:,5);
att.rollspeed       = data(:,6);
att.pitchspeed      = data(:,7);
att.yawspeed        = data(:,8);

att.n               = length(att.ts);

end



