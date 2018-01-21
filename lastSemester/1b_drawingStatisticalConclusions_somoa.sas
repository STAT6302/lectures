DATA somoa;
	INPUT fired age @@;*fired = 1, not fired = 0;
    DATALINES;
1 34 1 37 1 37 1 38 1 41 1 42 1 43 1 44 1 44 1 45 1 45 1 45 1 46 1 48 1 49 1 53 1 53 1 54 1 54 1 55 1 56 1 57 1 60
0 27 0 33 0 36 0 37 0 38 0 38 0 39 0 42 0 42 0 43 0 43 0 44 0 44 0 44 0 45 0 45 0 45 0 45 0 46 0 46 0 47 0 47 0 48 0 48 0 49 0 49 0 51 0 51 0 52 0 54
;

* First, let's look at histograms of the two groups for part a.;
PROC UNIVARIATE DATA = somoa;
  CLASS fired;
  HISTOGRAM age / nrows=2 odstitle='age by fired status';
  ODS SELECT histogram; /* display on the histograms */
RUN;

* To get the observed difference;
ODS GRAPHICS OFF;
ODS EXCLUDE ALL; 
ODS OUTPUT confLimits=observedDifference;
PROC TTEST DATA=somoa;
	CLASS fired;
	VAR age;
RUN;
DATA _NULL_;
	SET observedDifference;
	IF method = "Pooled" THEN CALL SYMPUT('observedDifference',mean);
RUN;

/* This next section re-randomizes the data into fictional fired/extrinsic groups (as in Display 1.7)
     User needs to choose how many re-randomizations.  Currently: 1000 */
PROC IML;
	USE somoa;
	READ ALL VAR{fired age} INTO x;
	p = t(ranperm(x[,2],1000));    *Note that the "1000" here is the number of permutations. ;
	paf = x[,1]||p;
	CREATE permutedData FROM paf;
	APPEND FROM paf;
QUIT;

/* This next section calculates the differences in these re-randomized fictional groups.
   These differences are saved to the dataset "randomizedDifferences" */
ODS GRAPHICS OFF;
ODS EXCLUDE ALL; 
ODS OUTPUT confLimits=diff;
PROC TTEST data=permutedData plots=none;
  class col1;
  var col2 - col1001;
run;
DATA randomizedDifferences;
	SET diff; 
	IF method = "Pooled";
	differencesInMean = mean;
	KEEP differencesInMean;
RUN;

/* Let's create a histogram of the re-randomized differences in means in "randomizedDifferences"*/
ODS GRAPHICS ON;
ODS EXCLUDE NONE; 
PROC UNIVARIATE DATA=randomizedDifferences;
  VAR differencesInMean;
  HISTOGRAM differencesInMean;
RUN;

/*  Is our calculated observed difference from the somoa data extreme relative to the 
    re-randomized data?
    
    This next section finds what fraction of the re-randomized differences in "randomizedDifferences"
    are at least as extreme as the observedDifference.  This fraction is the p-value!
    
    ** Note ** that the code is set up to detect "at least as extreme" as meaning larger in magnitude
*/

DATA numdiffs;
	SET randomizedDifferences;
	observedDifference = &observedDifference;
	IF abs(differencesInMean) >= abs(observedDifference) THEN indicator = 1;
	IF abs(differencesInMean) < abs(observedDifference) THEN indicator = 0;
RUN;
title "The P-value is the 'mean'";
PROC MEANS DATA = numdiffs;
	VAR indicator;
RUN;

/* This last section is optional and just allows us to see which particular re-randomizations
   led to larger magnitude differences than the observed difference */
title "Extreme re-randomization differences";
PROC PRINT data = numdiffs;
	WHERE indicator = 1;
RUN;

*Idea from http://sas-and-r.blogspot.com/2011/10/example-912-simpler-ways-to-carry-out.html ;