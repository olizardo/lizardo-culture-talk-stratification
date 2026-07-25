/*income*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(6,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui levelsof finc_imp,l(finc_levs)
	qui by CASEID: gen moretalk=resp[_n+1]-resp[_n]
	qui by CASEID: replace moretalk=moretalk[_n-1] if moretalk==.
	gen moretalk1=moretalk>=0 if moretalk!=.
	foreach l of local finc_levs {
		/*qui feologit_buc CASEID resp item1 if educ_imp==`l'*/
		qui ologit resp moretalk1 item1 if finc_imp==`l'
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))				
		}
	local i=`i'+1
	}
cap gen finc_lab=_n in 1/6
cap lab def finc_lab 1 "Low" 2 " " 3 " " 4 " " 5 " " 6 "High"
cap lab val finc_lab finc_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway lfit D`i'1 finc_lab in 1/6,lc(gs4) lw(thick) lp(solid) || ///
	rspike  D`i'2 D`i'3 finc_lab in 1/6 || ///
	scatter D`i'1 finc_lab in 1/6, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("Fam. Income") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_finc,replace) nodraw
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
cap graph disp cgr_finc
graph export cgr_finc.png,as(png) replace
	
