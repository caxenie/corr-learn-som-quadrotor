#include "data.h"

/* read input data from file and populate struct */
indata* read_input_data(int np, int psz, FILE* f)
{
	int data_pts = 0;	
	indata *id = (indata*)calloc(1, sizeof(indata));	
	double *rel_var;
	double *base_var;

	/* get the number of data points */
	fread(&data_pts, sizeof(int), 1, f);	
	
 	id->npop = np;
	id->popsize = psz;
	id->len = data_pts;
		
	/* allocate the return struct */
	id->data = (double**)calloc(np, sizeof(double*));
	rel_var = (double*)calloc(data_pts, sizeof(double));		
	base_var = (double*)calloc(data_pts, sizeof(double));
	
	for(int i = 0;i<id->npop; i++)
		id->data[i] = (double*)calloc(id->len, sizeof(double));	

        /* fill in the struct with the current values in the drone dataset */
	for(int didx = 0; didx < id->len; didx++){
		fread(&(base_var[didx]), sizeof(double), 1, f);
	}				
	
	/* get the number of data points for the second dataset */
	fread(&data_pts, sizeof(int), 1, f);

	id->len = data_pts;	
	
	for(int didx = 0; didx < id->len; didx++){
		fread(&(rel_var[didx]), sizeof(double), 1, f);
	}	

	for(int i = 0;i<id->npop;i++){
       		for(int j = 0;j<id->len;j++){
			if(i==0) id->data[i][j] = base_var[j];
			else id->data[i][j] = rel_var[j];
		}
	}
	/* free allocated resources */
	free(base_var);
	free(rel_var);
	return id;
}	


