DATA creativity;
	INPUT intrinsic score @@;*intrinsic = 1, extrinsic = 0;
    DATALINES;
1 12.0 1 12.0 1 12.9 1 13.6 1 16.6 1 17.2 1 17.5 1 18.2 1 19.1 1 19.3 1 19.8 1 20.3 1 20.5 1 20.6 1 21.3 1 21.6 1 22.1 1 22.2 1 22.6 1 23.1 1 24.0 1 24.3 1 26.7 1 29.7
0 5.0 0 5.4 0 6.1 0 10.9 0 11.8 0 12.0 0 12.3 0 14.8 0 15.0 0 16.8 0 17.2 0 17.2 0 17.4 0 17.5 0 18.5 0 18.7 0 18.7 0 19.2 0 19.5 0 20.7 0 21.2 0 22.1 0 24
;


/* Confidence interval "by hand" */
*Get quantile;
DATA quant;
	t  = QUANTILE('T',1-0.01/2,45);
RUN;	
PROC PRINT DATA=quant;
RUN;
*Get sample standard deviations, means, and sample sizes;
PROC SORT DATA = creativity OUT=creativitySort;
	BY intrinsic;
RUN;
PROC UNIVARIATE data = creativitySort;
	BY intrinsic;
RUN;

/* Confidence interval using a PROC */
PROC TTEST DATA=creativity ALPHA = 0.01 ORDER=DATA;
	CLASS intrinsic;
	VAR SCORE;
RUN;

/* T-test using proc ttest */
PROC TTEST DATA=creativity ORDER=DATA;
	CLASS intrinsic;
	VAR SCORE;
RUN;


DATA density;
  DO t = -4 TO 4 BY .001;
    density = PDF("T", t, 45);
    lower = 0;
    upper = 0;
    IF t <= -2.93 THEN upper = density;
    IF t >= 2.93 THEN upper = density;
    OUTPUT;
  END;
RUN;

*TITLE 'T probability density function';
PROC SGPLOT DATA=density NOAUTOLEGEND NOBORDER;
  YAXIS DISPLAY=none;
  BAND X = t LOWER = lower UPPER = upper / FILLATTRS=(COLOR=gray8a);
  SERIES X = t Y = density / LINEATTRS= (COLOR = black);
  SERIES X = t Y = lower / LINEATTRS = (COLOR = black);
RUN;

/* Get probabilities */
DATA prob;
	p = 2*(1-CDF('T',2.93,45));
RUN;	

PROC PRINT DATA=prob;
RUN;

