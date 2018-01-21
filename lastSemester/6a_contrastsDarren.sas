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

ods graphics on;
PROC GLM DATA = handicap ORDER=DATA PLOTS=diagnostics;
      CLASS handicap;
      MODEL score = handicap;
RUN;
ods graphics off;

PROC GLM DATA = handicap ORDER=DATA;
      CLASS handicap;
      MODEL score = handicap / ALPHA = 0.01 CLPARM;
      MEANS handicap;
      CONTRAST 'Avg. Amp & Hear vs Avg Crutch & Wheel' handicap 0 1 -1 1 -1;
      ESTIMATE 'Avg. Amp & Hear vs Avg Crutch & Wheel' handicap 0 1 -1 1 -1 / DIVISOR = 2;
      ESTIMATE 'Sum Amp & Hear vs Sum Crutch & Wheel' handicap 0 1 -1 1 -1;
RUN;


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

DATA spock2;
	SET spock;
	IF judge ne 'S' THEN OthersModel = 'Others';
	ELSE OthersModel = 'S';
RUN;

PROC GLM DATA = spock2;
	CLASS OthersModel;
	MODEL percFemale = OthersModel;
RUN;

PROC GLM DATA = spock ORDER=DATA;
      CLASS judge;
      MODEL percFemale = judge / ALPHA = 0.01 CLPARM;
      CONTRAST 'Contrast Spock judge to A-F judge' judge -6 1 1 1 1 1 1;
      ESTIMATE 'Estimate Spock judge to A-F judge' judge -6 1 1 1 1 1 1 / DIVISOR = 6;
RUN;

