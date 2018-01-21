DATA mrt;
	INPUT score status $ @@;
	DATALINES;
567 notFatig 512 notFatig 509 notFatig 593 notFatig 588 notFatig 
491 notFatig 520 notFatig 588 notFatig 529 notFatig 508 notFatig
530 fatigued 492 fatigued 510 fatigued 580 fatigued 600 fatigued
483 fatigued 512 fatigued 575 fatigued 530 fatigued 490 fatigued
;
RUN;

PROC TTEST DATA=mrt ALPHA = 0.01 SIDE = L;
	CLASS status;
	VAR score;
RUN;

DATA mrt_paired;
	INPUT notFatig fatigued @@;
	DATALINES;
567 530 512 492 509 510 593 580 588 600
491 483 520 512 588 575 529 530 508 490
;
RUN;

PROC TTEST DATA=mrt_paired ALPHA = 0.01 SIDE = L;
	PAIRED fatigued*notFatig;
RUN;