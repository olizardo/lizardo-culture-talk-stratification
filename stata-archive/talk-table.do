do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"
est drop _all
local i=1
foreach name in movies music books arts plays {
	qui gologit2 talk_`name' c_educ_imp c_freq_`name',gamma(model`i') link(probit) autofit(.1)
	local i=`i'+1
	qui gologit2 talk_`name' $spec c_freq_`name',gamma(model`i') link(probit) autofit(.1)
	local i=`i'+1
	}
	
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
esttab mod*, varw(30) lab ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies)
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\asr-reviews-R2"
esttab mod* using talk-tab1.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1g %9.1g)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies)

do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"
est drop _all
local i=1
foreach name in movies music books arts plays {
	tempvar int
	qui oprobit talk_`name' $spec c_freq_`name' ///
	educX`name' fincX`name' ageX`name' gendX`name' urbanX`name'
	est store mod`i'
	local i=`i'+1
	}
	
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
esttab mod*, varw(30) lab ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies educXmusic educXmovies educXbooks educXmovies ///
educXarts educXmovies educXplays educXmovies fincXmusic fincXmovies fincXbooks fincXmovies ///
fincXarts fincXmovies fincXplays fincXmovies ageXmusic ageXmovies ageXbooks ageXmovies ///
ageXarts ageXmovies ageXplays ageXmovies gendXmusic gendXmovies gendXbooks gendXmovies ///
gendXarts gendXmovies gendXplays gendXmovies urbanXmusic urbanXmovies ///
urbanXbooks urbanXmovies urbanXarts urbanXmovies urbanXplays urbanXmovies)  keep(*Xm*)
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\asr-reviews-R2"
esttab mod* using talk-tab2.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1g %9.1g)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend ///
rename(c_freq_music c_freq_movies c_freq_books c_freq_movies c_freq_arts c_freq_movies ///
c_freq_plays c_freq_movies educXmusic educXmovies educXbooks educXmovies ///
educXarts educXmovies educXplays educXmovies fincXmusic fincXmovies fincXbooks fincXmovies ///
fincXarts fincXmovies fincXplays fincXmovies ageXmusic ageXmovies ageXbooks ageXmovies ///
ageXarts ageXmovies ageXplays ageXmovies gendXmusic gendXmovies gendXbooks gendXmovies ///
gendXarts gendXmovies gendXplays gendXmovies urbanXmusic urbanXmovies ///
urbanXbooks urbanXmovies urbanXarts urbanXmovies urbanXplays urbanXmovies) keep(*Xm*)


do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"

egen mean_freq=rowmean(freq*)
egen mean_talk=rowmean(talk*)
egen std_freq=rowsd(freq*)
egen std_talk=rowsd(talk*)
for var talk_movies-talk_music: gen dev_X=X-mean_talk
for var freq_books-freq_movies: gen dev_X=X-mean_freq
for var talk_movies-talk_music: gen std_X=(X-mean_talk)/std_talk
for var freq_books-freq_movies: gen std_X=(X-mean_freq)/std_freq
foreach name in movies music books arts plays {
	gen stdXdev_talk_`name'=std_freq*dev_talk_`name'
	gen stdXdev_freq_`name'=std_freq*dev_freq_`name'
	}


do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"



















