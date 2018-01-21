DATA creativity;
	INPUT intrinsic score @@;*intrinsic = 1, extrinsic = 0;
    DATALINES;
1 12.0 1 12.0 1 12.9 1 13.6 1 16.6 1 17.2 1 17.5 1 18.2 1 19.1 1 19.3 1 19.8 1 20.3 1 20.5 1 20.6 1 21.3 1 21.6 1 22.1 1 22.2 1 22.6 1 23.1 1 24.0 1 24.3 1 26.7 1 29.7
0 5.0 0 5.4 0 6.1 0 10.9 0 11.8 0 12.0 0 12.3 0 14.8 0 15.0 0 16.8 0 17.2 0 17.2 0 17.4 0 17.5 0 18.5 0 18.7 0 18.7 0 19.2 0 19.5 0 20.7 0 21.2 0 22.1 0 24
;

* To get the observed difference;
ODS GRAPHICS OFF;
ODS EXCLUDE ALL; 
ODS OUTPUT confLimits=observedDifference;
PROC TTEST DATA=creativity;
	CLASS intrinsic;
	VAR SCORE;
RUN;
DATA _NULL_;
	SET observedDifference;
	IF method = "Pooled" THEN CALL SYMPUT('observedDifference',mean);
RUN;

/* This next section re-randomizes the data into fictional intrinsic/extrinsic groups (as in Display 1.7)
     User needs to choose how many re-randomizations.  Currently: 1000 */
PROC IML;
	USE creativity;
	READ ALL VAR{intrinsic score} INTO x;
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
RUN;
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

/*  Is our calculated observed difference from the creativity data extreme relative to the 
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