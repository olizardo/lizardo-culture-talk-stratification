



/*income*/
mat drop _all
forval i=1/5 {
	mat D`i'=J(6,3,0)
	}
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui levelsof finc_imp,l(finc_levs)
	foreach l of local finc_levs {
		qui feologit_buc CASEID resp item1 if finc_imp==`l'
		/*qui ologit resp i.item i.age_imp i.educ_imp i.women i.race if finc_imp==`l'*/
		mat B=e(b)
		mat V=e(V)
		mat D`i'[`l',1]=B[1,1]
		mat D`i'[`l',2]=B[1,1]-(1.96*sqrt(V[1,1]))
		mat D`i'[`l',3]=B[1,1]+(1.96*sqrt(V[1,1]))				
		}
	local i=`i'+1
	}
cap gen finc_lab=_n in 1/6
cap lab def finc_lab 1 "Low" 2 " " 3 " " 4 " " 5 " " 6 "High"
cap lab val finc_lab finc_lab 

local i=1
foreach name in movies music books arts plays {
	svmat D`i'
	twoway rspike  D`i'2 D`i'3 finc_lab in 1/6 || ///
	lfit D`i'1 finc_lab,lw(thick) lp(solid) lc(black) || ///
	scatter D`i'1 finc_lab in 1/6, ///
	yline(0,lc(gs10)) nodraw name(gr`i',replace) legend(off) xtitle("Fam. Income") ///
	msym(circle) mc(black) mfc(white) msiz(large) title("`name'") xlab(,val labs(small))
	drop D`i'*
	local i=`i'+1
	}
graph combine gr1 gr2 gr3 gr4 gr5,rows(1) ycommon xsize(7.5) ysize(5) name(cgr2,replace) nodraw


	 
graph combine cgr1 cgr2,cols(1) ysize(7.5) xsize(6.5) 

cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
forval i=1/3 {
	graph disp cgr`i'
	graph export cgr`i',as(png) replace
	}
	
/*
/*education by taste*/
clear
mat drop _all
mat D=J(6,3,0)
use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-music.dta",clear
local i=1
foreach name in operaclassical jazzblues rockpop folkcountry christgospel punkhvymetal {	
	tempvar tasteitem
	cap gen `tasteitem'=fav`name'*item1 
	qui ologit resp `tasteitem' item1 i.fav`name' i.educ_imp
	mat B=e(b)
	mat V=e(V)
	mat D[`i',1]=B[1,1]
	mat D[`i',2]=B[1,1]-(1.96*sqrt(V[1,1]))
	mat D[`i',3]=B[1,1]+(1.96*sqrt(V[1,1]))
	local i=`i'+1
	}
	
cap gen taste_lab=_n in 1/6
cap lab def taste_lab 1 "Opera/Classical" 2 "Jazz/Blues" 3 "Rock/Pop" 4 "Folk/Country" ///
5 "Christian/Gospel" 6 "Punk/Heavy Metal"
cap lab val taste_lab taste_lab

cap drop D*
local i=1
svmat D
twoway rspike D2 D3 taste_lab in 1/6 || ///
scatter D1 taste_lab in 1/6, ///
yline(0,lc(gs10)) name(grt,replace) legend(off) xtitle("Taste Group") graphr(margin(r+10)) ///
msym(circle) mc(black) mfc(white) msiz(large) title("`name'") ///
ylab(,nogrid) xlab(,val labs(small)) xsize(6.5) ysize(3)



