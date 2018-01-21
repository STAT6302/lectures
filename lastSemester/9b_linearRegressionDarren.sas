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
 132000 1379 3 2 75224m
 139000  857 2 2 75224
 259000 1658 4 2 75224
 170000 1879 4 2 75224
 340000 2540 4 3 75224
 384900 3948 5 3 75224
 250000 1426 3 2 75224
 130000 1338 3 1 75224
 119000  757 2 1 75224
;

PROC SGSCATTER DATA = housing;
	MATRIX salePrice sqFootage nBedrooms nBathrooms;
RUN;


/* sq ft with equal slopes*/
ODS GRAPHICS ON;
PROC GLM DATA = housing PLOTS=(ALL);
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode / SOLUTION CLPARM;
RUN;
ODS GRAPHICS OFF;


/* sq ft with Unequal slopes*/
ODS GRAPHICS ON;
PROC GLM DATA = housing PLOTS=(ALL);
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode zipCode*sqFootage / SOLUTION CLPARM;
RUN;
ODS GRAPHICS OFF;

/* All */
ODS GRAPHICS ON;
PROC GLM DATA = housing PLOTS=(ALL);
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode zipCode*sqFootage nBathrooms nBedrooms/ SOLUTION CLPARM;
RUN;
ODS GRAPHICS OFF;

/* without bedrooms */
ODS GRAPHICS ON;
PROC GLM DATA = housing PLOTS=(ALL);
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode zipCode*sqFootage nBathrooms / SOLUTION CLPARM;
	
RUN;
ODS GRAPHICS OFF;

/* get output for plot */
PROC GLM DATA = housing;
	CLASS zipCode (ref = '75224');
	MODEL salePrice = sqFootage zipCode zipCode*sqFootage nBathrooms / SOLUTION CLPARM;
	OUTPUT OUT = fitted PREDICTED = muHat;
RUN;

symbol1 C=blue V=circle H=0.8;
axis1 LABEL=(r=0 a=90) MINOR=none;
axis2 MINOR=none;
PROC GPLOT DATA=fitted;
	PLOT muHat*nBathrooms / VAXIS=axis1 HAXIS=axis2;
