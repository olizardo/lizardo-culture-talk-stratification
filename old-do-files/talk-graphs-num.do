use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
global spec c_educ_imp c_finc_imp c_age_imp c_gender c_black c_hispanic c_married c_city

keep c_* talk* freq* num*
foreach var of varlist c_educ_imp c_finc_imp c_age_imp ///
c_freq_movies c_freq_music c_freq_books c_freq_arts c_freq_plays {
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}
global spec c_educ_imp c_finc_imp c_age_imp c_gender c_black c_hispanic c_married c_city
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",replace


local styles Movies Music Books Arts Plays
local j=1
foreach name in movies music books arts plays {
	local domain : word `j' of `styles'
	forval i=1/3 {
		cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",clear
		graphcoeff if num_`name'1==`i',varpos(1 2 3 4) labnames(Education Income Age Gender) ///
		model(oprobit) depvar(talk_`name') ///
		inputvars(c_educ_imp c_finc_imp c_age_imp c_gender) ///
		filename(`name'`i'.dta) datafile(small.dta) graphname(`name'`i') ///
		graphopts(title("`domain'") xlab(-1(.5)1))
		window manage close graph
		}
	local j=`j'+1
	}
local title1 Zero
local title2 One to Three
local title3 Four+
forval i=1/3 {
	graph combine movies`i' music`i' books`i' arts`i' plays`i', ///
	ysize(7) xsize(5) cols(1) iscale(.35) ///
	xcommon name("coeffs_num`i'",replace) scheme(lean2) ///
	title("`title`i''",size(small))
	window manage close graph
	}	
graph combine coeffs_num1 coeffs_num2 coeffs_num3, ///
xsize(8.5) ysize(3.75) rows(1) scheme(lean2) name("main",replace) ///
title("Predictors of Talk at Different Consumption Levels",size(small))
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
graph export talk-fig.png,as(png) replace name(main) height(2500)

	
	
	
