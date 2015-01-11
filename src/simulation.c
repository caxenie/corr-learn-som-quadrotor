#include "simulation.h"

/* initialize simulation */
simulation* init_simulation(int nepochs, network*net)
{
	simulation* s = (simulation*)calloc(1, sizeof(simulation));
	double A = 0.0f, B = 0.0f; 

	s->max_epochs = nepochs;
	s->t0 = 0;
	s->tf_lrn_in = s->max_epochs/4;
	s->tf_lrn_cross = s->max_epochs;
	
	s->alpha = (double*)calloc(s->tf_lrn_in, sizeof(double));
	s->sigma = (double*)calloc(s->tf_lrn_in, sizeof(double));
	s->eta = (double*)calloc(s->tf_lrn_cross, sizeof(double));
	s->xi = (double*)calloc(s->tf_lrn_cross, sizeof(double));
	s->alpha = parametrize_process(ALPHAI, ALPHAF, s->t0, s->tf_lrn_in, INVTIME);
	s->sigma = parametrize_process((net->pops->size)/3, SIGMAF, s->t0, s->tf_lrn_in, INVTIME);
	for (int i = 0;i<s->tf_lrn_cross;i++)
		s->eta[i] = ETA;
	for (int i = 0;i<s->tf_lrn_cross;i++)
		s->xi[i] = XI;
	s->n = net;
	return s;
}

