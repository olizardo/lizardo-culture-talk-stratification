/*begin creating results-set 1b*/
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
clear
set obs 9
forval j=1(1)5 {
	forval k=1(1)3 {
		quietly {
			gen b`j'`k'=. 
			gen hi90`j'`k'=.
			gen lo90`j'`k'=.
			gen hi50`j'`k'=.
			gen lo50`j'`k'=.
			}
		}
	}
gen lab=_n
lab def lab 1 "Educ" 2 "Age" 3 "Income" 4 "Gender (woman=1)" ///
5 "Race/Eth. (Black)" 6 "Race/Eth. (Hisp.)" 7 "Race/Eth. (Asian)" ///
8 "Urban (yes=1)" 9 "Married (yes=1)" 
lab val lab lab
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1b.dta",replace
/*begin creating results-set 1b*/

/*exploring parallel lines assumption*/
local j=1
foreach name in movies music books arts plays {
	quietly {
		local c1 recode X 4=1 1/3=0
		local c2 recode X 4=. 3=1 1/2=0
		local c3 recode X 3/4=. 2=1 1=0
		forval k=1/3 {	
			use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
			for var freq_`name' talk_`name' :`c`k''
			bysort CASEID:replace resp=freq_`name' if _n==1
			bysort CASEID:replace resp=talk_`name' if _n==2	
			clogit resp item1 ///
			educXitem fincXitem ageXitem gendXitem ///
			blackXitem asnXitem hispXitem marrXitem urbXitem, ///
			group(CASEID) nolog
			mat b=e(b)
			mat v=e(V)
			use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1b.dta",clear
			local m=1
			forval i=2/10 {
				replace b`j'`k'=b[1,`i'] in `m'
				replace hi90`j'`k'=b`j'`k'+(1.64*sqrt(v[`i',`i'])) in `m'
				replace lo90`j'`k'=b`j'`k'-(1.64*sqrt(v[`i',`i'])) in `m'
				replace hi50`j'`k'=b`j'`k'+(0.67*sqrt(v[`i',`i'])) in `m'
				replace lo50`j'`k'=b`j'`k'-(0.67*sqrt(v[`i',`i'])) in `m'
				local m=`m'+1
				}
			save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1b.dta",replace
			}
		local j=`j'+1
		}
	}

forval m=1/2 {
	if `m'==1 {
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1b.dta",clear
		drop in 5/9
		}
	if `m'==2 {
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1b.dta",clear
		drop in 1/4
		}
	local title Movies Music Books Arts Plays
	local st1 Very Often vs All
	local st2 Fairly Often vs Not Very Often and Not at All
	local st3 Not Very Often vs Not at All
	local j=1
	foreach name in movies music books arts plays {
		local t : word `j' of `title'
		forval k=1/3 {
			twoway rspike hi90`j'`k' lo90`j'`k' lab, ///
			lw(vvthin) lc(black) horizontal || ///
			rspike hi50`j'`k' lo50`j'`k' lab, ///
			lw(thick) lc(black) horizontal || ///
			scatter lab b`j'`k', ///
			msym(diamond) mc(black) mfc(black) msize(large) ///
			ylab(,nogrid noticks val angle(360)) xline(0) ///
			yscal(noline) ///
			xtitle("delta_k") ytitle("") legend(off) ///
			plotr(margin(t+4 b+4)) title("`st`k''",size(medium)) ///
			name(deltak_by_npl`j'`k',replace) scheme(lean2) nodraw
			}
		graph combine ///
		deltak_by_npl`j'1 ///
		deltak_by_npl`j'2 ///
		deltak_by_npl`j'3, ///
		cols(1) xcommon title("`t'") ///
		ysize(7) xsize(5) ///
		name(deltak_by_npl`j',replace) 
		cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
		graph export deltak`m'_by_npl`j'.png,as(png) replace
		disp `j'
		local j=`j'+1
		}
	}




/*equation 1 estimates*/
est drop _all
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui eststo mod`i' : ///
	xi:feologit_buc CASEID resp i.item
	local i=`i'+1
	}
esttab mod1 mod2 mod3 mod4 mod5,stats(chi2)

