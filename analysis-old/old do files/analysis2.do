use "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\NSS-2002-2004-using.dta", clear
cd "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do"
do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\globals.do"
ren num_childs children
replace hi_inc=0 if hi_inc==.
drop musicmore* imp* *kid* num* CASEID
for var educ age city black hisp children married *more* no_art*:drop if X==.
cap drop *bin
gen freq_moviesbin=freq_movies>=3 if freq_movies~=.
gen freq_booksbin=freq_books>=3 
gen freq_musicbin=freq_music==4
gen freq_artsbin=freq_arts>=3 if freq_arts~=.
gen freq_playsbin=freq_plays>=3 if freq_plays~=.
gen talk_booksbin=talk_books>=3
gen talk_musicbin=talk_music>=3
gen talk_moviesbin=talk_movies>=3
gen talk_artsbin=talk_arts>=3 if talk_arts~=.
gen talk_playsbin=talk_plays>=3 if talk_plays~=.
for var *bin fav*:lab val X plusmin

local i=1
*/predicting who talks without consuming (passing knowledge hypothesis)*/
foreach name in movies music `name' arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	qui mfx,predict(p01)
	est store modp01_`i'
	local i=`i'+1
	}
local i=1
*/predicting who consumes without talking (low cultural capital/restricted networks hypothesis)*/
foreach name in movies music `name' arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	qui mfx,predict(p10)
	est store modp10_`i'
	local i=`i'+1
	}
local i=1
*/predicting who talks and consumes*/
foreach name in movies music `name' arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	qui mfx,predict(p11)
	est store modp11_`i'
	local i=`i'+1
	}
local i=1
*/predicting who does not talk and does not consume*/
foreach name in movies music `name' arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	qui mfx,predict(p00)
	est store modp00_`i'
	local i=`i'+1
	}


