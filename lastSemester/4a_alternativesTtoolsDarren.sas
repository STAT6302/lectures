DATA cognitiveLoad;
	INPUT time treatment $ censored;
	DATALINES;
	68 Modified 0
	70 Modified 0
	73 Modified 0
	75 Modified 0
	77 Modified 0
	80 Modified 0
	80 Modified 0
	132 Modified 0
	148 Modified 0
	155 Modified 0
	183 Modified 0
	197 Modified 0
	206 Modified 0
	210 Modified 0
	130 Conventional 0
	139 Conventional 0
	146 Conventional 0
	150 Conventional 0
	161 Conventional 0
	177 Conventional 0
	228 Conventional 0
	242 Conventional 0
	265 Conventional 0
	300 Conventional 1
	300 Conventional 1
	300 Conventional 1
	300 Conventional 1
	300 Conventional 1
;
RUN;

DATA pvalue_nocc;
	pval = CDF('NORMAL',(137-203)/21.7013);
RUN;
PROC PRINT DATA = pvalue_nocc;

DATA pvalue_yescc;
	pval = CDF('NORMAL',(137.5-203)/21.7013);
RUN;
PROC PRINT DATA = pvalue_yescc;


PROC NPAR1WAY DATA = cognitiveLoad WILCOXON;
	CLASS treatment;
	VAR time;
	EXACT HL;
RUN;

/* Introduce Welch’s test */
DATA creativity;
	INPUT intrinsic score @@;*intrinsic = 1, extrinsic = 0;
    DATALINES;
1 12.0 1 12.0 1 12.9 1 13.6 1 16.6 1 17.2 1 17.5 1 18.2 1 19.1 1 19.3 1 19.8 1 20.3 1 20.5 1 20.6 1 21.3 1 21.6 1 22.1 1 22.2 1 22.6 1 23.1 1 24.0 1 24.3 1 26.7 1 29.7
0 5.0 0 5.4 0 6.1 0 10.9 0 11.8 0 12.0 0 12.3 0 14.8 0 15.0 0 16.8 0 17.2 0 17.2 0 17.4 0 17.5 0 18.5 0 18.7 0 18.7 0 19.2 0 19.5 0 20.7 0 21.2 0 22.1 0 24
;

/* Confidence interval using a PROC */
PROC TTEST DATA=creativity ALPHA = 0.01 ORDER=DATA;
	CLASS intrinsic;
	VAR SCORE;
RUN;

/* Logging example */
DATA logging;
	INPUT status $ percLost @@;
	DATALINES;
L 45 L 53.1 L 40.8 L 75.5 L 46.7 L 85.4 L 85.6 L 18.2 L 43.2
U 23.6 U 13.3 U 34.2 U 18.1 U 56.1 U -8.1 U -20.1
;

PROC TTEST DATA=logging;
	CLASS status;
	VAR percLost;
RUN;

PROC NPAR1WAY DATA = logging WILCOXON;
	CLASS status;
	VAR percLost;
	EXACT HL;
RUN;
