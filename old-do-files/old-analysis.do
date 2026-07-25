
capture program drop myoprobit1
    program define myoprobit1
    args lnf xb  t1 t2 t3 sigma
    tempvar p1 p2 p3 p4
    qui gen double `p1'=ln(normal((`t1'-`xb')/exp(`sigma')))
    qui gen double `p2'=ln(normal((`t2'-`xb')/exp(`sigma'))-normal((`t1'-`xb')/exp(`sigma')))
    qui gen double `p3'=ln(normal((`t3'-`xb')/exp(`sigma'))-normal((`t2'-`xb')/exp(`sigma')))
    qui gen double `p4'=ln(normal((-`t3'+`xb')/exp(`sigma')))
    qui replace `lnf'=($ML_y1==1)*`p1' + ($ML_y1==2)*`p2' ///
				+($ML_y1==3)*`p3' + ($ML_y1==4)*`p4'
    end

xi: ml model lf myoprobit1 ///
(talk_movies =$xvars, nocons) ///
(t1:) ///
(t2:) ///
(t3:) ///
(sigma:c_freq_movies,nocons)
ml maximize,nolog

oglm talk_movies $xvars,het(c_freq_movies) link(probit)

foreach name in movies music books arts plays {
	forval i=1/4 {
		qui oprobit talk_`name' c_educ_imp c_finc_imp c_age_imp c_gender ///
		if freq_`name'==`i'
		est store mod`i'
		}
	esttab mod*
	}


foreach name in mo music books arts plays {
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
		graphopts(title("`title`i''"))
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
	graph export `name'_coeffs.png,as(png) replace name(`name'_coeffs) height(10000)
	window manage close graph
	}
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2c"

	graph export movies_coeffs.png,as(png) replace name(movies_coeffs) height(10000)

foreach name in movies music books arts plays {
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
	graphcoeff,varpos(1 2 3 4) labnames(Education Income Age Gender) ///
	model(oprobit) depvar(talk_`name') inputvars($spec c_freq_`name') ///
	filename(`name'.dta) datafile(small.dta) graphname(`name') ///
	graphopts(title("`name'",size(huge)))
	}
graph combine movies music books arts plays, ///
ysize(7.5) xsize(6) cols(1) iscale(.35) xcommon name("talk_coeffs1",replace) ///
scheme(lean2) title("Predictors of Talk",size(small))

cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
graph export talk_coeffs1.png,as(png) replace name(talk_coeffs1) height(10000)

foreach name in movies music books arts plays {
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
	graphcoeff,varpos(1 2 3 4) labnames(Education Income Age Gender) ///
	model(oprobit) depvar(freq_`name') inputvars($spec) ///
	filename(`name'.dta) datafile(small.dta) graphname(`name') ///
	graphopts(title("`name'",size(huge)))
	}
graph combine movies music books arts plays, ///
ysize(7.5) xsize(6) cols(1) iscale(.35) xcommon name("freq_coeffs1",replace) ///
scheme(lean2) title("Predictors of Consumption",size(small))

cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
graph export freq_coeffs1.png,as(png) replace name(freq_coeffs1) height(10000)























