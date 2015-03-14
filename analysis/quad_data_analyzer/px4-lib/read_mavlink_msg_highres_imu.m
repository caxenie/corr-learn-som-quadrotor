function [imu] = read_mavlink_msg_highres_imu(filename)

if(exist(filename,'file') == 0)
    imu = [];
    return;
end

data = dlmread(filename);

%{

    uint64_t time_usec; ///< Timestamp (microseconds, synced to UNIX time or since system boot)
    float xacc; ///< X acceleration (m/s^2)
    float yacc; ///< Y acceleration (m/s^2)
    float zacc; ///< Z acceleration (m/s^2)
    float xgyro; ///< Angular speed around X axis (rad / sec)
    float ygyro; ///< Angular speed around Y axis (rad / sec)
    float zgyro; ///< Angular speed around Z axis (rad / sec)
    float xmag; ///< X Magnetic field (Gauss)
    float ymag; ///< Y Magnetic field (Gauss)
    float zmag; ///< Z Magnetic field (Gauss)
    float abs_pressure; ///< Absolute pressure in millibar
    float diff_pressure; ///< Differential pressure in millibar
    float pressure_alt; ///< Altitude calculated from pressure
    float temperature; ///< Temperature in degrees celsius

%}

%{
    microsSinceEpoch(),
    imu.time_usec,
    imu.xacc,
    imu.yacc,
    imu.zacc,
    imu.xgyro,
    imu.ygyro,
    imu.zgyro,
    imu.xmag,
    imu.ymag,
    imu.zmag,
    imu.abs_pressure,
    imu.pressure_alt
%}


imu.ts              = data(:,1);
imu.time_usec       = data(:,2);
imu.xacc            = data(:,3);
imu.yacc            = data(:,4);
imu.zacc            = data(:,5);
imu.xgyro           = data(:,6);
imu.ygyro           = data(:,7);
imu.zgyro           = data(:,8);
imu.xmag            = data(:,9);
imu.ymag            = data(:,10);
imu.zmag            = data(:,11);
imu.abs_pressure    = data(:,12);
imu.pressure_alt    = data(:,13);

imu.n = length(imu.ts);

end



