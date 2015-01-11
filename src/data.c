#include "data.h"

/* read input data from file and populate struct */
indata* read_input_data(int np, int psz, FILE* f, int pkid)
{
	int data_pts = 0;	
	indata *id = (indata*)calloc(1, sizeof(indata));	
	double *rel_var;
	double *base_var; 	
	static fpos_t fpos;

	/* set position to current pack */	
	if(pkid!=0) fsetpos(f, &fpos);

	/* get the number of data points */
	fread(&data_pts, sizeof(int), 1, f);	
			
	/* allocate the return struct */
	id->data = (double**)calloc(data_pts, sizeof(double*));
	rel_var = (double*)calloc(data_pts, sizeof(double));		
	base_var = (double*)calloc(data_pts, sizeof(double));

 	id->npop = np;
	id->popsize = psz;
	id->len = data_pts;
	
	for(int i = 0;i<id->len; i++)
		id->data[i] = (double*)calloc(id->npop, sizeof(double));	

        /* fill in the struct with the current values in the drone dataset */
	for(int didx = 0; didx < id->len; didx++){
		fread(&(base_var[didx]), sizeof(double), 1, f);
	}				

	/* get the number of data points */
	fread(&data_pts, sizeof(int), 1, f);	
	
	for(int didx = 0; didx < id->len; didx++){
		fread(&(rel_var[didx]), sizeof(double), 1, f);
	}	

	/* get current position after reading the current pack */
	fgetpos(f, &fpos);	

	for(int i = 0;i<id->len;i++){
       		for(int j = 0;j<id->npop;j++){
			if(j==0) id->data[i][j] = base_var[i];
			else id->data[i][j] = rel_var[i];
		}
	}
	/* free allocated resources */
	free(base_var);
	free(rel_var);
	return id;
}	


