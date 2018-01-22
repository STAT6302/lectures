DATA housing;
	INPUT salePrice sqFootage nBedrooms nBathrooms zipcode $;
	DATALINES;
2250000 6572 4 6 75225
2650000 6881 5 6 75225 
1025000 3732 4 3 75225
 900000 2101 3 3 75225
1200000 3512 3 4 75225
3790000 6250 5 8 75225
2550000 5996 4 6 75225
2300000 5937 5 6 75225
1395000 3845 4 5 75225
4300000 7715 5 8 75225
1000000 2672 2 3 75225
2499000 5119 5 6 75225
2495000 6521 5 6 75225
 998000 3933 4 5 75225
2895000 6183 5 8 75225
 239000 1788 3 3 75224
 210000 1176 3 2 75224 
 210000 1823 3 2 75224
 160000 1572 3 2 75224
 330000 2278 4 2 75224
 132000 1379 3 2 75224
 139000  857 2 2 75224
 259000 1658 4 2 75224
 170000 1879 4 2 75224
 340000 2540 4 3 75224
 384900 3948 5 3 75224
 250000 1426 3 2 75224
 130000 1338 3 1 75224
 119000  757 2 1 75224
;

PROC SORT DATA = housing;
	BY zipcode;
RUN;

DATA housing;
	SET housing;
	IF zipCode = 75224 THEN zipCode_ind = 0;
	IF zipCode = 75225 THEN zipCode_ind = 1;	
	logSalePrice = log(SalePrice);
RUN;

PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms / SOLUTION CLPARM;
RUN;

PROC REG DATA = housing PLOTS=all;
	MODEL salePrice = sqFootage zipCode_ind nBedrooms nBathrooms;
RUN;

PROC GLM DATA = housing;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms / SOLUTION CLPARM;
	OUTPUT OUT = fitted PREDICTED = muHat;
RUN;

/* Show that the fitted values are negative for some values
   This + residual problem indicates a more complicated model is needed
   -> Add an interaction term for nBathrooms*zipCode
*/
symbol1 C=blue V=circle H=0.8;
symbol2 C=green V=plus H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA=fitted;
	PLOT muHat*nBathrooms=zipcode / VAXIS=axis1 HAXIS=axis2;

symbol1 C=blue V=circle H=0.8;
symbol2 C=green V=plus H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA=fitted;
	PLOT salePrice*nBathrooms=zipcode / VAXIS=axis1 HAXIS=axis2;

PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms nBathrooms*zipCode/ SOLUTION CLPARM;
RUN;

/* 
  Detour: Inference for interaction.  Find a linear combination
*/
PROC GLM DATA = housing;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms nBathrooms*zipCode/ SOLUTION CLPARM;
	ESTIMATE 'nBathrooms effect for zip = 75225' sqFootage 0 zipCode 0 nBedrooms 0 nBathrooms 1 nBathrooms*zipCode 1;
RUN;

/* 
  The above GLM still has poor residuals. Indication for a log transform of response
  Visually show the affect of a log transformation in this PROC GPLOT
*/
symbol1 C=blue V=circle H=0.8;
symbol2 C=green V=plus H=0.8;
symbol3 C=black V=circle H=0.8;
symbol4 C=red V=plus H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA=fitted;
	PLOT salePrice*nBathrooms=zipcode / VAXIS=axis1 HAXIS=axis2;
	PLOT2 logsalePrice*nBathrooms=zipcode / VAXIS=axis1 HAXIS=axis2;	

/* 
  Re-run with a log transformation in this PROC GLM
  Note that the interaction term is no longer significant
*/

PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL logSalePrice = sqFootage zipCode nBedrooms nBathrooms nBathrooms*zipCode/ SOLUTION CLPARM;
	OUTPUT OUT = fitted PREDICTED = muHat;
RUN;

PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL logSalePrice = sqFootage zipCode nBedrooms nBathrooms / SOLUTION CLPARM;
	OUTPUT OUT = fitted PREDICTED = muHat;
RUN;

/* 
  Just to confirm that there aren't any negative fitted values
*/
symbol1 C=blue V=circle H=0.8;
symbol2 C=green V=plus H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA=fitted;
	PLOT muHat*nBathrooms=zipcode / VAXIS=axis1 HAXIS=axis2;

/* 
  Testing groups of explanatory variables
*/
PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms;
RUN;

PROC GLM DATA = housing PLOTS=all;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode nBedrooms nBathrooms 
                          sqFootage*zipCode nBedrooms*zipCode nBathrooms*zipCode;
RUN;