*/estimating seemingly unrelated models*/
local i=1
foreach name in movies music books arts plays  {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$`name'freq_spec),tech(bhhh)
	est store mod`i'
	local i=`i'+1
	}
do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\lab.do"
esttab mod*,unstack keep(freq* fav*) stats(rho21 serho21 rho31 serho31 rho32 serho32 chi2_c) plain lab tex compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles

cap gen educ_chi21=.
cap gen educ_p1=.
cap gen educ_df1=.
cap gen educ_per1=.
cap gen age_chi21=.
cap gen age_p1=.
cap gen age_df1=.
cap gen age_per1=.
cap gen gender_chi21=.
cap gen gender_p1=.
cap gen gender_df1=.
cap gen gender_per1=.
cap gen educ_chi22=.
cap gen educ_p2=.
cap gen educ_df2=.
cap gen educ_per2=.
cap gen age_chi22=.
cap gen age_p2=.
cap gen age_df2=.
cap gen age_per2=.
cap gen gender_chi22=.
cap gen gender_p2=.
cap gen gender_df2=.
cap gen gender_per2=.

local i=1
foreach name in movies music books arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	test [freq_`name'bin]: _Ieduc_2 _Ieduc_3 _Ieduc_4 _Ieduc_5 _Ihi_inc_1 _Iage_2 _Iage_3 _Iage_4 _Iage_5 _Iage_6 _Iage_7 _Igender_2 _Iblack_1 _Ihispanic_1 _Imarried_1 _Ichildren_1 _Icity_1 _Iyear_2004
	local c=r(chi2)
	test [talk_`name'bin]: _Ieduc_2 _Ieduc_3 _Ieduc_4 _Ieduc_5
	replace educ_chi21=r(chi2) in `i'
	replace educ_p1=r(p) in `i'
	replace educ_df1=r(df) in `i'
	replace educ_per1=r(chi2)/`c' in `i'
	test [freq_`name'bin]: _Ieduc_2 _Ieduc_3 _Ieduc_4 _Ieduc_5
	replace educ_chi22=r(chi2) in `i'
	replace educ_p2=r(p) in `i'
	replace educ_df1=r(df) in `i'
	replace educ_per2=r(chi2)/`c' in `i'
	test [talk_`name'bin]: _Iage_2 _Iage_3 _Iage_4 _Iage_5 _Iage_6 _Iage_7
	replace age_chi21=r(chi2) in `i'
	replace age_p1=r(p) in `i'
	replace age_df1=r(df) in `i'
	replace age_per1=r(chi2)/`c' in `i'
	test [freq_`name'bin]: _Iage_2 _Iage_3 _Iage_4 _Iage_5 _Iage_6 _Iage_7
	replace age_chi22=r(chi2) in `i'
	replace age_p2=r(p) in `i'
	replace age_df2=r(df) in `i'
	replace age_per2=r(chi2)/`c' in `i'
	test [talk_`name'bin]: _Igender_2
	replace gender_chi21=r(chi2) in `i'
	replace gender_p1=r(p) in `i'
	replace gender_df1=r(df) in `i'
	replace gender_per1=r(chi2)/`c' in `i'
	test [freq_`name'bin]: _Igender_2
	replace gender_chi22=r(chi2) in `i'
	replace gender_p2=r(p) in `i'
	replace gender_df2=r(df) in `i'
	replace gender_per2=r(chi2)/`c' in `i'
	local i=`i'+1
	}
format *_chi* *per* %9.2f
format *_p* %9.3f
listtex educ_chi21 educ_p1 educ_df1 age_chi21 age_p1 age_df1 gender_chi21 gender_p1 gender_df1 educ_per1 age_per1 gender_per1 in 1/5,type

listtex educ_chi22 educ_p2 educ_df2 age_chi22 age_p2 age_df2 gender_chi22 gender_p2 gender_df2 educ_per2 age_per2 gender_per2 in 1/5,type
	
cap gen GvsC_chi2=.
cap gen GvsC_p=.
cap gen CvsSC_chi2=.
cap gen CvsSC_p=.
cap gen SCvsHS_chi2=.
cap gen SCvsHS_p=.
local i=1
foreach name in movies music books arts plays {
	qui xi:biprobit (talk_`name'bin=$talk_spec) (freq_`name'bin=$talk_spec),tech(bhhh)
	test [freq_`name'bin]_Ieduc_5=[freq_`name'bin]_Ieduc_4
	replace GvsC_chi2=r(chi2) in `i'
	replace GvsC_p=r(p) in `i'
	test [freq_`name'bin]_Ieduc_4=[freq_`name'bin]_Ieduc_3
	replace CvsSC_chi2=r(chi2) in `i'
	replace CvsSC_p=r(p) in `i'
	test [freq_`name'bin]_Ieduc_3=[freq_`name'bin]_Ieduc_2
	replace SCvsHS_chi2=r(chi2) in `i'
	replace SCvsHS_p=r(p) in `i'
	local i=`i'+1
	}
list  GvsC_chi2 GvsC_p CvsSC_chi2 CvsSC_p SCvsHS_chi2 SCvsHS_p in 1/5



	




/*univariate distribution of culture-mediated interaction with confidence intervals*/
foreach name in movies books plays arts music {
	qui tab talk_`name',g(talk_`name')
	ci talk_`name'1-talk_`name'4,bin
	}
drop talk_movies1-talk_music4

/*univariate distribution of culture-mediated interaction with confidence intervals (high consumers)*/
foreach name in movies books plays arts music {
	qui tab talk_`name',g(talk_`name')
	ci talk_`name'1-talk_`name'4 if freq_`name'>2&freq_`name'~=.,bin
	}
drop talk_movies1-talk_music4

/*univariate distribution of culture-mediated interaction with confidence intervals (scale)*/
	tab freq_talk_scal,g(freq_talk_scal)
	ci freq_talk_scal1-freq_talk_scal6,bin sep(0)
	drop freq_talk_scal1-freq_talk_scal6

chi2table talk_music freq_music if favmusic1==2,fac(educ age gender) cmd(oprobit)

/*estimating the relative effects of age and education on culture consumption using the subjective frequency indicator of consumption*/
chi2table freq_movies freq_books freq_music freq_arts freq_plays,fac(educ age gender) cmd(oprobit) 

/*estimating the education+age/culture mediated interaction association*/
chi2table talk_movies talk_books talk_music talk_plays talk_arts,fac(educ age gender) cmd(oprobit) 

/*estimating the relative effects of age and education on culture consumption using the numeric frequency indicator of consumption*/
chi2table num_books num_arts num_plays num_movies,fac(educ age gender) cmd(ologit) 

/*estimating the relative effects of age and education on musical taste*/
chi2table favrockpop favfolk favchris favjazz favopera favpunk if year==2004,fac(educ age black) cmd(probit) 

/*estimating the relative effects of age and education on literary taste*/
chi2table favmystery favscifi favromance favfictlit favselfhelp favhistory favbio favsports favrel,fac(educ age gender) cmd(logit) 
	

/*Predicted probabilities of engaging in culture-mediated interaction (binary measure) and culture consumption by education*/
educ_effect freq_talk_movies freq_talk_books freq_talk_music freq_talk_plays freq_talk_arts 
/*Predicted probabilities of engaging in culture-mediated interaction (binary measure) and culture consumption by education*/
educ_effect freq_movies_bin freq_books_bin freq_music_bin freq_plays_bin freq_arts_bin

/*Predicted probabilities of engaging in culture-mediated interaction (binary measure) in the music domain for members of different music consumption communities by education*/
lin_educ_effect freq_talk_music if favrockpop==1
test educ
lin_educ_effect freq_talk_music if favfolkcountry==1
test educ
lin_educ_effect freq_talk_music if favjazzblues==1
test educ
lin_educ_effect freq_talk_music if favoperaclassical==1
test educ

/*Estimating the effect of taste for particular musical genres on the odds of using music as a cultural resource in conversation*/
foreach var of varlist favrockpop favfolkcountry favchristgospel favjazzblues favoperaclassica {
	var_effect freq_talk_music,x(`var') cats(1)
	}
	
/*Estimating the effect of taste for particular literary genres on the odds of using books as a cultural resource in conversation*/
foreach var of varlist favmystery-favrel {
	disp "`var'"
	var_effect freq_talk_books,x(`var') cats(1)	
	}
foreach var of varlist favmystery-favrel {
	disp "`var'"
	var_effect freq_talk_books if gender==1,x(`var') cats(1) /*for men*/	
	}
foreach var of varlist favmystery-favrel {
	disp "`var'"
	var_effect freq_talk_books if gender==2,x(`var') cats(1) /*for women*/
	}


/*Estimating how the marginal effect of education is reduced after controlling for consumption*/
foreach name in movies books plays arts music {
	quietly {
		est drop _all
		xi:ologit talk_`name' $def_spec
		mfx compute,predict(outcome(4))
		est store mod1
		xi:ologit talk_`name' i.freq_`name' i.age i.educ i.gender 	i.black i.hispanic i.asian i.married i.city
		mfx compute,predict(outcome(4))
		est store mod2
		}
	disp "`name'"
	esttab mod1 mod2,margin keep(_Ied*) staraux
	}
	

est drop _all
local i=1
foreach var of varlist  favrockpop favfolkcountry favchristgospel favjazzblues favoperaclassical {
	qui xi: ologit talk_music $def_spec if `var'==1
	mfx compute,predict(outcome(4))
	est store mod`i'	
	local i=`i'+1
	}
esttab mod*,margin keep(_Ied*) staraux






	

