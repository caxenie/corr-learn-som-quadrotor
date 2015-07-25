#include "network.h"
#include "data.h"
#include <stddef.h>

/* simulation constant parameters */
#define MAX_EPOCHS      300
#define N_POP           2
#define POP_SIZE        100
#define ALPHAI 		0.1f
#define ALPHAF 		0.001f
#define SIGMAF 		1.0f
#define ETA   		1.0f
#define XI    		0.01f
#define WRAP_POP 	0

/* optimizer utils */
#define SIGN(a,b)       ((b) >= 0.0 ? fabs(a) : -fabs(a))
#define ITMAX           100
#define EPS             1.1e-16

/* adaptive processes parametrization types */
enum{
	SIGMOID = 0, 
	INVTIME,
	EXP
};

/* cross-modal learning rules */
enum{
	HEBB = 0, 
	COVARIANCE,
};

/* data dump type */
enum{
	BASIC = 0, 
	TESTS, 
	EXT_TESTS,
};

/* decoder type */
enum{
	NAIVE = 0,
	OPTIMIZER,
};

#define DECODER 	OPTIMIZER // {NAIVE, OPTIMIZER}
#define LEARNING_RULE 	COVARIANCE // {COVARIANCE, HEBB}

/* simulation parameters */
typedef struct{
	int max_epochs; 	/* number of epochs to run the network */
	int t0;			/* initial time for simulation */
	int tf_lrn_in;		/* stop time for input learning */
	int tf_lrn_cross;	/* stop time for cross learning */
	double *alpha;		/* values of the learning rate */
	double *sigma;		/* neighborhood kernel size */
 	double *eta;		/* activity decay factor */
	double *xi;		/* cross modal learning rate */ 	
	network *n;		/* network to simulate */
}simulation;

/* output data struct */
typedef struct{
        simulation *sim;        /* simulation params */
        indata *in;             /* input data */
}outdata;


/* initialize simulation */
simulation* init_simulation(int nepochs, network*net);
/* destroy the simulation */
void deinit_simulation(simulation* s);
/* run simulation and save runtime data struct */
outdata* run_simulation(indata *in, simulation *s);
/* dump the runtime data to file on disk */
char* dump_runtime_data(outdata *od);
/* dump the runtime data to file on disk - explicit sequential write */
char* dump_runtime_data_extended(outdata *od, int format);

/* network testing routines */ 

/* test network's capabilities to perform inference, 
   given one modality compute the other given the learned correlation */
outdata* test_inference(outdata* learning_runtime);
/* test network's fault tolerance capabilities, 
   given one strongly perturbed modality compute the correct value given 
   the learned correlation and the other correct modality */
outdata* test_fault_tolerance(outdata* learning_runtime);
