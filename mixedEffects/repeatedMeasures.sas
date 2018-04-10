DATA example2long;                                                                                                                          
 INPUT  Subject Time Score;
 DATAlines;
1 1 45
2 1 42
3 1 36
4 1 39
5 1 51
6 1 44
1 2 50
2 2 42
3 2 41
4 2 35
5 2 55
6 2 49
1 3 55
2 3 45
3 3 43
4 3 40
5 3 59
6 3 56
;
RUN;

PROC GLM DATA=example2long;
	CLASS Subject Time;                                                                                                                
	MODEL Score = Time / SOLUTION;
	OUTPUT OUT = glmout r=resid;
RUN; 
PROC PRINT DATA=glmout;
        
 /* re-organize the residuals (to unstacked DATA for correlation) */                                                                    
                                                                                                                                        
DATA one; 
	SET glmout; 
	WHERE time=1; 
	time1=resid; 
	KEEP time1;                                                         
DATA two; 
	SET glmout; 
	WHERE time=2; 
	time2=resid; 
	KEEP time2;                                                             
DATA three; 
	SET glmout; 
	WHERE time=3; 
	time3=resid; 
	KEEP time3;                                                      
DATA corrcheck; 
	MERGE one two three; 
RUN;                                                                                              
PROC print DATA=corrcheck;
RUN;

PROC corr DATA=corrcheck cov nosimple; 
	VAR time1 time2 time3; 
RUN;                                                                     
                                                                                                                                        
PROC GLIMMIX DATA=example2long;
	CLASS Subject Time;
	MODEL Score=Time / ddfm=kr;
	RANDOM _residual_ / TYPE=UN V Subject=Subject;
RUN; 

PROC GLIMMIX DATA=example2long;
	CLASS Subject Time;
	MODEL Score=Time / ddfm=kr;
	RANDOM _residual_ / TYPE=CS V Subject=Subject;
RUN; 

PROC GLIMMIX DATA=example2long;
	CLASS Subject Time;
	MODEL Score=Time / ddfm=kr;
	RANDOM _residual_ / TYPE=AR(1) V Subject=Subject;
RUN; 
