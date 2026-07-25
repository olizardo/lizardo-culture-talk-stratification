use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\NSS-2002-2004-using.dta",clear
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
foreach var of varlist c_*{
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}
global xvars c_educ_imp c_finc_imp c_age_imp c_gender c_city 
save "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",replace

/*summary statistics*/
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
recode gender 2 = 1 1 = 0
lab var gender "Gender (Woman = 1)"
lab var city "Urban Location"
lab var age_imp "Respondent's Age"
lab var educ_imp "Respondent's Educ."
lab var finc_imp "Family Income"
lab var talk_music "Cult. Talk (Music)"
lab var talk_art "Cult. Talk (Art)"
lab var talk_books "Cult. Talk (Books)"
lab var talk_movies "Cult. Talk (Movies)"
lab var talk_plays "Cult. Talk (Plays)"
lab var freq_music "Consumption Freq. (Music)"
lab var freq_art "Consumption Freq. (Art)"
lab var freq_books "Consumption Freq. (Books)"
lab var freq_movies "Consumption Freq. (Movies)"
lab var freq_plays "Consumption Freq. (Plays)"

estpost summarize freq* talk* educ_imp finc_imp age_imp gender city, listwise 
esttab, cells("mean(fmt(%9.2f)) sd(fmt(%9.2f)) min(fmt(%9.0f)) max(fmt(%9.0f))") ///
nomtitle nonumber unstack lab varw(25) 
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
esttab using desc-tab.rtf, cells("mean(fmt(%9.2f)) sd(fmt(%9.2f)) min(fmt(%9.0f)) max(fmt(%9.0f))") ///
nomtitle nonumber unstack lab varw(25) replace


use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
gen inc_effect_ord = .
gen inc_effect_cat = . 
gen educ_effect_ord = . 
gen educ_effect_cat = .
gen educ_ord_p = .
gen educ_cat_p = .
gen inc_ord_p = .
gen inc_cat_p = .
local i 1
/*testing hypotheses 2  and 4 v. 5 (ordinal restriction)*/
foreach name in movies music books arts plays {
	global xvars c_educ_imp c_finc_imp c_age_imp c_gender c_city 
	qui oprobit talk_`name' $xvars c_freq_`name'
	test c_educ_imp = c_finc_imp /*testing equality of coefficients*/
	quietly {
		test c_educ_imp  
		replace educ_effect_ord = r(chi2) in `i'
		replace educ_ord_p = r(p) in `i'
		test c_finc_imp 
		replace inc_effect_ord = r(chi2) in `i'
		replace inc_ord_p = r(p) in `i'
		}
/*testing hypotheses 2 and 4 v. 5 (no ordinal restriction)*/
	global xvars i.educ_imp i.finc_imp c_age_imp c_gender c_city 
	qui oprobit talk_`name' $xvars c_freq_`name'
	quietly {
		test 2.educ_imp 3.educ_imp 4.educ_imp 5.educ_imp 6.educ_imp
		replace educ_effect_cat = r(chi2) in `i'
		replace educ_cat_p = r(p) in `i'
		test 1.finc_imp 2.finc_imp 3.finc_imp 4.finc_imp 5.finc_imp 6.finc_imp
		replace inc_effect_cat = r(chi2) in `i'
		replace inc_cat_p = r(p) in `i'
		}
	local ++i
	}
for var inc_effect_ord- inc_cat_p : format X %9.3f
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
listtab educ_effect_ord educ_ord_p inc_effect_ord inc_ord_p using chi2test_ord.csv in 1 / 5, ///
 delimiter(,) 
listtab educ_effect_cat educ_cat_p inc_effect_cat inc_cat_p using chi2test_cat.csv in 1 / 5, ///
 delimiter(,) 

