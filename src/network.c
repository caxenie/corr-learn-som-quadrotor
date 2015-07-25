
#include "simulation.h"

/* initialize a neural population */
population init_population(short idx, int psize)
{
	population p;
	double sigma_def = 0.045000f;
	double sumWcross = 0.0f;

	p.id = idx;
	p.size = psize;	

	p.Winput = (double*)calloc(p.size, sizeof(population));
	p.Wcross = (double**)calloc(p.size, sizeof(population*));
	for(int i = 0; i<p.size; i++)
		p.Wcross[i] = (double*)calloc(p.size, sizeof(population));
	for(int i =0; i<p.size; i++){
		for(int j = 0; j<p.size; j++){
			p.Wcross[i][j] = (double)rand()/(double)RAND_MAX;
			sumWcross += p.Wcross[i][j];
		}
	}
	for(int i =0; i<p.size; i++){
		for(int j = 0; j<p.size; j++){
			p.Wcross[i][j] /= sumWcross;
		}
	}

 	p.s = (double*)calloc(p.size, sizeof(double));
	for (int i=0; i<p.size;i++)
		p.s[i] = sigma_def;

	p.a = (double*)calloc(p.size, sizeof(double));

	return p;	
}


/* initialize the network */
network* init_network(int npop, int psz)
{
	network* n = (network*)calloc(1, sizeof(network));
	n->nsize = npop;
	n->pops = (population*)calloc(n->nsize, sizeof(population));
	for (int i = 0; i<n->nsize; i++)
		n->pops[i] = init_population((short)i, psz);

	return n;
}

/* deallocate a neural population */
void deinit_population(population *p)
{
	for(int i=0; i<p->size;i++){
		free(p->Wcross[i]);	
	}
	free(p->Winput);
	free(p->Wcross);	
	free(p->s);
	free(p->a);
	free(p);
}


/* deallocate a network */
void deinit_network(network *net)
{
	free(net->pops);
	free(net);
}

/* parametrize adaptive parameters */
double* parametrize_process(double v0, double vf, int t0, int tf, short type)
{
        int len = tf-t0;
        double* out = (double*)calloc(len, sizeof(double));
        double s = 0.0f, p = 0.0f, A = 0.0f, B = 0.0f;

        switch(type){
                case SIGMOID:
                        s = -floor(log10(tf))*pow(10, (-(floor(log10(tf)))));
                        p = abs(s*pow(10, (floor(log10(tf))+ floor(log10(tf)/2))));
                        for(int i = 0;i<len;i++)
                                out[i] = v0 - v0/(1+exp(s*(i-(tf/p)))) + vf;
                break;
                case INVTIME:
                        B = (vf*tf - v0*t0)/(v0-vf);
                        A = v0*t0 + B*v0;
                        for (int i=0;i<len;i++)
                                out[i] = A/(i+B);
                break;
                case EXP:
                        if(v0<1) p = -log(v0);
                        else p = log(v0);
                        for(int i=0;i<len;i++)
                                out[i] = v0*exp(-i/(tf/p));
                break;
        }
        return out;
}

/* number of shuffles for maps ids for cross-modal circular permutation in Hebbian learning rule */
long num_shuffles(int n, int r)
{
    long f[n + 1];
    f[0]=1;
    for (int i=1;i<=n;i++)
        f[i]=i*f[i-1];
    return f[n]/f[r]/f[n-r];
}

/* shuffle the maps ids for cross-modal circular permutation in Hebbian learning rule */
unsigned int shuffle_pops_ids(unsigned int *ar, size_t n, unsigned int k)
{
    unsigned int finished = 0;
    unsigned int changed = 0;
    unsigned int i;

    if (k > 0) {
        for (i = k - 1; !finished && !changed; i--) {
            if (ar[i] < (n - 1) - (k - 1) + i) {
                /* Increment this element */
                ar[i]++;
                if (i < k - 1) {
                    /* Turn the elements after it into a linear sequence */
                    unsigned int j;
                    for (j = i + 1; j < k; j++) {
                        ar[j] = ar[j - 1] + 1;
                    }
                }
                changed = 1;
            }
            finished = i == 0;
        }
        if (!changed) {
            /* Reset to first combination */
            for (i = 0; i < k; i++) {
                ar[i] = i;
            }
        }
    }
    return changed;
}

