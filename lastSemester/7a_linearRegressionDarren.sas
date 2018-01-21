DATA handicap;
      INPUT score handicap $ @@; 
      DATALINES;
1.9 None 2.5 None 3.0 None 3.6 None 4.1 None 4.2 None 4.9 None
5.1 None 5.4 None 5.9 None 6.1 None 6.7 None 7.4 None 7.8 None
1.9 Amp  2.5 Amp  2.6 Amp  3.2 Amp  3.6 Amp  3.8 Amp  4.0 Amp
4.6 Amp  5.3 Amp  5.5 Amp  5.8 Amp  5.9 Amp  6.1 Amp  7.2 Amp
3.7 Crut 4.0 Crut 4.3 Crut 4.3 Crut 5.1 Crut 5.8 Crut 6.0 Crut
6.2 Crut 6.3 Crut 6.4 Crut 7.4 Crut 7.4 Crut 7.5 Crut 8.5 Crut
1.4 Hear 2.1 Hear 2.4 Hear 2.9 Hear 3.4 Hear 3.7 Hear 3.9 Hear
4.2 Hear 4.3 Hear 4.7 Hear 5.5 Hear 5.8 Hear 5.9 Hear 6.5 Hear
1.7 Whee 2.8 Whee 3.5 Whee 4.7 Whee 4.8 Whee 5.0 Whee 5.3 Whee
6.1 Whee 6.1 Whee 6.2 Whee 6.4 Whee 7.2 Whee 7.4 Whee 7.6 Whee
;

/* second QOI */
PROC TTEST DATA = handicap ORDER = DATA;
	WHERE handicap = ‘None’ | handicap = ‘Amp’;
	CLASS handicap;
	VAR score;
RUN;

PROC GLM DATA = handicap ORDER=DATA;
	CLASS handicap;
	MODEL score = handicap;
	CONTRAST 'Amp vs. None Contrast' handicap 1 -1 0 0 0;
	ESTIMATE 'Amp vs. None Estimate' handicap 1 -1 0 0 0;
RUN;

/* Third QOI */
PROC GLM DATA = handicap ORDER=DATA;
	CLASS handicap;
	MODEL score = handicap;
	LSMEANS handicap / pdiff;
RUN;

/* Fourth QOI */
PROC GLM DATA = handicap ORDER=DATA;
	CLASS handicap;
	MODEL score = handicap;
	LSMEANS handicap / pdiff ADJUST = DUNNETT CL;
RUN;