/* run simulation and save runtime data struct */
outdata* run_simulation(indata *in, simulation *s)
{
	double insample = 0.0f;
	double tot_act = 0.0f;
	double *cur_act = (double*)calloc(s->n->pops[0].size, sizeof(double));
	double **avg_act = (double**)calloc(s->n->nsize, sizeof(double*));
	for(int i=0; i<s->n->nsize; i++)
		avg_act[i] = (double*)calloc(s->n->pops[0].size, sizeof(double));
	double *sum_wcross = (double*)calloc(s->n->nsize, sizeof(double));
	double *max_wcross = (double*)calloc(s->n->nsize, sizeof(double));
	double win_act = 0.0f;
	int win_idx = 0;
	double omega = 0.0f;
	double *hwi = (double*)calloc(s->n->pops[0].size, sizeof(double));
	outdata *runtime = (outdata*)calloc(1, sizeof(outdata));
	/* utils for pops ids shuffling */
	int base_idx[] = {0,1,2};
	const int pre_post_pair = 2;
	int sol_idx = 0;
	int** sol = (int**)calloc(pre_post_pair*num_shuffles(s->n->nsize, pre_post_pair), sizeof(int*));
	for(int i = 0; i<pre_post_pair*num_shuffles(s->n->nsize, pre_post_pair);i++)
        	sol[i] = (int*)calloc(pre_post_pair, sizeof(int));
	/* shuffle maps ids */
	do{
		/* shuffle the populations ids for updating */
		int* cur_ids = base_idx;
		sol[sol_idx][0] = cur_ids[0];
		sol[sol_idx][1] = cur_ids[1];
		sol[sol_idx+num_shuffles(s->n->nsize, pre_post_pair)][0] = cur_ids[1];
		sol[sol_idx+num_shuffles(s->n->nsize, pre_post_pair)][1] = cur_ids[0];
		sol_idx ++;
	}while(shuffle_pops_ids(base_idx, s->n->nsize, pre_post_pair));

	/* correlation learning loop */
        for(int tidx = s->t0; tidx<s->tf_lrn_cross; tidx++){	
		if(tidx<s->tf_lrn_in){
			/* input distribution learning loop */
			for(int didx = 0; didx < in->len; didx++){
				/* loop through populations */
				for(int pidx = 0; pidx < s->n->nsize; pidx++){
					tot_act = 0.0f;
					win_act = 0.0f;
					win_idx = 0.0f;
					hwi = (double*)calloc(s->n->pops[0].size, sizeof(double));
					insample = in->data[didx][pidx];
					cur_act = (double*)calloc(s->n->pops[0].size, sizeof(double));
					/* loop through neurons in current population */
					for(int nidx = 0; nidx<s->n->pops[pidx].size;nidx++){
						/* compute sensory elicited activation */
						cur_act[nidx] = (1/(sqrt(2*M_PI)*s->n->pops[pidx].s[nidx]))*
							   exp(-pow((insample - s->n->pops[pidx].Winput[nidx]),2)/(2*pow(s->n->pops[pidx].s[nidx], 2)));
					}	
					/* normalize the activity vector of the population */
					for(int snid = 0; snid<s->n->pops[pidx].size; snid++)
						tot_act	+= cur_act[snid];
					for(int snid = 0; snid<s->n->pops[pidx].size; snid++)	
						cur_act[snid] /= tot_act;
					/* update the activity for next iteration */
					for(int nidx = 0; nidx<s->n->pops[pidx].size;nidx++)
						s->n->pops[pidx].a[nidx] = (1-s->eta[tidx])*s->n->pops[pidx].a[nidx] + s->eta[tidx]*cur_act[nidx];
					/* competition step - find the neuron with maximum activity */
					/* find the neuron with maximum activity and its index in the population */
					for(int snid = 0; snid<s->n->pops[pidx].size; snid++){ 
						if(s->n->pops[pidx].a[snid] > win_act){
							win_act = s->n->pops[pidx].a[snid];
							win_idx = snid;
						}
					}
					for(int nidx = 0; nidx<s->n->pops[pidx].size;nidx++){
						/* compute the neighborhood kernel */
						if(!WRAP_POP)
							/* if we do not treat boundary effects use traditional neighborhood function */
							hwi[nidx] = exp(-pow(fabs(nidx -  win_idx), 2)/(2*pow(s->sigma[tidx], 2)));
						else
							/* wrap up the population to avoid boundary effects */
				                        /* dist = min{|i-j|, N - |i-j|} */
			        	                hwi[nidx] = exp(-pow(MIN(fabs(nidx-win_idx), s->n->pops[pidx].size-fabs(nidx-win_idx)), 2)/
								       (2*pow(s->sigma[tidx], 2)));
						/* compute the sensory input synaptic weight */
						s->n->pops[pidx].Winput[nidx] += s->alpha[tidx]*hwi[nidx]*(insample - s->n->pops[pidx].Winput[nidx]); 
						/* update the shape of the tuning curve for the current neuron */
						if(!ASYMM_FUNC)
							s->n->pops[pidx].s[nidx] += s->alpha[tidx]*
										    exp(-pow(fabs(nidx -  win_idx), 2)/(2*pow(s->sigma[tidx], 2)))*
										    (pow((insample - s->n->pops[pidx].Winput[nidx]) , 2) - pow(s->n->pops[pidx].s[nidx], 2));
						else
							s->n->pops[pidx].s[nidx] += s->alpha[tidx]*0.005*
                                                                        	    exp(-pow(fabs(nidx -  win_idx), 2)/(2*pow(s->sigma[tidx], 2)))*
                                        	                                    (pow((insample - s->n->pops[pidx].Winput[nidx]) , 2) - pow(s->n->pops[pidx].s[nidx], 2));
					}/* end for each neuron in the population */
				    }/* end loop through populations */	
				}/* end loop of sensory data presentation */
			}/* end loop for training input data distribution */

			/* cross-modal learning loop */
                        for(int didx = 0; didx < in->len; didx++){
				/* use the learned sensory elicited synaptic weights and compute activation for each population */
				/* loop through populations */
                                for(int pidx = 0; pidx < s->n->nsize; pidx++){
                                        tot_act = 0.0f;
					cur_act = (double*)calloc(s->n->pops[0].size, sizeof(double));
                                        insample = in->data[didx][pidx];
                                        /* loop through neurons in current population */
                                        for(int nidx = 0; nidx<s->n->pops[pidx].size;nidx++){
                                                /* compute sensory elicited activation */
                                                cur_act[nidx] = (1/(sqrt(2*M_PI)*s->n->pops[pidx].s[nidx]))*
                                                           exp(-pow((insample - s->n->pops[pidx].Winput[nidx]),2)/(2*pow(s->n->pops[pidx].s[nidx], 2)));
                                        }
                                        /* normalize the activity vector of the population */
                                        for(int snid = 0; snid<s->n->pops[pidx].size; snid++)
                                                tot_act += cur_act[snid];
					for(int snid = 0; snid<s->n->pops[pidx].size; snid++)
	                                        cur_act[snid] /= tot_act;
					/* update the activity for next iteration */
                                        for(int nidx = 0; nidx<s->n->pops[pidx].size;nidx++)
                                                s->n->pops[pidx].a[nidx] = (1-s->eta[tidx])*s->n->pops[pidx].a[nidx] + s->eta[tidx]*cur_act[nidx];
				 }/* end loop for each population */
				        
					/* select the learning rule type */
					int pidx = 0;
					switch(LEARNING_RULE){	
						case HEBB:
							/* cross-modal hebbian learning */
							/* update the synaptic weights for cross-modal interaction */			
						        for(int si =0;si<pre_post_pair*num_shuffles(s->n->nsize, pre_post_pair);si++){
								for(int i=0;i<s->n->pops[pidx].size;i++){
									  for(int j=0; j<s->n->pops[pidx].size; j++){
										s->n->pops[sol[si][0]].Wcross[i][j] = (1-s->xi[tidx])*s->n->pops[sol[si][0]].Wcross[i][j]+
													s->xi[tidx]*s->n->pops[sol[si][0]].a[i]*s->n->pops[sol[si][1]].a[j];
							  		}
					        		}
							}
						break;
						case COVARIANCE:
							/* compute the mean value decay */
							omega = 0.002f + 0.998f/(tidx+2);
							/* compute the average activity */
							for(int pidx = 0; pidx < s->n->nsize; pidx++){
								for(int snid = 0; snid<s->n->pops[pidx].size; snid++){
                                                                        avg_act[pidx][snid] = (1-omega)*avg_act[pidx][snid] + omega*s->n->pops[pidx].a[snid];
                                                                }
							}
						/* cross-modal covariance learning rule */
							/* update the synaptic weights for cross-modal interaction */			
						        for(int si =0;si<pre_post_pair*num_shuffles(s->n->nsize, pre_post_pair);si++){
							    for(int i=0;i<s->n->pops[pidx].size;i++){
                                	                        for(int j=0; j<s->n->pops[pidx].size; j++){
							              s->n->pops[sol[si][0]].Wcross[i][j] = (1-s->xi[tidx])*s->n->pops[sol[si][0]].Wcross[i][j]+
                                                                                                    s->xi[tidx]*
												    (s->n->pops[sol[si][0]].a[i] - avg_act[sol[si][0]][i])*
												    (s->n->pops[sol[si][1]].a[j] - avg_act[sol[si][1]][j]);
                        	                                }
                	                                    }
						      }
						break;
					}/* end learning rule selector */
			}/* end dataset loop for cross-modal learning */
	}/* end cross-modal learning process */
	/* normalize cross-modal synaptic weights for visualization */
	for(int pidx = 0; pidx < s->n->nsize; pidx++){
		for(int i=0;i<s->n->pops[pidx].size;i++){
        	        for(int j=0; j<s->n->pops[pidx].size; j++){
				if(s->n->pops[pidx].Wcross[i][j]>max_wcross[pidx])
					max_wcross[pidx] = s->n->pops[pidx].Wcross[i][j];	
			}
		}
	}
	for(int pidx = 0; pidx < s->n->nsize; pidx++){
                for(int i=0;i<s->n->pops[pidx].size;i++){
                        for(int j=0; j<s->n->pops[pidx].size; j++){
				s->n->pops[pidx].Wcross[i][j] /= max_wcross[pidx];
			}
		}
	}
	/* fill in the return struct */
 	runtime->in = in;
	runtime->sim = s;
	/* free the resources */
	free(cur_act);
	for(int i=0;i<s->n->nsize;i++)
		free(avg_act[i]);
	free(avg_act);
	free(sum_wcross);
	free(max_wcross);
	free(hwi);
	for(int i=0;i<pre_post_pair*num_shuffles(s->n->nsize, pre_post_pair); i++)
		free(sol[i]);
	free(sol);
	return runtime;
}

