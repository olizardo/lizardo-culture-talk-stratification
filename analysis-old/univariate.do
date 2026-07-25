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