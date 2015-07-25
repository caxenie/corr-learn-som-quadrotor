function [ld] = read_log_data(root_dir_path, log_dir_name)

path = sprintf('%s/%s',root_dir_path,log_dir_name);

sor = read_mavlink_msg_servo_output_raw(sprintf('%s/servo_output_raw.log',path));
mc = read_mavlink_msg_manual_control(sprintf('%s/manual_control.log',path));
ss = read_mavlink_msg_sys_status(sprintf('%s/sys_status.log',path));
imu = read_mavlink_msg_highres_imu(sprintf('%s/highres_imu.log',path));
att = read_mavlink_msg_attitude(sprintf('%s/attitude.log',path));
of = read_mavlink_msg_optical_flow(sprintf('%s/optical_flow.log',path));
rb = read_tracker_rigidBody(sprintf('%s/drone.log',path));


if(isempty(sor) == 0)
    ld.sor = sor;
end

if(isempty(mc) == 0)
    ld.mc = mc;
end

if(isempty(ss) == 0)
    ld.ss = ss;
end

if(isempty(imu) == 0)
    ld.imu = imu;
end

if(isempty(att) == 0)
    ld.att = att;
end

if(isempty(of) == 0)
    ld.of = of;
end

if(isempty(rb) == 0)
    ld.rb = rb;
end




end