/* test network's capabilities to perform inference, 
   given one modality compute the other given the learned correlation */
outdata* test_inference(outdata* learning_runtime)
{
	double insample = 0.0f;
	int pre_pop = 0;
	int post_pop = 1;
	double tot_act = 0.0f;
	double *cur_act = (double*)calloc(learning_runtime->sim->n->pops[pre_pop].size, sizeof(double));
	double **avg_act = (double**)calloc(learning_runtime->sim->n->nsize, sizeof(double*));
	for(int i=0; i<learning_runtime->sim->n->nsize; i++)
		avg_act[i] = (double*)calloc(learning_runtime->sim->n->pops[pre_pop].size, sizeof(double));
	double sum_spref_act = 0.0f;
	double sum_act = 0.0f;
	double sum_conv = 0.0f;
	/* reinit activations for new test scenario */
	outdata* test_data = (outdata*)calloc(1, sizeof(outdata));
	/* decoder utils */
	double max_post_act = 0.0f;
        int max_act_idx = 0;
	double x_n = 0.0f;
        double discr_factor = 0.0f;
	double limL = 0.0f, limH = 0.0f;
	int idL = 0, idH = 0;
	double tol = 0.0f;

        for(int didx = 0; didx < learning_runtime->in->len; didx++){
   	    /* use the learned sensory elicited synaptic weights and compute activation for first population */
	    /* infer from first population the value in the second */
        	      learning_runtime->sim->n->pops[pre_pop].a = (double*)calloc(learning_runtime->sim->n->pops[pre_pop].size, sizeof(double));
		      learning_runtime->sim->n->pops[post_pop].a = (double*)calloc(learning_runtime->sim->n->pops[post_pop].size, sizeof(double));
        	      tot_act = 0.0f;
		      cur_act = (double*)calloc(learning_runtime->sim->n->pops[pre_pop].size, sizeof(double));
		      sum_spref_act = 0.0f;
		      sum_act = 0.0f;
                      insample = learning_runtime->in->data[didx][pre_pop];
                      /* loop through neurons in current population */
                      for(int nidx = 0; nidx<learning_runtime->sim->n->pops[pre_pop].size;nidx++){
                              /* compute sensory elicited activation */
                              cur_act[nidx] = (1/(sqrt(2*M_PI)*learning_runtime->sim->n->pops[pre_pop].s[nidx]))*
                                             exp(-pow((insample - learning_runtime->sim->n->pops[pre_pop].Winput[nidx]),2)/
						(2*pow(learning_runtime->sim->n->pops[pre_pop].s[nidx], 2)));
                      }
		      /* normalize the activity vector of the presynaptic population */
                      for(int snid = 0; snid<learning_runtime->sim->n->pops[pre_pop].size; snid++)
                              tot_act += cur_act[snid];
		      for(int snid = 0; snid<learning_runtime->sim->n->pops[pre_pop].size; snid++)
	                      cur_act[snid] /= tot_act;
		      /* update the activity for next iteration */
                      for(int nidx = 0; nidx<learning_runtime->sim->n->pops[pre_pop].size;nidx++){
                              learning_runtime->sim->n->pops[pre_pop].a[nidx] = (1-learning_runtime->sim->eta[learning_runtime->sim->tf_lrn_cross-1])*
										 learning_runtime->sim->n->pops[pre_pop].a[nidx] + 
									         learning_runtime->sim->eta[learning_runtime->sim->tf_lrn_cross-1]*cur_act[nidx];
		     }
		     /* compute the mapping from the input activity through the Hebbian matrix to infer the paired activity */
		     for(int i=0;i<learning_runtime->sim->n->pops[post_pop].size;i++){
                        for(int j=0; j<learning_runtime->sim->n->pops[post_pop].size; j++){
			     learning_runtime->sim->n->pops[post_pop].a[i] += (learning_runtime->sim->n->pops[post_pop].Wcross[i][j]*learning_runtime->sim->n->pops[pre_pop].a[j]);
			}
		     } 
		     for(int i=0;i<learning_runtime->sim->n->pops[post_pop].size;i++){
			if(learning_runtime->sim->n->pops[post_pop].a[i]<0.0f) learning_runtime->sim->n->pops[post_pop].a[i] = 0.0f;
		     }
		     /* decoding procedure */
		     /* find max activation in the mapped activation useful in extracting a first guess of the decoded value in the diustance optimizer */
		     max_post_act = 0;
		     max_act_idx = 0;
		     for(int i=0; i<learning_runtime->sim->n->pops[post_pop].size;i++){
		 	if(learning_runtime->sim->n->pops[post_pop].a[i] > max_post_act){
				max_post_act = learning_runtime->sim->n->pops[post_pop].a[i];
				max_act_idx = i;
			}
		     }
		    switch(DECODER){
		      case NAIVE:
                	/* analytically extract the scalar value from the activity profile */
			x_n = 0.0;
			discr_factor = sqrt(-2*pow(learning_runtime->sim->n->pops[post_pop].s[max_act_idx], 2) * 
					      log(max_post_act*sqrt(2*M_PI)*learning_runtime->sim->n->pops[post_pop].s[max_act_idx]));
			if(max_act_idx > learning_runtime->sim->n->pops[post_pop].size/2)
				x_n = learning_runtime->sim->n->pops[post_pop].Winput[max_act_idx] + discr_factor;
			else
				x_n = learning_runtime->sim->n->pops[post_pop].Winput[max_act_idx] - discr_factor;

		   	/* recover the value --> decoding using naive approach */
		   	learning_runtime->in->data[didx][post_pop] = x_n;
		       break;
		       case OPTIMIZER:
				/* recover the value --> decoding using optimizer  */
				if(max_act_idx == 0) idL = 0;
				else idL = max_act_idx - 1;
				if(max_act_idx == learning_runtime->sim->n->pops[post_pop].size) idH = learning_runtime->sim->n->pops[post_pop].size;
				else idH = max_act_idx + 1;
				limL = learning_runtime->sim->n->pops[post_pop].Winput[idL];
				limH = learning_runtime->sim->n->pops[post_pop].Winput[idH];
				tol= 1.0e-6; // tol = (1e-6)*fabs(limL + limH)/2.0;		
		   		learning_runtime->in->data[didx][post_pop] = decode_population(learning_runtime->sim->n, limL, limH, tol,  pre_pop, post_pop);
	               break;	
		      }
	    
	 }/* end for each sample in the dataset */

	 /* fill in the return struct */
        test_data->in = learning_runtime->in;
        test_data->sim = learning_runtime->sim;
	/* clear allocated resources */
	free(cur_act);
	for(int i = 0;i<learning_runtime->sim->n->nsize; i++)
		free(avg_act[i]);
	free(avg_act);
	return test_data;
}

