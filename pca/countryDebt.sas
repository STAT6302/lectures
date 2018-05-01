DATA countryDebt;
	INPUT Country $ Debt Deforest Population;
	DATALINES;
	Brazil 86396 12150 128425
	Mexico 79613 2680 74195
	Ecuador 6990 1557 8751
	Colombia 10101 1500 27254
	Venezuela 24870 1430 16171
	Peru 10707 1250	 18497
	Nicaragua 3985 550 3022
	Argentina 36664 400 29401
	Bollivia 3810 300 5971
	Paraguay 1479 250 3425
	CostaRica 3413 90 2440
;
RUN;

*\ Original Regression \*;	
PROC REG PLOTS=all;
	MODEL deforest = debt population / INFLUENCE;
RUN;


PROC FACTOR DATA = countryDebt PLOTS=SCREE;
RUN;


PROC FACTOR DATA = countryDebt NFACTORS=1 PLOTS=SCREE OUT = PCA;
RUN;

PROC REG DATA = PCA PLOTS=all;
	MODEL deforest =  factor1 / INFLUENCE;


DATA PCA;
	SET PCA;
	ldeforest = log(deforest);

*\ log transform response \*;
PROC REG DATA = PCA PLOTS=all;
	MODEL ldeforest =  factor1 / INFLUENCE;

