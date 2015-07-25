function [ld_out] = add_precalcs(ld)

ld = add_time_and_offset_precalcs(ld);

ld = add_rigid_body_precalcs(ld);

ld = add_acc_precalcs(ld);
ld = add_gyro_precalcs(ld);
ld = add_mag_precalcs(ld);

ld = add_optical_flow_precalcs(ld);

ld = add_acc_FT(ld);


ld = add_a_rot_ref(ld);
ld = add_acc_a_lin(ld);
ld = add_acc_a_rot(ld);

ld = add_acc_angle_diff(ld);


ld = add_b_ref(ld);
ld = add_KF_roll_pitch(ld);
ld = add_acc_roll_spectrogram(ld);




ld_out = ld;

end













