

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






	

