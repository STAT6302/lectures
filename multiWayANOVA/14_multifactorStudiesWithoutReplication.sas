DATA example1;
	INPUT fuel $ alloy $ height;
	DATALINES;
	F1 A1 131
	F1 A1 122
	F1 A1 134
	F1 A1 127
	;

PROC TTEST DATA = example1;
	VAR height;
RUN;


DATA example2;
	INPUT fuel $ alloy $ height;
	DATALINES;
	F1 A1 131
	F1 A1 122
	F2 A2 112
	F2 A2 117
	;

PROC TTEST DATA = example2;
	CLASS fuel;
	VAR height;
RUN;

PROC GLM DATA=example2 PLOTS=ALL;
	CLASS fuel alloy;
	MODEL height = fuel alloy(fuel);
RUN;


DATA example3;
	INPUT fuel $ alloy $ height;
	DATALINES;
	F1 A1 131
	F1 A1 122
	F2 A2 112
	F1 A2 117
	;

PROC GLM DATA=example3 PLOTS=ALL;
	CLASS fuel alloy;
	MODEL height = fuel alloy;
RUN;

PROC GLM DATA=example3 PLOTS=ALL;
	CLASS fuel alloy;
	MODEL height = fuel alloy fuel*alloy;
RUN;

DATA example4;
	INPUT fuel $ alloy $ height;
	DATALINES;
	F1 A1 131
	F1 A2 122
	F2 A1 112
	F2 A2 117
	;

PROC GLM DATA=example4 PLOTS=ALL;
	CLASS fuel alloy;
	MODEL height = fuel alloy;
RUN;

PROC GLM DATA=example4 PLOTS=ALL;
	CLASS fuel alloy;
	MODEL height = fuel alloy fuel*alloy;
RUN;


/* example about blocking for weather.
     - note I did not present this in class */
DATA example5;
	INPUT weather $ fuel $ alloy $ height;
	DATALINES;
	rain F1 A1 121
	rain F1 A2 112
	rain F2 A1 102
	rain F2 A2 107
	clear F1 A1 131
	clear F1 A2 122
	clear F2 A1 112
	clear F2 A2 117
	;

PROC GLM DATA=example5;
	CLASS fuel alloy;
	MODEL height = fuel alloy;
RUN;

PROC GLM DATA=example5;
	CLASS weather fuel alloy;
	MODEL height = weather fuel alloy;
RUN;

PROC GLM DATA=example5;
	CLASS fuel alloy;
	MODEL height = fuel alloy fuel*alloy;
RUN;

PROC GLM DATA=example5 PLOTS=all;
	CLASS weather fuel alloy;
	MODEL height = weather fuel alloy fuel*alloy;
RUN;


/* example “equivalence law of statistics”.

DATA height;
	INPUT height gender $ @@;
	DATALINES;
	63 F 61 F 67 F 69 F 58 F 63.5 F 62 F 69 M 72 M 71 M 73.5 M 71 M 67 M 70 M
	;

PROC UNIVARIATE;
	HISTOGRAM height;
RUN;

PROC SGPLOT;
	VBOX height;
RUN;

PROC SGPLOT;
	VBOX height / CATEGORY = gender;
RUN;