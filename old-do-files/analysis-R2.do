use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
polychoric freq_books-freq_movies
pcamat r(R),n(`r(N)')
predict activ_consump
foreach name in books arts plays movies {
	gen moretalk_`name'=talk_`name'>freq_`name'
	}
gen moretalk_music=talk_music>=freq_music
gen married=marital==1
gen white=race==1
gen black_hisp=race==2|race==4
gen black=race==2
gen city=urban<3
global spec imp_educ imp_age imp_finc i.gender i.city 




local i=1
foreach name in movies music books arts plays {
	qui xi:logit moretalk_`name' $spec freq_`name'
	est store mod`i'
	local i=`i'+1
	}


do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\labs.do"
esttab mod1 mod2 mod3 mod4 mod5,stats(N bic chi2, labels("Obs" "BIC" "Model \chi^{2}")) lab varw(20) ///
rename(freq_music freq_movies freq_books freq_movies freq_arts freq_movies freq_plays freq_movies) 

esttab mod11 mod12 mod13 mod14 mod15,stats(N bic chi2, labels("Obs" "BIC" "Model \chi^{2}")) lab varw(20) ///
rename(freq_music freq_movies freq_books freq_movies freq_arts freq_movies freq_plays freq_movies) 

/*regression table 1*/
esttab mod1 mod2 mod3 mod4 mod5,stats(N bic chi2, labels("Obs" "BIC" "Model \chi^{2}")) ///
varw(30) lab tex nolines nogaps onecell ///
refcat(_Igender_2 "Gender (Men=1)" _Icity_1 "Rural Location")  ///
rename(freq_music freq_movies freq_books freq_movies freq_arts freq_movies freq_plays freq_movies) 

local i=6
foreach name in movies music books arts  {
	qui xi:logit moretalk_`name' i.educ i.age i.finc i.gender i.urban i.married freq_`name' activ_consump
	est store mod`i'
	local i=`i'+1
	}
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\labs.do"
esttab mod6 mod7 mod8 mod9 mod10,,stats(N bic chi2, labels("Obs" "BIC" "Model \chi^{2}$")) ///
lab keep(_Ied* activ* freq*) varw(30) ///
rename(freq_music freq_movies freq_books freq_movies freq_arts freq_movies freq_plays freq_movies) 

esttab mod6 mod7 mod8 mod9 mod10,,stats(N bic chi2, labels("Obs" "BIC" "Model \chi^{2}$")) ///
varw(30) lab tex nolines nogaps onecell ///
refcat(_Ieduc_2 "Educ: < High School=1") keep(*ed* activ* freq*)  ///
rename(freq_music freq_movies freq_books freq_movies freq_arts freq_movies freq_plays freq_movies) 

qui gen b=.
qui gen lo=.
qui gen hi=.
gen cat=_n in 1/5
lab val cat educat2

local toplist .6 .6 .25 .25 .25
local gaplist .1 .1 .05 .05 .05
local domainlist Movies Music Reading Arts Plays
local j=1
foreach name in movies music books arts plays {
	quietly {
		logit moretalk_`name' $spec freq_`name'
		margins,at(imp_age=5 imp_finc=3 gender=2 city=1 freq_`name'=3 imp_educ=(1(1)6))
		}
	local top : word `j' of `toplist'
	local graphname : word `j' of `domainlist'
	local gap : word `j' of `gaplist'
	sum moretalk_`name' if imp_age=5 & imp_finc=3 & gender=2 & city=1 ,meanonly 
	local yline=`r(mean)'
	mat b=r(b)'
	mat V=r(V)
	forval i=1(1)5 {
		replace b=b[`i',1] in `i'
		replace lo=b[`i',1]-(sqrt(V[`i',`i'])*1.96) in `i'
		replace hi=b[`i',1]+(sqrt(V[`i',`i'])*1.96) in `i'
		}
	twoway connected b cat in 1/5,mfc(black) msym(circle) msize(medlarge) || rcap lo hi cat in 1/5, ///
	ylab(0(`gap')`top',nogrid) xlab(,val angle(45) labs(small))  legend(off) xtitle("") xsize(3) ysize(4) ///
	name(`name'plot,replace) title("`grapname'") yline(`yline')
	local j=`j'+1
	}
graph combine moviesplot musicplot booksplot artsplot  playsplot,rows(2) ysize(7) xsize(6) holes(3)
