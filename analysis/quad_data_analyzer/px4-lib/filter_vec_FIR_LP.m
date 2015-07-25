function [vec_f] = filter_vec_FIR_LP(vec, N, Fc, Fs)

d = fdesign.lowpass('N,Fc',N,Fc,Fs);
Hf = design(d,'FIR');

vec_f(1,:) = filter(Hf,vec(1,:));
vec_f(2,:) = filter(Hf,vec(2,:));
vec_f(3,:) = filter(Hf,vec(3,:));

end
