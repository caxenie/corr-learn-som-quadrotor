#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <float.h>
#include <time.h>
#include <string.h>

#define MAX(a,b) \
   ({ typeof (a) _a = (a), _b = (b); _a > _b ? _a : _b; }) 

#define MIN(a,b) \
   ({ typeof (a) _a = (a), _b = (b); _a < _b ? _a : _b; }) 

/* neural population definition */
typedef struct{
	short id;	/* id of the population */
	int size;	/* size of the population */
	double *Winput;/* sensory afferents synaptic connections */
	double **Wcross;/* cross modal afferents synaptic connections */
	double *s;	/* population tuning curves shapes */
	double *a;	/* population activation */
}population;

/* network definition */
typedef struct{
	short nsize;		/* number of populations in the net */
	population *pops;	/* populations in the net */
}network;

/* initialize a neural population */
population init_population(short idx, int psize);
/* initialize the network */
network* init_network(int npop, int psize);
/* deallocate a neural population */
void deinit_population(population *pop);
/* deallocate a network */
void deinit_network(network *net);
/* parametrize adaptive parameters */
double* parametrize_process(double v0, double vf, int t0, int tf, short type);
/* number of shuffles for maps ids for cross-modal circular permutation in Hebbian learning rule */
long num_shuffles(int n, int r);
/* shuffle the maps ids for cross-modal circular permutation in Hebbian learning rule */
unsigned int shuffle_pops_ids(unsigned int *ar, size_t n, unsigned int k);
/* decoder metric for optimization  */
double decoder_metric(network*n, int pre_id, int post_id, double guess);
/* decode population to real-world value */
double decode_population(network* n, double x1, double x2, double tol, int pre_id, int post_id);

