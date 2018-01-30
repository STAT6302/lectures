DATA modelCheck;
	INPUT x Y condition $ @@;
	DATALINES;
	1 3 include 1 3 include 2 3.5 include 2 3.5 include
	3 3.9 include 3 3.9 include 4 4.25 include 4 4.25 include 30 50 include
	1 3 exclude 1 3 exclude 2 3.5 exclude 2 3.5 exclude
	3 3.9 exclude 3 3.9 exclude 4 4.25 exclude 4 4.25 exclude
	;
RUN;

PROC GLM DATA = modelCheck PLOTS=all;
	WHERE condition = "exclude";
	MODEL Y = x; 
RUN;

PROC GLM DATA = modelCheck PLOTS=all;
	WHERE condition = "include";
	MODEL Y = x;
RUN;

symbol1 C=red V=circle i=r H=0.8;
symbol2 C=blue V=plus  i=r H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA = modelCheck;
	PLOT Y*x=condition / VAXIS=axis1 HAXIS=axis2;

PROC REG DATA = modelCheck PLOTS=dfbetas;
	WHERE condition = "exclude";
	MODEL Y = x; 
RUN;

PROC REG DATA = modelCheck PLOTS=dfbetas;
	WHERE condition = "include";
	MODEL Y = x;
RUN;


