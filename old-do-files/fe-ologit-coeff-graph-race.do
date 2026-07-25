clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"

mat drop _all
forval i=1/5 {
	mat D`i'=J(3,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	quietly {
		drop if race>4
		drop if race==3
		recode race 4=3
	qui levelsof race,l(race_levs)
	foreach l of local race_levs {
		qui feologit_buc CASEID resp item1 if race==`l'
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))			
		}
	local i=`i'+1
	}
cap gen race_lab=_n in 1/3
cap lab def race_lab 1 "white" 2 "black" 3 "hispanic"
cap lab val race_lab race_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway rspike  D`i'2 D`i'3 race_lab in 1/3 || ///
	scatter D`i'1 race_lab in 1/3, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("race/ethnicity") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(1(1)3,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_race,replace) 
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
cap graph disp cgr_race
graph export cgr_race.png,as(png) replace
	