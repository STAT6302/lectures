LIBNAME datalib "/courses/d630f9e5ba27fe300";

/* Start create missing data */
PROC PRINT DATA = datalib.carmpg;
RUN;

DATA datalib.carmpgMissing;
  SET datalib.carmpg;
  IF  hp <= 68 then cylinders = .;    
  IF  cylinders = 8 THEN hp = .;
  IF  weight > 3.9 then accel = .;  
RUN;

PROC PRINT DATA = datalib.carmpgMissing;
RUN;

/* End create missing data */
DATA mpg;
	SET datalib.carmpgMissing;
RUN;


title "Scatter Matrix of Fuel Efficiency Data Set";
proc sgscatter data = mpg;
matrix MPG CYLINDERS SIZE WEIGHT HP ACCEL ENG_TYPE /
diagonal=(Histogram);
run;
title;

TITLE 'Missing Data Patterns';
ODS SELECT MISSPATTERN;
PROC MI DATA=mpg NIMPUTE=0;
	VAR MPG CYLINDERS WEIGHT HP ACCEL ENG_TYPE;
	RUN;
TITLE;
/*Multiple Imputation of data set. We will use the default number
of imputations of 25 */

TITLE 'Imputation of Missing Data';
PROC MI DATA = mpg OUT = miout seed = 15732;
	VAR MPG CYLINDERS WEIGHT HP ACCEL ENG_TYPE;
RUN;
TITLE;

/* Running PROC REG on each of the imputed data sets */

TITLE 'Regression Of Imputed Data Sets';
PROC REG DATA = miout OUTEST = outreg COVOUT;
	BY _Imputation_;
	MODEL MPG = CYLINDERS WEIGHT HP ACCEL ENG_TYPE;
RUN;
TITLE;

/*Using the results of each regression model above to generate
regression parameters*/
TITLE "Regression Parameter Estimates: Multiple Imputation";
PROC MIANALYZE DATA = outreg;
	MODELEFFECTS CYLINDERS WEIGHT HP ACCEL ENG_TYPE Intercept;
RUN;
TITLE;


TITLE "Regression Parameter Estimates: Listwise Deletion";
PROC REG DATA = mpg;
MODEL MPG = CYLINDERS WEIGHT ACCEL HP ENG_TYPE / CLB;
RUN;
TITLE;


/*Examining the means of the imputed data sets*/
PROC MEANS data = miout;
RUN;
