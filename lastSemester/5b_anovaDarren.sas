/*
The variable Judge contains the treatment levels,
the variable percFemale contains the response. 
*/
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

/*extra sums of squares */
PROC GLM DATA = spock ORDER=DATA;
      CLASS judge;
      MODEL percFemale = judge;
      ESTIMATE 'Estimate Spock judge to F judge' judge -6 1 1 1 1 1 1 / DIVISOR = 6;
RUN;

DATA spock_AtoF;
	SET spock;
	IF judge = "S" THEN delete;
RUN;

PROC GLM DATA = spock_AtoF ORDER=DATA;
      CLASS judge;
      MODEL percFemale = judge;
RUN;

DATA spock2;
	SET spock;
	IF judge ne "S" THEN OthersModel = "Others";
	ELSE OthersModel = "S";
RUN;

PROC PRINT DATA = spock2;
RUN;

PROC GLM DATA = spock2;             /*Only running this to get the "Error" row for the Extra Sum of Squares Test.*/
	CLASS judge;                    /*Separate Means Model (Full 7 parameters)*/
	MODEL percFemale = judge;
RUN;

PROC GLM DATA = spock2;             /*Only running this to get the "Error" row for the Extra Sum of Squares Test.*/
	CLASS OthersModel;              /*Others Equal Model (Reduced (2 parameters) */
	MODEL percFemale = OthersModel;
RUN;
