DATA example;
	INPUT block treatment F N Y1 Y2;
	DATALINES;
1 0 86 100 21.3 39.5
1 1 98 100 10.0 30.3
2 0 48 100 19.7 32.6
2 1 93 100 22.0 33.6
3 0 87 100 20.2 32.1
3 1 43 100 17.6 38.8
4 0 64 100 20.0 41.9
4 1 89 100 16.0 35.1
5 0 99 100 17.4 29.1
5 1 100 100 20.3 34.1
6 0 52 100 26.0 42.9
6 1 49 100 25.6 31.8
7 0 89 100 19.7 40.8
7 1 96 100 16.2 28.2
8 0 63 100 18.5 40.9
8 1 98 100 12.4 38.1
9 0 48 100 20.9 39.5
9 1 83 100 13.5 34.7
10 0 85 100 23.0 42.0
10 1 97 100 23.2 32.8
;

PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL *SPECIFY FIXED EFFECTS* / DDFM=KENWARDROGER;
	RANDOM 	*DEFINE A RANDOM EFFECT (EITHER G OR R SIDE)* / TYPE = *COVARIANCE*;
RUN;


TITLE 'conditional model';
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y1 = treatment;
	RANDOM 	block;
RUN;


TITLE 'conditional model: output X and Z';
PROC GLIMMIX DATA = example outdesign=matrix;
	CLASS treatment block;
	MODEL Y1 = treatment / DDFM=KENWARDROGER;
	RANDOM 	block;
RUN;

PROC PRINT DATA=matrix;
RUN;

TITLE 'conditional model: output X and Z';
PROC GLIMMIX DATA = example outdesign=matrix;
	CLASS treatment block;
	MODEL Y1 = treatment / DDFM=KENWARDROGER;
	RANDOM 	intercept / SUBJECT = block TYPE = VC;
RUN;

PROC PRINT DATA=matrix;
RUN;

TITLE ‘conditional model’;
PROC GLIMMIX DATA = example outdesign=matrix;
	CLASS treatment block;
	MODEL Y1 = treatment / DDFM=KENWARDROGER;
	RANDOM 	block / TYPE = VC;
RUN;

PROC PRINT DATA=matrix;
RUN;

TITLE ‘conditional model’;
PROC GLIMMIX DATA = example outdesign=matrix;
	CLASS treatment block;
	MODEL Y1 = treatment / DDFM=KENWARDROGER;
	RANDOM 	_residual_ / TYPE = VC ;
	RANDOM 	intercept / SUBJECT = block TYPE = VC;
RUN;

TITLE ‘conditional model: alternative coding’;
PROC GLIMMIX DATA = example outdesign=matrix;
	CLASS treatment block;
	MODEL Y1 = treatment / DDFM=KENWARDROGER;
	RANDOM intercept / SUBJECT = block;
RUN;

TITLE ‘marginal model’;
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y1 = treatment;
	RANDOM 	_residual_ / TYPE = cs SUBJECT = block V;
RUN;

TITLE ‘marginal model: alternative coding’;
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y1 = treatment;
	RANDOM 	treatment / TYPE = cs SUBJECT = block V;
RUN;

/* Getting estimates of treatment effect */
TITLE 'conditional model';
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y1 = treatment;
	RANDOM 	block;
	LSMEANS treatment / adjust = TUKEY DIFF CL PLOTS=DIFF;
RUN;

/* When Conditional vs. Marginal Matter */

TITLE ‘conditional model’;
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y2 = treatment / DDFM=KENWARDROGER;
	RANDOM intercept / SUBJECT = block V;
RUN;

TITLE ‘marginal model’;
PROC GLIMMIX DATA = example;
	CLASS treatment block;
	MODEL Y2 = treatment;
	RANDOM 	_residual_ / TYPE = cs SUBJECT = block V;
RUN;

