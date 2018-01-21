/*
This is code for drawing/shading the standard normal density
  To plot the density, alter the line:
    IF z <= 1.645 THEN upper = density;
  Examples:
    - Suppose we wanted to draw/shade P(Z < 1), we would write
          IF z <= 1 THEN upper = density;
    - Suppose we wanted to draw/shade P(Z > 2), we would write
          IF z >= 2 THEN upper = density;
*/


DATA density;
  DO t = -4 TO 4 BY .001;
    density = PDF("T", t, 80-1);
    lower = 0;
    upper = 0;
    IF t <= -3.252 THEN upper = density;
    IF t >= 3.252 THEN upper = density;
    OUTPUT;
  END;
RUN;

TITLE 'T probability density function';
PROC SGPLOT DATA=density NOAUTOLEGEND NOBORDER;
  YAXIS DISPLAY=none;
  BAND X = t LOWER = lower UPPER = upper / FILLATTRS=(COLOR=gray8a);
  SERIES X = t Y = density / LINEATTRS= (COLOR = black);
  SERIES X = t Y = lower / LINEATTRS = (COLOR = black);
RUN;
	
/* Get probabilities */
DATA prob;
	p = 2*(1-CDF('T',3.252,80-1));
RUN;	

PROC PRINT DATA=prob;
RUN;

/* Get quantiles */
DATA quant;
	t2  = QUANTILE('T',.975,2);
	t10 = QUANTILE('T',.975,10);
	t20 = QUANTILE('T',.975,20);	
	t30 = QUANTILE('T',.975,30);	
	t80 = QUANTILE('T',.975,80);		
	t800 = QUANTILE('T',.975,800);			
	z   = QUANTILE('NORMAL',.975,0,1);	
RUN;	

PROC PRINT DATA=quant;
RUN;


/* Get quantiles */
DATA quant;
	t  = QUANTILE('T',1-0.018/2,80-1);
RUN;	

PROC PRINT DATA=quant;
RUN;

DATA density;
  DO z = -4 TO 4 BY .001;
    density = PDF("Normal", z, 0, 1);
    lower = 0;
    IF z <= 1.95996 THEN upper = density;
    ELSE upper = 0;
    OUTPUT;
  END;
RUN;

TITLE 'Standard normal probability density function';
PROC SGPLOT DATA=density NOAUTOLEGEND NOBORDER;
  YAXIS DISPLAY=none;
  BAND X = z LOWER = lower UPPER = upper / FILLATTRS=(COLOR=gray8a);
  SERIES X = z Y = density / LINEATTRS= (COLOR = black);
  SERIES X = z Y = lower / LINEATTRS = (COLOR = black);
RUN;