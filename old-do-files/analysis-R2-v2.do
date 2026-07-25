use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
gen woman=gender==2
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
sutex freq* talk* educ_imp finc_imp age_imp woman city, ///
file(desc) replace minmax key(tab:desc) placement(ht!) lab nobs ///
title(Descriptive statistic for predictor, control and response variables included in the analyses.) 


keep c_* talk* freq* fav*
center fav*
drop fav*
foreach var of varlist c_*{
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",replace

global xvars c_educ_imp c_age_imp c_finc_imp c_gender c_city 
global movies c_educ_imp c_age_imp c_finc_imp c_gender c_city 
global music c_educ_imp c_age_imp   
global books c_educ_imp c_finc_imp c_gender  
global arts c_educ_imp c_finc_imp c_gender c_city 
global plays c_educ_imp c_age_imp c_finc_imp c_city  

capture program drop hcpoprobit
program define hcpoprobit
    args lnf xb  t1 t2 t3 sigma
    tempvar p1 p2 p3 p4
    qui gen double `p1'=ln(normal(`t1'-`xb'))
    qui gen double `p2'=ln(normal(`t2'-`xb')-normal(`t1'-`xb'))
    qui gen double `p3'=ln(normal(`t3'-`xb')-normal(`t2'-`xb'))
    qui gen double `p4'=ln(normal(-`t3'+`xb'))
    qui replace `lnf'=($ML_y1==1)*`p1' + ($ML_y1==2)*`p2' ///
				+($ML_y1==3)*`p3' + ($ML_y1==4)*`p4'
    end

/*testing for the equality of education and income effects*/
foreach name in movies music books arts plays {
	 ml model lf hcpoprobit ///
	(talk_`name' =$xvars c_freq_`name', nocons) ///
	(t1:) ///
	(t2:$`name') ///
	(t3:$`name') 
	qui ml maximize
	test c_educ_imp=c_finc_imp
	}

/*testing for the equality of education effects across domains*/
foreach name in movies music {
	 ml model lf hcpoprobit ///
	(talk_`name' =$xvars c_freq_`name', nocons) ///
	(t1:) ///
	(t2:$`name') ///
	(t3:$`name') 
	qui ml maximize
	test c_educ_imp=0.31
	test c_educ_imp=0.27
	}

foreach name in movies music books arts plays {
	 ml model lf hcpoprobit ///
	(talk_`name' =$xvars c_freq_`name', nocons) ///
	(t1:) ///
	(t2:$`name') ///
	(t3:$`name') 
	qui ml maximize
	est store `name'
	}
esttab movies music books arts plays 
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
esttab movies music books arts plays using talk-tab1a.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies) keep(eq1:) 

foreach name in  operaclass jazzblues rockpop folkcoun punkhvy {
	 ml model lf hcpoprobit ///
	(talk_music =$xvars c_fav`name',nocons) ///
	(t1:) ///
	(t2:$music) ///
	(t3:$music) 
	qui ml maximize
	est store `name'
	}
esttab operaclass jazzblues rockpop folkcoun punkhvy

/*interactions*/
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
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
esttab movies music books arts plays using talk-tab2.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend keep(*X*)


do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
esttab movies music books arts plays using talk-tab3.tex,stats(N bic chi2, ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies) drop(eq1:) 


 

foreach name in movies music books arts plays {
	ml model lf hcpoprobit ///
	(freq_`name' =$xvars, nocons) ///
	(t1:) ///
	(t2:$xvars) ///
	(t3:$xvars) 
	qui ml maximize
	est store `name'
	predict `name'_xb
	}
esttab movies music books arts plays,star(* .1)
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
esttab movies music books arts plays using freq-tab1.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1f %9.1f)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend keep(eq1:)

do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
lab var c_freq_movies "Consumption Freq."
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
esttab movies music books arts plays using freq-tab2.tex,stats(N bic chi2, ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend drop(eq1:)






