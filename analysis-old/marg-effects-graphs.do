use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\marg-effects.dta", clear
lab def evar ///
1 "Education (Less than H.S.=1)" ///
2 "Education (High School=1)" ///
3 "Education (Some Coll.=1)" ///
4 "Education (College=1)" ///
5 "Education (Postgraduate=1)" ///
6 "Age (18-24=1)" ///
7 "Age (25-29=1)" ///
8 "Age (30-34=1)" ///
9 "Age (35-39=1)" ///
10 "Age (40-49=1)" ///
11 "Age (50-64=1)" ///
12 "Age (65+=1)" ///
13 "Fam. Income ($<20K=1$)" ///
14 "Fam. Income (20K to 35K=1)" ///
15 "Fam. Income (35K to 50K=1)" ///
16 "Fam. Income (50K to 75K=1)" ///
17 "Fam. Income (75K to 100=1)" ///
18 "Fam. Income ($>100K=1$)" ///
19 "Gender (Women=1)" ///
20 "Race/Eth. (White=1)" ///
21 "Race/Eth. (Black/Afr. Amer.=1)" ///
22  "Race/Eth. (Asian=1)" ///
23 "Race/Eth. (Hispanic=1)" ///
24 "Race/Eth. (Other=1)"
gen evar=_n
lab val evar evar

graph bar  moviesbivariate moviesendogenous,over(evar,label(labsize(medium))) hor legend(off) ylab(-.3(.3).3,nogrid) title("Movies") name(gr1,replace) nodraw fysize(100) ///
fxsize(85) yline(0) bar(1, fcolor(white)) bar(2, color(black))
graph bar  musicbivariate musicendogenous,over(evar,label(nolab)) hor legend(off) ylab(-.2(.2).2,nogrid) title("Music") name(gr2,replace) nodraw fysize(100) fxsize(40) yline(0) bar(1, fcolor(white)) bar(2, color(black))
graph bar  booksbivariate booksendogenous,over(evar,label(nolab)) hor legend(off) ylab(-.2(.2).2,nogrid) title("Books") name(gr3,replace) nodraw fysize(100) fxsize(40) yline(0) bar(1, fcolor(white)) bar(2, color(black))
graph bar  artsbivariate artsendogenous,over(evar,label(nolab)) hor legend(off) ylab(-.2(.2).2,nogrid) title("Arts") name(gr4,replace) nodraw fysize(100) fxsize(40) yline(0) bar(1, fcolor(white)) bar(2, color(black))
graph bar  performancesbivariate performancesendogenous,over(evar,label(nolab)) hor legend(off) ylab(-.2(.2).2,nogrid) title("Performances") name(gr5,replace) nodraw fysize(100) fxsize(40) yline(0) bar(1, fcolor(white)) bar(2, color(black))
graph combine gr1 gr2 gr3 gr4 gr5,ycommon rows(1) cols(5) ysize(4) xsize(9)
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R1"
graph export marg-effects.png,as(png) replace