/*equation 2 estimates*/
est drop _all
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui eststo mod`i' : ///
	xi:feologit_buc CASEID resp item1 ///
	educXitem fincXitem ageXitem gendXitem ///
	blackXitem asnXitem hispXitem marrXitem urbXitem
	local i=`i'+1
	}
esttab mod1 mod2 mod3 mod4 mod5,stats(chi2)


/*begin creating results-set 1*/
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
clear
set obs 5
gen b=. 
gen hi90=.
gen lo90=.
gen hi50=.
gen lo50=.
gen lab=_n
lab def lab 1 "Movies" 2 "Music" 3 "Books" 4 "Arts" 5 "Play"
lab val lab lab
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1.dta",replace
local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	xi:feologit_buc CASEID resp item1
	mat b=e(b)
	mat v=e(V)
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1.dta",clear
	quietly {
		replace b=b[1,1] in `i'
		replace hi90=b+(1.64*sqrt(v[1,1])) in `i'
		replace lo90=b-(1.64*sqrt(v[1,1])) in `i'
		replace hi50=b+(0.67*sqrt(v[1,1])) in `i'
		replace lo50=b-(0.67*sqrt(v[1,1])) in `i'
		}
	save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1.dta",replace
	local i=`i'+1
	}
/*end creating results-set 1*/

/*begin graphing results-set 1*/
use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set1.dta",clear
twoway rspike hi90 lo90 lab, ///
lw(vvthin) lc(black) horizontal || ///
scatter lab b, ///
msym(diamond) mc(black) mfc(black) msize(huge) ///
ylab(,val angle(360) nogrid noticks labs(vlarge)) yscal(noline) xlab(,labs(vlarge)) ///
xline(0,lp(dash) lc(gray)) ///
legend(off) xtitle("Beta_t") ytitle("")  ///
plotr(margin(b+10 t+10)) name(betat_by_genre,replace) ///
scheme(lean2) xsize(6) ysize(1.5) 
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
graph export betat_by_genre.png,as(png) replace
/*end graphing results-set 1*/

