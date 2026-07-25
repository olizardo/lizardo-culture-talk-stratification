clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
/*age*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(7,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui levelsof age_imp,l(age_levs)
	qui by CASEID: gen moretalk=resp[_n+1]-resp[_n]
	qui by CASEID: replace moretalk=moretalk[_n-1] if moretalk==.
	qui gen moretalk1=moretalk>0 if moretalk!=.
	foreach l of local age_levs {
		/*qui feologit_buc CASEID resp item1 if educ_imp==`l'*/
		qui ologit resp moretalk1 item1 if age_imp==`l'
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))			
		}
	local i=`i'+1
	}
	
cap gen age_lab=_n in 1/7
cap lab def age_lab 1 "Younger" 2 " " 3 " " 4 " " 5 " " 6 " " 7 "Older"
cap lab val age_lab age_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway lfit D`i'1 age_lab in 1/7,lc(gs4) lw(thick) lp(solid) || ///
	rspike  D`i'2 D`i'3 age_lab in 1/7 || ///
	scatter D`i'1 age_lab in 1/7, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("Age Group") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(1(1)7,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_age,replace) nodraw
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
cap graph disp cgr_age
graph export cgr_age.png,as(png) replace

preserve 
restore
