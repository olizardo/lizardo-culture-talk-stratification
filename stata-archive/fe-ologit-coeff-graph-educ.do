clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
/*education*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(6,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui replace educ_imp=educ_imp-1
	qui recode educ_imp 0/1=1
	qui levelsof educ_imp,l(educ_levs)
	/*qui by CASEID: gen moretalk=resp[_n+1]-resp[_n]
	qui by CASEID: replace moretalk=moretalk[_n-1] if moretalk==.
	qui recode moretalk -3/-1=0 0=0 1/3=1
	qui replace moretalk=0 if item==1*/
	qui by CASEID: gen symm=resp[_n+1]-resp[_n]
	qui by CASEID: replace symm=resp[_n]-resp[_n-1] if symm==.
	foreach l of local educ_levs {
		/*qui feologit_buc CASEID resp item1 if educ_imp==`l'*/
		qui feologit_buc CASEID resp item1 if educ_imp==`l',nolog
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))			
		}
	local i=`i'+1
	}
cap gen educ_lab=_n in 1/5
cap lab def educ_lab 1 "Low" 2 " " 3 " " 4 " " 5 "High"
cap lab val educ_lab educ_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway lfit D`i'1 educ_lab in 1/5,lc(gs4) lw(thick) lp(solid) || ///
	rspike  D`i'2 D`i'3 educ_lab in 1/5 || ///	
	scatter D`i'1 educ_lab in 1/5, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("Education") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_educ,replace) nodraw


cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
cap graph disp cgr_educ
graph export cgr_educ.png,as(png) replace

foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-vc-`name'.dta", clear
	egen resp=group(freq_`name' talk_`name'),lab
	tab resp,g(resp)
	drop resp
	mi reshape long resp,i(CASEID) j(patt)
	gen diag=patt==1|patt==6|patt==11|patt==16
	gen moretalk=patt==2|patt==3|patt==4|patt==7|patt==8|patt==11
	gen row=.
	gen col=.
	replace row=1 if patt==1|patt==2|patt==3|patt==4
	replace row=2 if patt==5|patt==6|patt==7|patt==8
	replace row=3 if patt==9|patt==10|patt==11|patt==12
	replace row=4 if patt==13|patt==14|patt==15|patt==16
	replace col=1 if patt==1|patt==5|patt==9|patt==13
	replace col=2 if patt==2|patt==6|patt==10|patt==14
	replace col=3 if patt==3|patt==7|patt==11|patt==15
	replace col=4 if patt==4|patt==8|patt==12|patt==16
	save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-long-`name'.dta",replace
	}

clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
/*education*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(6,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-long-`name'.dta",clear
	qui replace educ_imp=educ_imp-1
	qui recode educ_imp 0/1=1
	qui levelsof educ_imp,l(educ_levs)
	foreach l of local educ_levs {
		qui clogit resp moretalk i.row i.col i.diag if educ_imp==`l',group(CASEID)
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.65*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.65*sqrt(V[1,1]))			
		}
	local i=`i'+1
	}
cap gen educ_lab=_n in 1/5
cap lab def educ_lab 1 "Low" 2 " " 3 " " 4 " " 5 "High"
cap lab val educ_lab educ_lab 

cap drop D*
local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway lfit D`i'1 educ_lab in 1/5,lc(gs4) lw(thick) lp(solid) || ///
	rspike  D`i'2 D`i'3 educ_lab in 1/5 || ///	
	scatter D`i'1 educ_lab in 1/5, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("Education") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr_educ,replace) 
