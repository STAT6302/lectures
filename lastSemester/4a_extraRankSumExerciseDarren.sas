/* 
The variable Freq contains the frequency of the observation, which is the number of patients with the Treatment and Response combination.
*/
data Arthritis;
      input Treatment $ Response Freq @@;
      datalines;
Active 5 5 Active 4 11 Active 3 5 Active 2 1 Active 1 5 
Placebo 5 2 Placebo 4 4 Placebo 3 7 Placebo 2 7 Placebo 1 12 
;

proc npar1way data=Arthritis wilcoxon;
      class Treatment;
      var Response;
      freq Freq;
      exact HL;
run;