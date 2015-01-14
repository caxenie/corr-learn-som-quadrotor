#include "tools.h"

/* input data struct */
typedef struct{
	int npop;		/* number of populations in the net */
	int popsize;		/* size of population: num of neurons */
	int len;		/* length of the training dataset */
	double **data;   	/* actual data */
}indata;

/* generate input data and populate struct */
indata* read_input_data(int np, int psz, FILE* f);
