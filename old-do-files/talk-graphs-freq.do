use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
global spec c_educ_imp c_finc_imp c_age_imp c_gender c_black c_hispanic c_married c_city

keep c_* talk* freq*
foreach var of varlist c_educ_imp c_finc_imp c_age_imp ///
c_freq_movies c_freq_music c_freq_books c_freq_arts c_freq_plays {
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}
global spec c_educ_imp c_finc_imp c_age_imp c_gender c_black c_hispanic c_married c_city
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",replace

foreach name in movies music books arts plays {
	forval i=1/4 {
		qui oprobit talk_`name' c_educ_imp c_finc_imp c_age_imp c_gender ///
		if freq_`name'==`i'
		est store mod`i'
		}
	esttab mod*
	}


foreach name in movies music books arts plays {
	local title1 Not at all
	local title2 Not Very Often
	local title3 Fairly Often
	local title4 Very Often
	forval i=1/4 {
		cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
		use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",clear
		graphcoeff if freq_`name'==`i',varpos(1 2 3 4) labnames(Education Income Age Gender) ///
		model(oprobit) depvar(talk_`name') ///
		inputvars(c_educ_imp c_finc_imp c_age_imp c_gender) ///
		filename(`name'`i'.dta) datafile(small.dta) graphname(`name'`i') ///
		graphopts(title("`title`i''") xlab(-1(.5)1))
		window manage close graph
		}
	}
	
local styles Movies Music Books Arts Plays
local i=1
foreach name in movies music books arts plays {
	local domain : word `i' of `styles'
	graph combine `name'1 `name'2 `name'3 `name'4, ///
	ysize(5) xsize(5) cols(1) iscale(.35) ///
	xcommon name("`name'_coeffs",replace) scheme(lean2) ///
	title("Predictors of Talk at Different Consumption Levels (`domain')",size(small))
	local i=`i'+1
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
	graph export `name'_coeffs.png,as(png) replace name(`name'_coeffs) height(1000)
	window manage close graph
	}
