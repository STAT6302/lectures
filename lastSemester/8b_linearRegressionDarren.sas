LIBNAME datalib "/courses/d630f9e5ba27fe300";

PROC IMPORT DATAFILE='/courses/d630f9e5ba27fe300/case0802.csv' DBMS=dlm OUT=voltage REPLACE;
	DELIMITER=',';
	GETNAMES=yes;
	GUESSINGROWS=10;
RUN;

DATA voltage;
	SET voltage;
	logTime = log(time);
RUN;

DATA prediction;
	INPUT voltage time logTime;
	DATALINES;	
	33 . .
	;

DATA voltage;
	SET prediction voltage;
RUN;	

PROC REG DATA = voltage;
	MODEL logTime = voltage;
RUN;

PROC GLM DATA = voltage;
	CLASS voltage;
	MODEL logTime = voltage;
RUN;

DATA pvalue;
	pvalue = 1-CDF('F',0.502,5,69);
RUN;

PROC PRINT DATA=pvalue;
RUN;

PROC REG DATA = voltage;
	MODEL logTime = voltage / CLB CLI CLM;
RUN;
