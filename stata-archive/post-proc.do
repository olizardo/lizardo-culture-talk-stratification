use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear

keep c_* talk* freq* num* fav* *imp
center num*
foreach var of varlist c_educ_imp c_finc_imp c_age_imp c_freq* c_num* {
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}

global spec ///
c_educ_imp c_finc_imp c_age_imp c_gender   ///
c_white c_asian c_hispanic c_black ///
c_married c_city  

global labels ///
Education Income Age Gender  ///
White Asian Hispanic Black/Afr.Amer. ///
Married Urban 

do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\interactions.do"
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",replace

