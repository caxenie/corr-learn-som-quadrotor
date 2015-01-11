function [sor] = read_mavlink_msg_servo_output_raw(filename)

if(exist(filename,'file') == 0)
    sor = [];
    return;
end



data = dlmread(filename);

%{
        uint32_t time_usec; ///< Timestamp (microseconds since system boot)
        uint16_t servo1_raw; ///< Servo output 1 value, in microseconds
        uint16_t servo2_raw; ///< Servo output 2 value, in microseconds
        uint16_t servo3_raw; ///< Servo output 3 value, in microseconds
        uint16_t servo4_raw; ///< Servo output 4 value, in microseconds
        uint16_t servo5_raw; ///< Servo output 5 value, in microseconds
        uint16_t servo6_raw; ///< Servo output 6 value, in microseconds
        uint16_t servo7_raw; ///< Servo output 7 value, in microseconds
        uint16_t servo8_raw; ///< Servo output 8 value, in microseconds
        uint8_t port; ///< Servo output port (set of 8 outputs = 1 port). 
            Most MAVs will just use one, but this allows to encode more than 8 servos.
%}


%{
       microsSinceEpoch(),
        sor.time_usec,
        sor.servo1_raw,
        sor.servo2_raw,
        sor.servo3_raw,
        sor.servo4_raw,
        sor.servo5_raw,
        sor.servo6_raw,
        sor.servo7_raw,
        sor.servo8_raw,
        sor.port
%}


sor.ts               = data(:,1);
sor.time_usec        = data(:,2);
sor.servo1_raw       = data(:,3);
sor.servo2_raw       = data(:,4); 
sor.servo3_raw       = data(:,5); 
sor.servo4_raw       = data(:,6); 
sor.servo5_raw       = data(:,7); 
sor.servo6_raw       = data(:,8); 
sor.servo7_raw       = data(:,9); 
sor.servo8_raw       = data(:,10); 
sor.port             = data(:,11); 

sor.n = length(sor.ts);

end