/*Testing hypothesis 2 by computing income versus education marginal effect (Figure 1 in paper)*/
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
foreach name in movies music books  {
	qui oprobit talk_`name' $xvars c_freq_`name'
	qui margins, ///
		dydx(c_finc_imp c_educ_imp) predict(pr out(4))
	marginsplot, ///
		scheme(economist) graphr(color(white)) ///
		name(`name',replace) ///
		recast(bar) ///
		plotopts(barw(.5) bc(black) bfc(white)) ///
		ciopts(recast(rspike) color(gs10)) ///
		xlab(1 "Education" 2 "Fam. Income") ///
		xtitle("") ytitle("") yline(0, lc(black) lw(thick))  ///
		title("`name'", size(huge))
	window manage close graph
	} 
foreach name in arts plays  {
	qui oprobit talk_`name' $xvars c_freq_`name'
	qui margins, ///
		dydx(c_finc_imp c_educ_imp) ///
		expression(predict(pr out(3)) + predict(pr out(4))) saving(file1,replace) 
	combomarginsplot file1, ///
		scheme(economist) graphr(color(white)) ///
		name(`name',replace) ///
		recast(bar) ///
		plotopts(barw(.5) bc(black) bfc(white)) ///
		ciopts(recast(rspike) color(gs10)) ///
		xlab(1 "Education" 2 "Fam. Income") ///
		xtitle("") ytitle("") yline(0, lc(black) lw(thick))  ///
		title("`name'", size(huge))
	window manage close graph
	}
graph combine movies music books arts plays, ///
rows(2) ycommon ysize(6) xsize(6.5) iscale(.6)
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1\png"
graph export educ-v-inc_marg-effect.png,as(png) replace hei(1200) wid(1300)

/*testing hypothesis 3 (Figure 2 in paper)*/
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
foreach name in movies music books  {
	qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city i.freq_`name'##c.c_educ
	qui margins,dydx(c_educ) at(freq_`name' = (1(1)4)) predict(pr out(4))
	marginsplot, ///
		yline(0, lc(black) lw(thick)) level(90) scheme(economist)  ///
		ciopts( ///
			color(black) lw(thick) recast(rspike) ///
			) ///
		plotopts( ///
			recast(scatter) ///
			msym(diamond) mfc(black) mc(white) msize(huge) ///
			) ///
		graphr(color(white)) legend(region(color(white))) ///
		xtitle("Engagement") ytitle(" ") ///
		ylab(,nogrid) ysize(6) xsize(4)  ///
		xlabel(1 "Infrequent" 2 " " 3 " " 4 "Frequent", noticks) ///
		name(`name',replace) title("`name'",size(huge)) ///
		graphr(margin(l+10))
	window manage close graph
	} 
foreach name in arts plays  {
	qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city i.freq_`name'##c.c_educ
	qui margins, ///
		dydx(c_educ) at(freq_`name' = (1(1)4)) ///
		expression(predict(pr out(3)) + predict(pr out(4))) saving(file1,replace) 
	combomarginsplot file1, ///
		yline(0, lc(black) lw(thick)) level(90) scheme(economist)  ///
		ciopts( ///
			color(black) lw(thick) recast(rspike) ///
			) ///
		plotopts( ///
			recast(scatter) ///
			msym(diamond) mfc(black) mc(white) msize(huge) ///
			) ///
		graphr(color(white)) legend(region(color(white))) ///
		xtitle("Engagement") ytitle(" ") ///
		ylab(,nogrid) ysize(6) xsize(4)  ///
		xlabel(1 "Infrequent" 2 " " 3 " " 4 "Frequent", noticks) ///
		name(`name',replace) title("`name'",size(huge)) /// 
		graphr(margin(l+10))
	window manage close graph
	}
	
graph combine movies music books arts plays, graphr(color(white)) ///
rows(1) ysize(3.5) xsize(6.5) xcommon ycommon name(educ_part_int,replace) iscale(.6)
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1\png"
graph export educ_part_int.png,as(png) replace hei(700) wid(1300)


/*testing hypotheses 4 v. 5*/
global xvars c_educ_imp c_finc c_age_imp c_gender c_city 
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
local i 1
foreach name in movies music books  {
	qui oprobit talk_`name' $xvars c_freq_`name'
	qui margins,dydx(c_educ) predict(pr out(4)) saving(file`i',replace)
	local ++i
	}
foreach name in arts plays  {
	qui oprobit talk_`name' $xvars c_freq_`name'
	qui margins, ///
		dydx(c_educ) expression(predict(pr out(3)) + predict(pr out(4))) saving(file`i',replace) 
	local ++i
	}	
combomarginsplot file1 file2 file3 file4 file5, ///
	labels("Movies" "Music" "Books" "Arts" "Plays") ///
	recast(scatter) ///
	level(90) scheme(economist)  ///
	ciopts( ///
		color(red) lw(thick) recast(rspike) ///
		) ///
	plotopts( ///
		msym(diamond) msiz(huge) mc(white) mfc(red) ///
		) ///
	graphr(color(white)) legend(region(color(white))) ///
	xtitle("Marginal Effect of Education") ytitle(" ") ///
	ysize(4) xsize(6.5)  ///
	ylab(0(.02).1) yscal(range(0 .1)) ///
	plotr(margin(b + 5)) ///
	title(" ") graphr(margin(l + 10)) 
	
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1\png"
graph export educ_effect_comp.png, as(png) replace hei(800) wid(1300)

/*testing hypothesis 6*/	
global xvars c_educ_imp c_finc_imp c_age_imp  c_gender c_city 
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
factor freq*,fac(2) pcf mine(.9) 
rot,pro(3)
predict hi pop
foreach name in movies music books arts plays {
	qui oprobit talk_`name' $xvars c_freq_`name' hi pop,robust
	test hi = pop
	}

/*table 2: predictors of culture talk*/
global xvars c_educ_imp c_finc_imp c_age_imp  c_gender c_city 
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
foreach name in movies music books arts plays {
	qui oprobit talk_`name' $xvars c_freq_`name'
	est store `name'
	}
	
esttab movies music books arts plays
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
esttab movies music books arts plays using talk-tab1.rtf, ///
stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps collabels(none)  ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies) 


/*table 3: factor loadings for frequency items*/
global xvars c_educ_imp c_finc_imp c_age_imp  c_gender c_city 
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
factor freq*,fac(2) pcf mine(.9) 
rot,pro(3)
predict hi pop
lab var hi "Fine Arts Factor Score"
lab var pop "Commercial Arts Factor Score"
esttab using fac-tab.rtf, replace label ///
cells("r_L[1](t label(Factor 1) fmt(%9.3f)) r_L[2](t label(Factor 2) fmt(%9.3f)) Psi (label(Psi) fmt(%9.3f))") ///
nogap noobs nonumber nomtitle  
factor freq*,fac(1) 
predict all

/*table 4: highbrow and pop factors as predictors of talk*/
foreach name in movies music books arts plays {
	qui oprobit talk_`name' c_freq_`name' hi pop $xvars 
	test hi = pop
	est store `name'
	}
	
esttab movies music books arts plays,keep(hi pop)
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
esttab movies music books arts plays using talk-tab2.rtf,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps collabels(none)  ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies) keep(hi pop)

/*overall consumption principal factor score as predictor of talk*/
foreach name in movies music books arts plays {
	qui oprobit talk_`name' all $xvars 
	est store `name'
	}
	
esttab movies music books arts plays
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
esttab movies music books arts plays using talk-tab3.rtf,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps collabels(none)  ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(all Consumption_Factor_Score)

/*table 5: predictors of cultural participation*/
global xvars c_educ_imp c_finc_imp c_age_imp  c_gender c_city 
use "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\small.dta",clear
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\Poetics-R1"
foreach name in movies music books arts plays {
	qui oprobit freq_`name' $xvars 
	est store `name'
	}
esttab movies music books arts plays
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
esttab movies music books arts plays using freq-tab.rtf,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps collabels(none)  ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend 

/*
gen cat=_n in 1/4
local j=1
foreach X in movies music arts books plays {
	gen `X'_tau=.
	gen `X'_tau_hi=.
	gen `X'_tau_lo=.
	forval i=1/4 {
		qui somersd educ_imp talk_arts if freq_`X'==`i'
		mat b=e(b)
		mat v=e(V)
		quietly {
			replace `X'_tau=b[1,1] in `i'
			replace `X'_tau_hi=b[1,1]+1.56*(sqrt(v[1,1]))  in `i'
			replace `X'_tau_lo=b[1,1]-1.56*(sqrt(v[1,1]))  in `i'
			}
		}
	twoway rspike `X'_tau_hi `X'_tau_lo cat in 1/4,lc(gs13) || ///
	scatter `X'_tau cat in 1/4,yline(0) mfc(black) mc(gs13) msize(large) ///
	legend(off) ysize(5) xsize(3.5) name(gr`j',replace) nodraw
	local j=`j'+1
	}
graph combine gr1 gr2 gr3 gr4 g5,rows(1) ysize(4) xsize(6.5) ycommon

	

local name1 Film
local name2 Music
local name3 Books
local name4 Visual Arts
local name5 Dramatic Perf.
local i=1
foreach name in movies music books arts plays {
	qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city freq_`name'##c.educ_imp
	margins,dydx(educ_imp) at(freq_`name'=(1 4)) noatlegend predict(pr out(4))
	matrix s = r(b) /* capture slopes */
	graph twoway ///
	(function y = s[1, 1]*x, range(2 6)) ///
	(function y = s[1, 2]*x, range(2 6)), ///
	xlabel(2 "H.S. Drop out" 3 " " 4 " " 5 " " 6 "Grad/Prof.",labs(small) noticks) ytitle(Effect) ///
	xtitle("educ") scheme(lean2) ylab(,nogrid) ysize(6) xsize(4) ///
	legend(lab(1 "Never") lab(2 "Very Often") pos(6)) ///
	name(`name',replace) title("`name`i''") nodraw
	local i=`i'+1
	}
graph combine movies music books arts plays, ///
cols(5) ysize(4) xsize(8.5) xcommon ycommon name(educgraph,replace)

local name1 Film
local name2 Music
local name3 Books
local name4 Visual Arts
local name5 Dramatic Perf.
local i=1
foreach name in movies music books arts plays {
	qui oprobit talk_`name' c_educ_imp c_age_imp c_gender c_city freq_`name'##c.finc_imp
	margins,dydx(finc_imp) at(freq_`name'=(1 4)) noatlegend predict(pr out(4))
	matrix s = r(b) /* capture slopes */
	graph twoway ///
	(function y = s[1, 1]*x, range(1 6)) ///
	(function y = s[1, 2]*x, range(1 6)), ///
	xlabel(1 "20K or Less" 2 " " 3 " " 4 " " 5 " " 6 ">100K",labs(small) noticks) ytitle(Effect) ///
	xtitle("finc") scheme(lean2) ylab(,nogrid) ysize(6) xsize(4) ///
	legend(lab(1 "Never") lab(2 "Very Often") pos(6)) ///
	name(`name',replace) title("`name`i''") nodraw
	local i=`i'+1
	}
graph combine movies music books arts plays, ///
cols(5) ysize(4) xsize(8.5) xcommon ycommon name(fincgraph,replace)

graph combine educgraph fincgraph,ycommon xcommon rows(2) ysize(6.5) xsize(8.5)



/*testing for the equality of education and income effects*/
foreach name in movies music books arts plays {
	qui oprobit talk_`name' $xvars c_freq_`name'
	test c_educ_imp=c_finc_imp
	}

/*testing for the equality of education effects across domains*/
foreach name in movies music {
	qui oprobit talk_`name' $xvars c_freq_`name'
	test c_educ_imp=0.31
	test c_educ_imp=0.27
	}





/*interactions
local i=1
foreach name in movies music books arts plays {
	cap gen freqXeduc=c_educ_imp*c_freq_`name'
	cap gen freqXage=c_age_imp*c_freq_`name'
	cap gen freqXfinc=c_finc_imp*c_freq_`name'
	cap gen freqXgender=c_gender*c_freq_`name'
	cap gen freqXcity=c_city*c_freq_`name'
	cap gen ageXeduc=c_age_imp*c_educ_imp
	 ml model lf hcpoprobit ///
	(talk_`name' =$xvars c_freq_`name' ///
	freqXeduc freqXage freqXfinc freqXgender ageXeduc, nocons) ///
	(t1:) ///
	(t2:$`name') ///
	(t3:$`name') 
	qui ml maximize
	est store `name'
	drop freqX*
	}
foreach name in educ age finc gender city {
	gen freqX`name'=.
	}
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\tex\R2"
esttab movies music books arts plays using talk-tab3.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend keep(*X*)*/


foreach name in movies music books arts plays {
	ml model lf hcpoprobit ///
	(freq_`name' =$xvars, nocons) ///
	(t1:) ///
	(t2:$xvars) ///
	(t3:$xvars) 
	qui ml maximize
	est store `name'
	}
esttab movies music books arts plays,star(* .1)
do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\tex\R2"
esttab movies music books arts plays using freq-tab1.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend keep(eq1:)

do "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "C:\Users\olizardo\Google Drive\WORK\IN PROGRESS\CULTURE\lizardo-culture-talk-stratification\tex\R2"
esttab movies music books arts plays using freq-tab2.tex,stats(N bic chi2, ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend drop(eq1:)
