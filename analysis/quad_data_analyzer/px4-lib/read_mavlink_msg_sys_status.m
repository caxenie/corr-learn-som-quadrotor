function [stat] = read_mavlink_msg_sys_status(filename)

if(exist(filename,'file') == 0)
    stat = [];
    return;
end

data = dlmread(filename);

%{

    uint32_t onboard_control_sensors_present; ///< Bitmask showing which onboard controllers and sensors are present. Value of 0: not present. Value of 1: present. Indices: 0: 3D gyro, 1: 3D acc, 2: 3D mag, 3: absolute pressure, 4: differential pressure, 5: GPS, 6: optical flow, 7: computer vision position, 8: laser based position, 9: external ground-truth (Vicon or Leica). Controllers: 10: 3D angular rate control 11: attitude stabilization, 12: yaw position, 13: z/altitude control, 14: x/y position control, 15: motor outputs / control
    uint32_t onboard_control_sensors_enabled; ///< Bitmask showing which onboard controllers and sensors are enabled:  Value of 0: not enabled. Value of 1: enabled. Indices: 0: 3D gyro, 1: 3D acc, 2: 3D mag, 3: absolute pressure, 4: differential pressure, 5: GPS, 6: optical flow, 7: computer vision position, 8: laser based position, 9: external ground-truth (Vicon or Leica). Controllers: 10: 3D angular rate control 11: attitude stabilization, 12: yaw position, 13: z/altitude control, 14: x/y position control, 15: motor outputs / control
    uint32_t onboard_control_sensors_health; ///< Bitmask showing which onboard controllers and sensors are operational or have an error:  Value of 0: not enabled. Value of 1: enabled. Indices: 0: 3D gyro, 1: 3D acc, 2: 3D mag, 3: absolute pressure, 4: differential pressure, 5: GPS, 6: optical flow, 7: computer vision position, 8: laser based position, 9: external ground-truth (Vicon or Leica). Controllers: 10: 3D angular rate control 11: attitude stabilization, 12: yaw position, 13: z/altitude control, 14: x/y position control, 15: motor outputs / control
    uint16_t load; ///< Maximum usage in percent of the mainloop time, (0%: 0, 100%: 1000) should be always below 1000
    uint16_t voltage_battery; ///< Battery voltage, in millivolts (1 = 1 millivolt)
    int16_t current_battery; ///< Battery current, in 10*milliamperes (1 = 10 milliampere), -1: autopilot does not measure the current
    uint16_t drop_rate_comm; ///< Communication drops in percent, (0%: 0, 100%: 10'000), (UART, I2C, SPI, CAN), dropped packets on all links (packets that were corrupted on reception on the MAV)
    uint16_t errors_comm; ///< Communication errors (UART, I2C, SPI, CAN), dropped packets on all links (packets that were corrupted on reception on the MAV)
    uint16_t errors_count1; ///< Autopilot-specific errors
    uint16_t errors_count2; ///< Autopilot-specific errors
    uint16_t errors_count3; ///< Autopilot-specific errors
    uint16_t errors_count4; ///< Autopilot-specific errors
    int8_t battery_remaining; ///< Remaining battery energy: (0%: 0, 100%: 100), -1: autopilot estimate the remaining battery

%}


%{
    utils_us_since_epoch(),
    stat.onboard_control_sensors_present,
    stat.onboard_control_sensors_enabled,
    stat.onboard_control_sensors_health,
    stat.load,
    stat.voltage_battery,
    stat.current_battery,
    stat.drop_rate_comm,
    stat.errors_comm,
    stat.errors_count1,
    stat.errors_count2,
    stat.errors_count3,
    stat.errors_count4,
    stat.battery_remaining
%}


stat.ts                                     = data(:,1);
stat.onboard_control_sensors_present        = data(:,2);
stat.onboard_control_sensors_enabled        = data(:,3);
stat.onboard_control_sensors_health         = data(:,4);
stat.load                                   = data(:,5);
stat.voltage_battery                        = data(:,6);
stat.current_battery                        = data(:,7);
stat.drop_rate_comm                         = data(:,8);
stat.errors_comm                            = data(:,9);
stat.errors_count1                          = data(:,10);
stat.errors_count2                          = data(:,11);
stat.errors_count3                          = data(:,12);
stat.errors_count4                          = data(:,13);
stat.battery_remaining                      = data(:,14);


stat.n = length(stat.ts);

end