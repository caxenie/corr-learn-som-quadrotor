#include "simulation.h"

int main(int argc, char* argv[])
{
	FILE *f = fopen(argv[1], "rb");
	indata *idata = read_input_data(N_POP, POP_SIZE, f);
	network *net = init_network(idata->npop, idata->popsize); 
	simulation *sim = init_simulation(MAX_EPOCHS, net);
	outdata *runtime = run_simulation(idata, sim);
	char *dump_file = dump_runtime_data_extended(runtime, BASIC);
	printf("CORR_LEARN_NET: Runtime data dumped on disk in: %s\n", dump_file);
	/* free allocated resources for next pack */
	deinit_simulation(sim);
	free(idata);
	free(runtime);
	fclose(f);
	return EXIT_SUCCESS;
}
