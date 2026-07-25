use "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\NSS-2002-2004-using.dta",clear
gen woman=gender==2
do "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\newlabs.do"
cd "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\tex\R2d"
sutex freq* talk* educ_imp finc_imp age_imp woman city, ///
file(desc) replace minmax key(tab:desc) placement(ht!) lab nobs ///
title(Descriptive statistic for predictor, control and response variables included in the analyses.) 
keep c_* talk* freq* educ* finc* age* fav*
foreach var of varlist c_*{
	qui sum `var'
	qui replace `var'=`var'/(2*r(sd))
	}
global xvars c_educ_imp c_finc_imp c_age_imp c_gender c_city 
recode educ_imp 1/2=2
save "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\small.dta",replace

/*Education effect*/
use "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\small.dta",clear
recode educ 8=.
foreach name in movies music books arts plays {
	for var talk_arts talk_plays : recode X 3 = 4
	qui oprobit talk_`name' c.educ c_finc_imp c_age_imp c_gender c_city freq_`name'
	margins,at(educ=(1(1)5)) predict(pr out(1)) predict(pr out(4))
	marginsplot,recast(line) noci scheme(economist) ///
	plotdim(_outcome, labels("Not at all" "Fairly/Very often")) ///
	graphr(color(white)) legend(region(color(white))) ///
	xtitle(" ") ytitle(" ") ///
	ylab(,nogrid) ysize(6) xsize(4)  ///
	xlabel(1 "< H.S." 2 " " 3 " " 4 " " 5 "Grad/Prof", noticks) ///
	name(`name',replace) title("`name'",size(large)) yline(0) graphr(margin(r+5)) ///
	legend(pos(6)) plot1opts(recast(line) lc(red)) plot2opts(recast(line) lc(blue))
	} 
	
graph combine movies music books arts plays,  ///
cols(5) ysize(2.5) xsize(6.5) xcommon ycommon name(educgraph,replace)  
cd "C:\Users\olizardo\Google Drive\city-college-presentation"
graph disp educgraph
graph export educgraph.pdf,as(pdf) name(educgraph) replace

/*Education effect across participation groups*/
use "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\small.dta",clear
qui sum educ
foreach name in movies music books  {
	qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city i.freq_`name'##c.educ
	qui margins,dydx(educ) at(freq_`name' = (1(1)4)) predict(pr out(4))
	marginsplot,yline(0) level(90) scheme(economist)  ///
	ciopts(color(red) msiz(vhuge)) plotopts(recast(bar)) ///
	plot1opts(barw(.5) bfc(blue) bc(white)) ///
	graphr(color(white)) legend(region(color(white))) ///
	xtitle("Engagement") ytitle(" ") ///
	ylab(,nogrid) ysize(6) xsize(4)  ///
	xlabel(1 "Infrequent" 2 " " 3 " " 4 "Frequent", noticks) ///
	name(`name',replace) title("`name'",size(large)) ///
	plotdim(_outcome, labels("Frequent Talk" "Infrequent Talk")) 
	} 
	
graph combine movies music books arts plays, graphr(color(white)) ///
cols(5) ysize(2.5) xsize(6.5) xcommon ycommon name(educ_part_int,replace)  
cd "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification"
graph export educ_part_int.png,as(png) replace




use "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\small.dta",clear
foreach name in movies music books arts plays {
	local title0 No
	local title1 Yes
	foreach k of numlist 0 1 {
		qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city ///
		c.freq_`name'##c.educ if favoperaclassical==`k'
		margins,dydx(freq_`name') at(educ=(1(1)5)) noatlegend predict(pr out(4))
		marginsplot,level(90) ///
		xtitle("Education") ///
		ytitle("Effect of Participation on Culture Talk")scheme(lean2) ///
		ylab(,nogrid) ysize(6) xsize(4)  ///
		xlab(1 "< H.S." 2 " " 3 " " 4 " " 5 "Grad/Prof",labs(medsmall) noticks) ///
		name(favmusic`k',replace) title("`title`k''",size(medsmall)) ///
		yline(0) graphr(margin(r+5)) ///
		legend(off) plotopts(recast(scatter) msize(medlarge) msym(diamond)) nodraw
		} 
	graph combine favmusic0 favmusic1,  ///
	cols(5) ysize(4) xsize(4) xcommon ycommon name(`name',replace)  ///
	title("Classical/Opera Favorite?") nodraw
	}
graph combine movies music books arts plays,  ///
cols(5) ysize(4) xsize(8) xcommon ycommon name(educ_part_int,replace)  
cd "C:\Users\olizardo\Google Drive\city-college-presentation"
graph export highbrow_talk.png,as(png) name(highbrow_talk) replace



use "C:\Users\olizardo\Google Drive\lizardo-culture-talk-stratification\small.dta",clear
foreach name in music {
	local title0 No
	local title1 Yes
	foreach k of numlist 0 1 {
		qui oprobit talk_`name' c_finc_imp c_age_imp c_gender c_city ///
		c.freq_`name'##c.educ if favoperaclassical==`k'
		margins,dydx(freq_`name') at(educ=(1(1)5)) noatlegend predict(pr out(4))
		marginsplot,level(90) ///
		xtitle("Education") ///
		ytitle("Effect of Participation on Culture Talk")scheme(lean2) ///
		ylab(,nogrid) ysize(6) xsize(4)  ///
		xlab(1 "< H.S." 2 " " 3 " " 4 " " 5 "Grad/Prof",labs(medsmall) noticks) ///
		name(favmusic`k',replace) title("`title`k''",size(medsmall)) ///
		yline(0) graphr(margin(r+5)) ///
		legend(off) plotopts(recast(scatter) msize(medlarge) msym(diamond)) nodraw
		} 
	graph combine favmusic0 favmusic1,  ///
	cols(5) ysize(6) xsize(4) xcommon ycommon name(`name',replace)  ///
	title("Classical/Opera Favorite?") nodraw
	}
graph disp music
cd "C:\Users\olizardo\Google Drive\city-college-presentation"
graph export music.png,as(png) name(music) replace
