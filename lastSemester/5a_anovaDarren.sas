DATA spock;
      INPUT percFemale judge $;
      DATALINES;
06.4 S 
08.7 S 
13.3 S
13.6 S 
15.0 S
15.2 S
17.7 S
18.6 S
23.1 S
16.8 A
30.8 A
33.6 A
40.5 A
48.9 A
27.0 B
28.9 B
32.0 B
32.7 B
35.5 B
45.6 B
21.0 C
23.4 C
27.5 C
27.5 C
30.5 C
31.9 C
32.5 C
33.8 C
33.8 C
24.3 D
29.7 D
17.7 E
19.7 E
21.5 E
27.9 E
34.8 E
40.2 E
16.5 F
20.7 F
23.5 F
26.4 F
26.7 F
29.5 F
29.8 F
31.9 F
36.2 F
;
/*
The variable Judge contains the treatment levels, and the variable percFemale contains the response. The following statements produce the analysis.
*/
PROC GLM DATA = spock ORDER=DATA;
      CLASS judge;
      MODEL percFemale = judge;
      ESTIMATE 'Estimate Spock judge to F judge' judge 1 0 0 0 0 0 -1;
RUN;

DATA spockVsF;
	SET spock;
	if (judge NE 'S') & (judge NE 'F')  THEN DELETE;
RUN;

PROC TTEST DATA = spockVsF ORDER=DATA;
	CLASS judge;
	VAR percFemale;
RUN;

/* Class Example */
DATA pval;
	pval = 1-CDF('F',54.75,3-1,9-3);
RUN;

PROC PRINT DATA = pval;

DATA example;
	INPUT score treatment $;
	DATALINES;
3  P
5  P
7  P
10 1
12 1
14 1
20 2
22 2
24 2
;
RUN;

PROC GLM DATA = example;
	CLASS treatment;
	MODEL score = treatment;
RUN;


/* Back to Spock Example */
PROC GLM DATA = spock ORDER=DATA;
      CLASS judge;
      MODEL percFemale = judge;
RUN;

PROC SORT DATA = spock;
	BY judge;
RUN;
PROC UNIVARIATE DATA = spock;
	BY judge;
	VAR percFemale;
	QQPLOT / NORMAL(MU=EST SIGMA=EST L=2);
RUN;


PROC GLM DATA = spock ORDER=DATA PLOTS(UNPACK)=DIAGNOSTICS;
      CLASS judge;
      MODEL percFemale = judge;
RUN;
