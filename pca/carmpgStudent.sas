LIBNAME datalib '/courses/d6426995ba27fe300';
PROC FACTOR DATA = datalib.carmpg
	PLOTS=scree;
RUN;

PROC FACTOR DATA = datalib.carmpg  NFACTORS=2
	PLOTS=initloadings
	OUT=out;
RUN;

PROC SGPLOT DATA = out;
	SCATTER x = Factor1 y = Factor2 / DATALABEL=auto GROUP=cylinders;
RUN;