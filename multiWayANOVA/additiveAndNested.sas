DATA glucose;
	INPUT A $ B $ outcome;
	DATALINES;
	1 1 46.5
	1 2 138.4
	1 3 180.9	
	2 1 39.8
	2 2 132.4
	2 3 176.8
	1 1 47.3
	1 2 144.4
	1 3 180.5	
	2 1 40.3
	2 2 132.4
	2 3 173.6
	1 1 46.9
	1 2 142.7
	1 3 183	
	2 1 41.2
	2 2 130.3
	2 3 174.9
	;
RUN;

PROC GLM;
	CLASS A B;
	MODEL outcome = A B;
RUN;