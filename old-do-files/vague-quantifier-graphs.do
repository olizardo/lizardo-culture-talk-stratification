cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
graph drop _all

/*tau1*/
foreach name in movies music books arts plays {
	graphcoeff,varp(11 12 13) ///
	labn(Educ Inc Age) ///
	model(gologit2) depvar(talk_`name') ///
	inputvars(educ_imp finc_imp age_imp women black asian hispanic married city) ///
	filename(`name'_cs) datafile(NSS-2002-2004-using.dta) graphname(`name'_tau1_mod1) bmat(e(gamma_b)) ///
	modopts(gamma) graphopts(title("`name'") nodraw)
	}
graph combine movies_tau1_mod1 music_tau1_mod1 books_tau1_mod1 arts_tau1_mod1 plays_tau1_mod1, ///
cols(1) ysize(7.5) xsize(3.25) xcommon ycommon name(tau1_combo1,replace) saving(tau1_combo1,replace) ///
title("tau(1) Baseline")

foreach name in movies music books arts plays {
	graphcoeff,varp(11 12 13) ///
	labn(Educ Inc Age) ///
	model(gologit2) depvar(talk_`name') ///
	inputvars(educ_imp finc_imp age_imp women black asian hispanic married city freq_`name') ///
	filename(`name'_cs) datafile(NSS-2002-2004-using.dta) graphname(`name'_tau1_mod2) bmat(e(gamma_b)) ///
	modopts(gamma) graphopts(title("`name'") nodraw)
	}
graph combine movies_tau1_mod2 music_tau1_mod2 books_tau1_mod2 arts_tau1_mod2 plays_tau1_mod2, ///
cols(1) ysize(7.5) xsize(3.25) xcommon ycommon name(tau1_combo2,replace) saving(tau1_combo2,replace) ///
title("tau(1) Adjusted")

graph combine tau1_combo1 tau1_combo2, ///
cols(2) ysize(7.5) xsize(5.5) xcommon ycommon ///
name(tau1_combo,replace) saving(tau1_combo2,replace)

/*tau2*/
foreach name in movies music books arts plays {
	graphcoeff,varp(21 22 23) ///
	labn(Educ Inc Age) ///
	model(gologit2) depvar(talk_`name') ///
	inputvars(educ_imp finc_imp age_imp women black asian hispanic married city) ///
	filename(`name'_cs) datafile(NSS-2002-2004-using.dta) graphname(`name'_tau2_mod1) bmat(e(gamma_b)) ///
	modopts(gamma) graphopts(title("`name'") nodraw)
	}
graph combine movies_tau2_mod1 music_tau2_mod1 books_tau2_mod1 arts_tau2_mod1 plays_tau2_mod1, ///
cols(1) ysize(7.5) xsize(3.25) xcommon ycommon name(tau2_combo1,replace) saving(tau2_combo1,replace) ///
title("tau(2) Baseline")

foreach name in movies music books arts plays {
	graphcoeff,varp(21 22 23) ///
	labn(Educ Inc Age) ///
	model(gologit2) depvar(talk_`name') ///
	inputvars(educ_imp finc_imp age_imp women black asian hispanic married city freq_`name') ///
	filename(`name'_cs) datafile(NSS-2002-2004-using.dta) graphname(`name'_tau2_mod2) bmat(e(gamma_b)) ///
	modopts(gamma) graphopts(title("`name'") nodraw)
	}
graph combine movies_tau2_mod2 music_tau2_mod2 books_tau2_mod2 arts_tau2_mod2 plays_tau2_mod2, ///
cols(1) ysize(7.5) xsize(3.25) xcommon ycommon name(tau2_combo2,replace) saving(tau2_combo2,replace) ///
title("tau(2) Adjusted")

graph combine tau2_combo1 tau2_combo2, ///
cols(2) ysize(7.5) xsize(5.5) xcommon ycommon ///
name(tau2_combo,replace) saving(tau2_combo2,replace)