/* decoder metric for optimization  */
double decoder_metric(network*n, int pre_id, int post_id, double guess)
{
//	fact = fopen("activations.log", "a+");	
	double* dir_act = (double*)calloc(n->pops[post_id].size, sizeof(double));
	double* ind_act = n->pops[post_id].a;
	double* cur_act = (double*)calloc(n->pops[post_id].size, sizeof(double));
	double tot_act = 0.0f;
	double temp_fx = 0.0f;
	double fx = 0.0f;

	/* compute direct activation given the optimized variable */
	for(int i=0; i<n->pops[post_id].size; i++){
			cur_act[i] = (1/(sqrt(2*M_PI)*n->pops[post_id].s[i]))*
                                      exp(-pow((guess - n->pops[post_id].Winput[i]),2)/
				     (2*pow(n->pops[post_id].s[i], 2)));
				
	}
	/* normalization routine */
	for(int snid = 0; snid<n->pops[post_id].size; snid++)
                 tot_act += cur_act[snid];
        for(int snid = 0; snid<n->pops[post_id].size; snid++)
                 cur_act[snid] /= tot_act;
        /* update the activity for next iteration */
	dir_act = cur_act;
	/* function to optimize is the error between the direct and indirect activation */
	for(int i=0;i<n->pops[post_id].size;i++)
		temp_fx += pow(ind_act[i] - dir_act[i], 2);
	fx = sqrt(temp_fx);
	/* clear allocated resources */
	free(dir_act);
	free(ind_act);
	free(cur_act);
	return fx;
}

/* decode population to real-world value */
double decode_population(network* n, double x1, double x2, double tol, int pre_id, int post_id)
{
	int iter;
	double a=x1,b=x2,c=x2,d,e,min1,min2;
	double fa=decoder_metric(n, pre_id, post_id, a),fb=decoder_metric(n, pre_id, post_id, b),fc,p,q,r,s,tol1,xm;

	fc=fb;
	for (iter=1;iter<=ITMAX;iter++) {
		if ((fb > 0.0 && fc > 0.0) || (fb < 0.0 && fc < 0.0)) {
			c=a;
			fc=fa;
			e=d=b-a;
		}
		if (fabs(fc) < fabs(fb)) {
			a=b;
			b=c;
			c=a;
			fa=fb;
			fb=fc;
			fc=fa;
		}
		tol1=2.0*EPS*fabs(b)+0.5*tol; // convergence check
		xm=0.5*(c-b);
		if (fabs(xm) <= tol1 || fb == 0.0) return b;
		if (fabs(e) >= tol1 && fabs(fa) > fabs(fb)) {
			s=fb/fa;		// Attempt inverse quadratic interpolation
			if (a == c) {
				p=2.0*xm*s;
				q=1.0-s;
			} else {
				q=fa/fc;
				r=fb/fc;
				p=s*(2.0*xm*q*(q-r)-(b-a)*(r-1.0));
				q=(q-1.0)*(r-1.0)*(s-1.0);
			}
			if (p > 0.0) q = -q;	// Check whether in bounds
			p=fabs(p);
			min1=3.0*xm*q-fabs(tol1*q);
			min2=fabs(e*q);
			if (2.0*p < (min1 < min2 ? min1 : min2)) {
				e=d;		// Accept interpolation
				d=p/q;
			} else {
				d=xm;		// Interpolation failed, use bisection
				e=d;
			}
		} else {
			d=xm;			// Bounds decreasing too slowly, use bisection
			e=d;
		}
		a=b;				// Move last best guess to a
		fa=fb;
		if (fabs(d) > tol1)		// Evaluate new trial root
			b += d;
		else
			b += SIGN(tol1,xm);
		fb=decoder_metric(n, pre_id, post_id, b);
	}
	printf("decode_population: Maximum number of iterations exceeded in decoder optimizer\n");
	return 0.0;				// Should never get here
}
