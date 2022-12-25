

* calculate change in bmi;
data work.weight;
	 set  work.weight;
bmi_final = coalesce(of bmi13-bmi1);
bmi_change = bmi_final - bmi_Initial;
run;


data work.weight;
	 set  work.weight;
* percent is timed 100, so 1 means 1%;
bmi_change_percent = bmi_change / bmi_Initial * 100;
* here <-5 means losing more than 5% bmi;
IF bmi_change_percent  < -5 THEN change = 1; 
    ELSE change = 0;
run; 
proc print data=work.weight(obs=5);
    * VAR Weight Height Age;  /* optional: the VAR statement specifies variables */
run;


* linear regression for RQ1;
* those with p value < 5% are significant predictors, see anova output;
* see estimation table for sign and magnitidue for interpretation;

PROC GLM DATA=work.weight;
	CLASS Gender	Ethnicity	HTN	Prediabetes	T2DM	HLD	CVD	NAFLDNASH	Hypothyroidism OSA	Psych PCOS metformin;
	MODEL bmi_change = Initial_Height Initial_Weight Gender	Ethnicity	HTN	Prediabetes	T2DM	HLD	CVD	NAFLDNASH	Hypothyroidism OSA	Psych PCOS metformin / solution;
RUN;


* logistic regression for RQ2;
* descending is set to model pr(change =1) instead of Pr(change =0);
* still, check those variable with p value < 0.05 or those categorical with several levels whose F stat has p value smaller than 0.05, to identify significant factors;
PROC logistic DATA=work.weight descending;
	CLASS Gender	Ethnicity	HTN	Prediabetes	T2DM	HLD	CVD	NAFLDNASH	Hypothyroidism OSA	Psych PCOS metformin;
	MODEL change = Initial_Height Initial_Weight Gender	Ethnicity	HTN	Prediabetes	T2DM	HLD	CVD	NAFLDNASH	Hypothyroidism OSA	Psych PCOS metformin;
RUN;