/* test network's fault tolerance capabilities, 
   given one strongly perturbed modality compute the correct value given 
   the learned correlation and the other correct modality */
outdata* test_fault_tolerance(outdata* learning_runtime)
{
	outdata* test_data = (outdata*)calloc(1, sizeof(outdata));

	 /* fill in the return struct */
        test_data->in = learning_runtime->in;
        test_data->sim = learning_runtime->sim;

	return test_data;
}

/* destroy the simulation */
void deinit_simulation(simulation* s)
{
	free(s->alpha);
	free(s->sigma);	
	free(s->eta);
	free(s->xi);
	deinit_network(s->n);
}

/* dump the runtime data to file on disk */
char* dump_runtime_data(outdata *od)
{
	time_t rawt; time(&rawt);
        struct tm* tinfo = localtime(&rawt);
        FILE* fout;
        char* nfout = (char*)calloc(400, sizeof(char));
        char simparams[200];

        strftime(nfout, 150, "%Y-%m-%d__%H:%M:%S", tinfo);
        strcat(nfout, "_cln_runtime_data_");
        sprintf(simparams, "%d_epochs_%d_populations_%d_neurons",
                           od->sim->max_epochs,
                           od->sim->n->nsize,
                           od->sim->n->pops[od->sim->n->nsize-1].size);
        strcat(nfout, simparams);

        if((fout = fopen(nfout, "wb"))==NULL){
                printf("dump_runtime_data: Cannot create output file.\n");
                return NULL;
        }
        fwrite(od, sizeof(outdata), 1, fout);
        fclose(fout);
        return nfout;
}

