#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <time.h>

/* sort generated data vector */
void sort_input_data(int n, double *ra);
/* shuffle generated data vector -> Fisher-Yates shuffler */
void shuffle_input_data(double *in, int size);
/* swap data points */
void swap_data_points(double *in1, double *in2);