/*begin creating results-set 2*/
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
clear
set obs 9
forval j=1(1)5 {
	quietly {
		gen b`j'=. 
		gen hi90`j'=.
		gen lo90`j'=.
		gen hi50`j'=.
		gen lo50`j'=.
		}
	}
gen lab=_n
lab def lab 1 "Educ" 2 "Age" 3 "Income" 4 "Gender (woman=1)" ///
5 "Race/Eth. (Black)" 6 "Race/Eth. (Hisp.)" 7 "Race/Eth. (Asian)" ///
8 "Urban (yes=1)" 9 "Married (yes=1)" 
lab val lab lab
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set2.dta",replace

local i=1
foreach name in movies music books arts plays {
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",clear
	qui xi:feologit_buc CASEID resp item1 ///
	educXitem fincXitem ageXitem gendXitem ///
	blackXitem asnXitem hispXitem marrXitem urbXitem
	mat b=e(b)
	mat v=e(V)
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set2.dta",clear
	local k=1
	forval j=2(1)10 {
		quietly {
			replace b`i'=b[1,`j'] in `k'
			replace hi90`i'=b`i'+(1.64*sqrt(v[`j',`j'])) in `k'
			replace lo90`i'=b`i'-(1.64*sqrt(v[`j',`j'])) in `k'
			replace hi50`i'=b`i'+(0.67*sqrt(v[`j',`j'])) in `k'
			replace lo50`i'=b`i'-(0.67*sqrt(v[`j',`j'])) in `k'
			}
		local k=`k'+1
		}
	save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set2.dta",replace
	local i=`i'+1
	}
/*end of creating results-set 2*/

/*begin graphing results-set 2*/
forval k=1/2 {
	if `k'==1 {
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set2.dta",clear
		drop in 5/9
		}
	if `k'==2 {
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set2.dta",clear
		drop in 1/4
		}
	local title Movies Music Books Arts Plays
	forval i=1/5 {
		local t : word `i' of `title'	
		twoway rspike hi90`i' lo90`i' lab, ///
		lw(vvthin) lc(black) horizontal || ///
		rspike hi50`i' lo50`i' lab, ///
		lw(thick) lc(black) horizontal || ///
		scatter lab b`i', ///
		msym(circle) mc(black) mfc(black) msize(large) ///
		ylab(,nogrid noticks val angle(360)) xline(0) ///
		yscal(noline) ///
		xtitle("delta_k") ytitle("") legend(off) ///
		plotr(margin(t+4 b+4)) title("`t'",size(medium)) ///
		name(deltak_by_predictor`i'`k',replace) scheme(lean2) nodraw
		}
	graph combine ///
	deltak_by_predictor1`k' deltak_by_predictor2`k' deltak_by_predictor3`k' ///
	deltak_by_predictor4`k' deltak_by_predictor5`k', ///
	cols(1) xcommon ycommon name(deltak_by_predictor`k',replace) ysize(7) xsize(4) 
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b" 
	graph export deltak_by_predictork'.png,as(png) replace
	}
/*end of graphing results-set 2*/

graph combine deltak_by_predictor deltak_by_predictor2,cols(2) ysize(7.5) xsize(6.5) altshrink
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b" 
graph export deltak_by_predictor.png,as(png) replace

/*begin creating results-set 3*/
clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
set obs 6
forval i=1/5 {
	gen b`i'=. 
	gen hi90`i'=.
	gen lo90`i'=.
	gen hi50`i'=.
	gen lo50`i'=.
	}
gen lab=_n
lab def lab 1 "Opera/Classical" 2 "Jazz/Blues" 3 "Rock/Pop" 4 "Christian/Gospel" 5 "Folk/Country" 6 "Punk/Metal"
lab val lab lab
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set3.dta",replace

local k=1
foreach cultdomain in movies music books arts plays {
	local i=1
	foreach genre in favoperaclassical favjazzblues favrockpop favchristgospel favfolkcountry favpunkhvymetal {
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`cultdomain'.dta",clear
		qui xi:feologit_buc CASEID resp i.item*`genre' ///
		educXitem fincXitem ageXitem gendXitem ///
		blackXitem asnXitem hispXitem marrXitem urbXitem
		mat b=e(b)
		mat v=e(V)
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set3.dta",clear
		quietly {
			replace b`k'=b[1,2] in `i'
			replace hi90`k'=b`k'+(1.64*sqrt(v[2,2])) in `i'
			replace lo90`k'=b`k'-(1.64*sqrt(v[2,2])) in `i'
			replace hi50`k'=b`k'+(0.67*sqrt(v[2,2])) in `i'
			replace lo50`k'=b`k'-(0.67*sqrt(v[2,2])) in `i'
			}
		save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set3.dta",replace
		local i=`i'+1
		}
	local k=`k'+1
	}
/*end of creating results-set 3*/

/*graphing results-set 3*/
use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\results_set3.dta",clear
local title Movies Music Books Arts Plays
forval i=1/5 {
	local t : word `i' of `title'	
	twoway rspike hi90`i' lo90`i' lab, ///
	ylab(,nogrid noticks) yscal(noline) ///
	lw(vvthin) lc(black) horizontal || ///
	rspike hi50`i' lo50`i' lab, ///
	lw(thick) lc(black) horizontal || ///
	scatter lab b`i', ///
	msym(diamond) mc(black) mfc(black) msize(large) ///
	xline(0,lp(dash) lc(gray)) ylab(,val angle(360)) legend(off) ///
	xtitle("delta_k") ytitle("") ///
	plotr(margin(l+4 t+4 b+4)) title("`t'",size(medium)) ///
	name(deltak_by_genre`i',replace) scheme(lean2)
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b" 
	graph export deltak_by_genre`i'.png,as(png) replace
	}

graph combine ///
deltak_by_genre1 deltak_by_genre2 deltak_by_genre3 deltak_by_genre4 deltak_by_genre5, ///
rows(3) xcommon ycommon name(deltak_by_genre,replace) iscale(.5) xsize(8) ysize(5)
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b" 
graph export deltak_by_genre.png,as(png) replace

graph disp deltak_by_genre2,ysize(3) xsize(6.5) 
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b" 
graph export deltak_by_genre_music.png,as(png) replace
/*end of graphing results-set 3*/

