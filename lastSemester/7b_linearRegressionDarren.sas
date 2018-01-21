LIBNAME datalib "/courses/d630f9e5ba27fe300";

DATA classExample (KEEP = total_rec_late_fee total_rec_int);
	SET datalib.loanDataFull;
	IF total_rec_late_fee = 0 THEN DELETE;
RUN;

*PROC SURVEYSELECT DATA=classExample METHOD=srs N=100 OUT=datalib.classExample;
*RUN;

PROC GPLOT DATA = datalib.classExample;
	PLOT total_rec_late_fee*total_rec_int;

PROC REG DATA = datalib.classExample;
	MODEL total_rec_late_fee = total_rec_int / CLB;
RUN;

DATA classExamplePred;
   INPUT total_rec_int @@;
   DATALINES;
110
;
DATA classExamplePred;
   SET datalib.classExample classExamplePred;

PROC REG DATA = classExamplePred;
	MODEL total_rec_late_fee = total_rec_int / CLI CLM;
RUN;
