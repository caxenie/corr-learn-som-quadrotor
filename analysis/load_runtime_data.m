function [runtime_struct] = load_runtime_data(filename)
fid = fopen(filename);

% read the simulation data
runtime_struct.sim.max_epochs = fread(fid, 1, 'int');
runtime_struct.sim.t0 = fread(fid, 1, 'int');
runtime_struct.sim.tf_lrn_in = fread(fid, 1, 'int');
runtime_struct.sim.tf_lrn_cross = fread(fid, 1, 'int');
runtime_struct.sim.alpha = zeros(1, runtime_struct.sim.tf_lrn_in);
runtime_struct.sim.sigma = zeros(1, runtime_struct.sim.tf_lrn_in);
runtime_struct.sim.eta = zeros(1, runtime_struct.sim.tf_lrn_cross);
runtime_struct.sim.xi = zeros(1, runtime_struct.sim.tf_lrn_cross);

runtime_struct.sim.alpha = fread(fid, [1, runtime_struct.sim.tf_lrn_in], 'double');
runtime_struct.sim.sigma = fread(fid, [1, runtime_struct.sim.tf_lrn_in], 'double');

runtime_struct.sim.eta = fread(fid, [1, runtime_struct.sim.tf_lrn_cross], 'double');
runtime_struct.sim.xi = fread(fid, [1, runtime_struct.sim.tf_lrn_cross], 'double');


% extract the network data
runtime_struct.sim.net.nsize = fread(fid, 1, 'short');
for pidx = 1:runtime_struct.sim.net.nsize
    runtime_struct.sim.net.pops(pidx).id = fread(fid, 1, 'short');
    runtime_struct.sim.net.pops(pidx).size = fread(fid, 1, 'int');
    for nidx = 1:runtime_struct.sim.net.pops(pidx).size
        runtime_struct.sim.net.pops(pidx).Winput(nidx) = fread(fid, 1, 'double');
        for nnidx = 1:runtime_struct.sim.net.pops(pidx).size
            runtime_struct.sim.net.pops(pidx).Wcross(nidx, nnidx) = fread(fid, 1, 'double');
        end
        runtime_struct.sim.net.pops(pidx).s(nidx) = fread(fid, 1, 'double');
        runtime_struct.sim.net.pops(pidx).a(nidx) = fread(fid, 1, 'double');
    end
end

% extract input data
runtime_struct.sim.indata.npop = fread(fid, 1, 'int');
runtime_struct.sim.indata.popsize = fread(fid, 1, 'int');
runtime_struct.sim.indata.len = fread(fid, 1, 'int');
for pidx = 1:runtime_struct.sim.indata.npop
    for lidx = 1:runtime_struct.sim.indata.len
        runtime_struct.sim.indata.data(pidx, lidx) = fread(fid, 1, 'double');
    end
end
% close the file
fclose(fid);
end
