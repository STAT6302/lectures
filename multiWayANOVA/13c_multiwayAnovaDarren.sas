DATA abrasive1; 
	INPUT site $ abrasive times;  
	DATALINES;
	site1 1 25 
	site1 1 29 
	site1 2 14 
	site1 2 11 
	site2 1 11 
	site2 1 6 
	site2 2 22 
	site2 2 18 
	site3 1 17 
	site3 1 20 
	site3 2 5 
	site3 2 2 
	;
RUN;
 
PROC GLMMOD DATA = abrasive1;
	CLASS site abrasive;
	MODEL times = site abrasive site*abrasive;
RUN;

PROC GLM DATA = abrasive1 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive site*abrasive;
RUN;

PROC GLMMOD DATA = abrasive1;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
RUN;

PROC GLM DATA = abrasive1 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
RUN;

PROC GLM DATA = abrasive1 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
	LSMEANS site abrasive(site) / PDIFF CL;
RUN;

PROC GLM DATA = abrasive1 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
	LSMEANS site abrasive(site) / PDIFF CL ADJUST=tukey;
RUN;

DATA abrasive2; 
	INPUT site $ abrasive times;  
	DATALINES;
	site1 1 25 
	site1 1 29 
	site1 2 14 
	site1 2 11 
	site2 3 11 
	site2 3 6 
	site2 4 22 
	site2 4 18 
	site3 5 17 
	site3 5 20 
	site3 6 5 
	site3 6 2 
	;
RUN;

PROC GLMMOD DATA = abrasive2;
	CLASS site abrasive;
	MODEL times = site abrasive;
RUN;

PROC GLMMOD DATA = abrasive1;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
RUN;

PROC GLM DATA = abrasive2 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive;
	LSMEANS site abrasive / PDIFF CL ADJUST=tukey;
RUN;

PROC GLM DATA = abrasive1 PLOTS = all;
	CLASS site abrasive;
	MODEL times = site abrasive(site);
	LSMEANS site abrasive(site) / PDIFF CL ADJUST=tukey;
RUN;


DATA mower; 
	INPUT manufac $ mower $ speed $ times;  
	DATALINES;
	site1 1 low  211
	site1 1 low  230
	site1 1 high 278
	site1 1 high 278
	site1 2 low  184
	site1 2 low  188
	site1 2 high 249
	site1 2 high 272
	site1 3 low  216
	site1 3 low  232
	site1 3 high 275
	site1 3 high 271
	site2 1 low  205
	site2 1 low  217
	site2 1 high 247
	site2 1 high 251
	site2 2 low  169
	site2 2 low  168
	site2 2 high 239
	site2 2 high 252
	site2 3 low  200
	site2 3 low  187
	site2 3 high 261
	site2 3 high 242	;
RUN;

PROC GLM DATA = mower PLOTS = all;
	CLASS manufac mower speed;
	MODEL times = manufac speed mower(manufac) manufac*speed;
	LSMEANS manufac speed mower(manufac) manufac*speed / PDIFF CL ADJUST=tukey;
RUN;
