LIBNAME datalib "/courses/d6426995ba27fe300";

FILENAME REFFILE '/courses/d6426995ba27fe300/gnp_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=gnp;
	GETNAMES=YES;
RUN;

DATA log_gnp;
	SET gnp;
	log_gnp = log(gnp);
RUN;

PROC ARIMA DATA = log_gnp;
	IDENTIFY VAR=log_gnp(1);
RUN;

TITLE 'ARIMA(1,1,0)';
PROC ARIMA DATA = log_gnp;
	IDENTIFY VAR=log_gnp(1);
	ESTIMATE p=1;
RUN;

TITLE 'ARIMA(0,1,2)';
PROC ARIMA DATA = log_gnp;
	IDENTIFY VAR=log_gnp(1);
	ESTIMATE q=2;
RUN;

TITLE 'ARIMA(1,1,2)';
PROC ARIMA DATA = log_gnp;
	IDENTIFY VAR=log_gnp(1);
	ESTIMATE p=1 q=2 MAXITER=100;
RUN;

TITLE 'Choose ARIMA(1,1,2), make forecast for next 4 quarters';
PROC ARIMA DATA = log_gnp PLOTS=FORECAST(ALL);
	IDENTIFY VAR=log_gnp(1);
	ESTIMATE p=1 q=2 MAXITER=100;
	FORECAST LEAD=4 OUT=OUT;
RUN;

data out;
      SET out;
      SET log_gnp;
      y   = exp( log_gnp );
      l95 = exp( l95 );
      u95 = exp( u95 );
      forecast = exp( forecast + std*std/2 );
      /* The std*std/2 is an adjustment for time series of converting the median estimate to mean */;
RUN;
   
PROC SGPLOT DATA=out;
	BAND UPPER=u95 LOWER=l95 X=DATE
      / LEGENDLABEL="95% Confidence Limits";
   SERIES X=DATE Y=forecast;
   XAXIS VALUEATTRS=(SIZE=2pt);
RUN;