/* dump the runtime data to file on disk - explicit sequential write */
char* dump_runtime_data_extended(outdata *od, int format)
{
	time_t rawt; time(&rawt);
        struct tm* tinfo = localtime(&rawt);
        FILE* fout;
        char* nfout = (char*)calloc(400, sizeof(char));
        char simparams[200];
	
        strftime(nfout, 150, "%Y-%m-%d__%H:%M:%S", tinfo);
	switch(format){
		case TESTS:
			strcat(nfout, "_cln_extended_runtime_data_tests_");
		break;
		case EXT_TESTS:
			strcat(nfout, "_cln_extended_runtime_data_extended_tests_");
		break;
		case BASIC:
			strcat(nfout, "_cln_extended_runtime_data_");
		break;
	}
	sprintf(simparams, "%d_epochs_%d_populations_%d_neurons",
                           od->sim->max_epochs,
                           od->sim->n->nsize,
                           od->sim->n->pops[od->sim->n->nsize-1].size);
        strcat(nfout, simparams);

        if((fout = fopen(nfout, "wb"))==NULL){
                printf("dump_runtime_data: Cannot create output file.\n");
                return NULL;
        }
	/* in order ot read the data in Matlab write explicitly every field */
        /* simulation data */
	fwrite(&(od->sim->max_epochs), sizeof(int), 1, fout);
	fwrite(&(od->sim->t0), sizeof(int), 1, fout);
	fwrite(&(od->sim->tf_lrn_in), sizeof(int), 1, fout);
	fwrite(&(od->sim->tf_lrn_cross), sizeof(int), 1, fout);
	for(int i = 0; i<od->sim->tf_lrn_in; i++)
		fwrite(&(od->sim->alpha[i]), sizeof(double), 1, fout);
	for(int i = 0; i<od->sim->tf_lrn_in; i++)
		fwrite(&(od->sim->sigma[i]), sizeof(double), 1, fout);
	for(int i = 0; i<od->sim->tf_lrn_cross; i++)
		fwrite(&(od->sim->eta[i]), sizeof(double), 1, fout);
	for(int i = 0; i<od->sim->tf_lrn_cross; i++)
		fwrite(&(od->sim->xi[i]), sizeof(double), 1, fout);
	/* network data */
	fwrite(&(od->sim->n->nsize), sizeof(short), 1, fout);
	for(int pidx = 0; pidx<od->sim->n->nsize;pidx++){
		fwrite(&(od->sim->n->pops[pidx].id), sizeof(short), 1, fout);
		fwrite(&(od->sim->n->pops[pidx].size), sizeof(int), 1, fout);
		for(int i=0; i<od->sim->n->pops[pidx].size;i++){
			fwrite(&(od->sim->n->pops[pidx].Winput[i]), sizeof(double), 1, fout);
			for(int j = 0;j < od->sim->n->pops[pidx].size; j++){
				fwrite(&(od->sim->n->pops[pidx].Wcross[i][j]), sizeof(double), 1, fout);
			}
			fwrite(&(od->sim->n->pops[pidx].s[i]), sizeof(double), 1, fout);
			fwrite(&(od->sim->n->pops[pidx].a[i]), sizeof(double), 1, fout);
		}
	}
	/* input data */
	fwrite(&(od->in->npop), sizeof(int), 1, fout);
	fwrite(&(od->in->popsize), sizeof(int), 1, fout);
	fwrite(&(od->in->len), sizeof(int), 1, fout);
	for(int i=0;i<od->in->len;i++){
		for(int j=0;j<od->in->npop;j++){
			fwrite(&(od->in->data[i][j]), sizeof(double), 1, fout);	
		}
	}
        fclose(fout);
        return nfout;
}

