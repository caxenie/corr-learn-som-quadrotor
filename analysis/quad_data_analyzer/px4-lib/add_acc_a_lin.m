function [ld_out] = add_acc_a_lin(ld)


if(isfield(ld,'a_rot_ref') == 0 || isfield(ld,'acc') == 0)
    ld_out = ld;
    return;
end

%**************************************************************************
%%      linear acceleration: accelerometer based
%           with attitude / tracker based reference
%**************************************************************************

% calculate translational linear acceleration
ld.acc.a_lin = ld.acc.a - ld.a_rot_ref;

% filter data
ld.acc.a_lin_f = filter_vec_bw_LP(ld.acc.a_lin, 2, 3, ld.imu.hrt.freq_mean);

% calculate norm of linear acceleration
ld.acc.a_lin_norm = tline_norm(ld.acc.a_lin);



ld_out = ld;

end



function [vec_f] = filter_vec_bw_LP(vec, N, Fc, Fs)

[z,p,k] = butter(N,Fc/(Fs/2),'low');
[sos,g] = zp2sos(z,p,k);	    % Convert to SOS form
Hf = dfilt.df2tsos(sos,g);      % Create a dfilt object

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

end


function [norm] = tline_norm(vec)

n = size(vec,2);
norm = zeros(n,1);

for l =1:n    
    norm(l) = sqrt(vec(:,l)'*vec(:,l));
end

end