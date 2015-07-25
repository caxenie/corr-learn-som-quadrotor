#include "tools.h"

/* sort generated data vector */
void sort_input_data(int n, double *ra)
{
        int l, j, ir, i;
        double rra;

        l = (n >> 1) + 1;
        ir = n;

        /* The index l will be decremented from its initial value down to 1 during
         * the "hiring" (heap creation) phase.  Once it reaches 1, the index ir will
         * be decremented from its initial value down to 1 during the "retirement-
         * and-promotion" (heap selection) phase.
        */
        for ( ; ; )
        {
                if (l > 1)                                      /* still in hiring phase */
                        rra = ra[--l];
                else                                            /* in retirement-and-promotion phase */
                {
                        rra = ra[ir];           /* clear a space at end of array */
                        ra[ir]=ra[1];                   /* retire the top of the heap into it */
                        if (--ir == 1)                  /* done with last promotion */
                        {
                                ra[1] = rra;
	                        return;
                        }                                               /* end if */
                }                                                       /* end else */
                i = l;                                          /* whether we are in the hiring phase */
                j = l << 1;                                     /* or promotion phase, we here set up */
                while ( j <= ir )
                {
                        if ( (j < ir) && (ra[j] < ra[j + 1]) )
                                ++j;                            /* compare to the better underling */
                                if ( rra < ra[j] )      /* demote rra */
                                {
                                        ra[i] = ra[j];
                                        j += (i = j);
                                }
                                else
                                        j = ir + 1;             /* this is rra's level; set j to */
                }                           /* terminate the sift-down */
                ra[i] = rra;                            /* put rra into its slot */
        }
}

/* swap data points */
void swap_data_points(double *in1, double *in2)
{
	double tmp = *in1; *in1 = *in2; *in2 = tmp;	
}

/* shuffle generated data vector */
void shuffle_input_data(double *arr, int n)
{
	/* Use a different seed value so that we don't get same result each time we run this program */
	srand ( time(NULL) );
	for (int i = n-1; i > 0; i--){
		int j = rand() % (i+1);
		swap_data_points(&arr[i], &arr[j]);	
	}
}

