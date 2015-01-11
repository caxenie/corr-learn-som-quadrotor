#include "simulation.h"

#define DFILE 		"quad_data_raw.dat"
#define PACKS  		1

int main(int argc, char* argv[])
{
	FILE *f = fopen(DFILE, "rb");
	indata *idata;
	simulation *sim;
	outdata *runtime;
	char *dump_file;
	network *net;
	for(int pkid = 0; pkid < PACKS; pkid++){
		idata = read_input_data(N_POP, POP_SIZE, f, pkid);
		net = init_network(idata->npop, idata->popsize); 
		sim = init_simulation(MAX_EPOCHS, net);
		runtime = run_simulation(idata, sim);
		dump_file = dump_runtime_data_extended(runtime, BASIC);
		printf("CORR_LEARN_NET: Pack %d - Runtime data dumped on disk in: %s\n", pkid, dump_file);
		/* free allocated resources for next pack */
		deinit_simulation(sim);
		free(idata);
		free(runtime);
	}
	fclose(f);
	return EXIT_SUCCESS;
}
