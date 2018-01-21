/* Get quantiles */
DATA quant;
	z = QUANTILE('NORMAL',.995);
RUN;	

PROC PRINT DATA=quant;
	VAR z;
RUN;

DATA density;
	SET quant;
	DO x = -4 TO 4 BY .001;
    	density = PDF("Normal", x, 0, 1);
    	lower = 0;
    	IF x <= z THEN upper = density;
    	ELSE upper = 0;
    	OUTPUT;
	END;
RUN;

TITLE 'Standard normal probability density function';
PROC SGPLOT DATA=density NOAUTOLEGEND NOBORDER;
  YAXIS DISPLAY=none;
  BAND X = x LOWER = lower UPPER = upper / FILLATTRS=(COLOR=gray8a);
  SERIES X = x Y = density / LINEATTRS= (COLOR = black);
  SERIES X = x Y = lower / LINEATTRS = (COLOR = black);
RUN;

TITLE ‘’;
DATA prob;
	SET quant;
	p = CDF('NORMAL',z);
RUN;	

PROC PRINT DATA=prob;
	VAR p;
RUN;

*Confidence interval example;
DATA marginError;
	z    = QUANTILE('NORMAL',.995);
	s    = SQRT(1.44);
	n    = 49;
	E    = z * s/SQRT(n);
RUN;	

PROC PRINT DATA=marginError;
	VAR E n;
RUN;

*Hypothesis testing example;

DATA density;
	SET quant;
	DO x = -4 TO 4 BY .001;
    	density = PDF("Normal", x, 0, 1);
    	lower = 0;
    	IF x <= -1.96 THEN upper = density;
    	ELSE IF x >= 1.96 THEN upper = density;
    	ELSE upper = 0;
    	OUTPUT;
	END;
RUN;

TITLE 'Standard normal probability density function';
PROC SGPLOT DATA=density NOAUTOLEGEND NOBORDER;
  YAXIS DISPLAY=none;
  BAND X = x LOWER = lower UPPER = upper / FILLATTRS=(COLOR=gray8a);
  SERIES X = x Y = density / LINEATTRS= (COLOR = black);
  SERIES X = x Y = lower / LINEATTRS = (COLOR = black);
RUN;

TITLE ‘’;

DATA prob;
	SET quant;
	pLower = CDF('NORMAL',-1.96);
	pUpper = 1-CDF('NORMAL',1.96);
	p = pLower + pUpper;
RUN;	

PROC PRINT DATA=prob;
	VAR p;
RUN;
