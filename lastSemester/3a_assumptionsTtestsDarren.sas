DATA creativity;
	INPUT intrinsic score @@;*intrinsic = 1, extrinsic = 0;
    DATALINES;
1 12.0 1 12.0 1 12.9 1 13.6 1 16.6 1 17.2 1 17.5 1 18.2 1 19.1 1 19.3 1 19.8 1 20.3 1 20.5 1 20.6 1 21.3 1 21.6 1 22.1 1 22.2 1 22.6 1 23.1 1 24.0 1 24.3 1 26.7 1 29.7
0 5.0 0 5.4 0 6.1 0 10.9 0 11.8 0 12.0 0 12.3 0 14.8 0 15.0 0 16.8 0 17.2 0 17.2 0 17.4 0 17.5 0 18.5 0 18.7 0 18.7 0 19.2 0 19.5 0 20.7 0 21.2 0 22.1 0 24
;

/* Two-sided T-test using proc ttest */
PROC TTEST DATA=creativity ORDER=DATA SIDES=2;
	CLASS intrinsic;
	VAR SCORE;
RUN;

/* Get probabilities */
DATA prob;
	pval = 2*(1-CDF('T',4.1442/1.4164,45));
RUN;	

PROC PRINT DATA=prob;
RUN;

/* T-test using proc ttest */
PROC TTEST DATA=creativity ORDER=DATA SIDES=2 ALPHA = 0.005366587;
	CLASS intrinsic;
	VAR SCORE;
RUN;

