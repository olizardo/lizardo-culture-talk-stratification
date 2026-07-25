clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"


/*education*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(2,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui levelsof gender,l(gend_levs)
	foreach l of local gend_levs {
		qui feologit_buc CASEID resp item1 if gender==`l'
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))			
		}
	local i=`i'+1
	}
cap gen gend_lab=_n in 1/2
cap lab def gend_lab 1 "men" 2 "women"
cap lab val gend_lab gend_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway rspike  D`i'2 D`i'3 gend_lab in 1/2 || ///
	scatter D`i'1 gend_lab in 1/2, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("gender") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(1 2,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_gend,replace) 
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
cap graph disp cgr_gend
graph export cgr_gend.png,as(png) replace
	