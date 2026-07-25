do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"
local domains Movies Music Books Arts Plays
local i=1
foreach name in movies music books arts plays {
	local domain : word `i' of `domains'
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",clear
	graphcoeff,varpos(1 2 3 4 5 6 7 8 9 10 11 12) ///
	labnames($labels) ///
	model(oprobit) depvar(freq_`name') inputvars($spec) ///
	filename(`name'.dta) datafile(small.dta) graphname(`name') ///
	graphopts(title("`domain'",size(huge)) xlab(-.75(.25).75) yscal(rev))
	window manage close graph
	local i=`i'+1		
	}
	
graph combine movies music books arts plays, ///
xsize(8.5) ysize(6) cols(2) iscale(.3)  ///
xcommon name(freqgraph,replace) scheme(lean2) title("Culture Consumption")
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-freq-stratification\tex\R2d"
graph export freqgraph.png,as(png) replace name(freqgraph) height(2500) 

bioprobit (talk_movies $spec c_freq_movies) (freq_movies $spec)
est store mod1
oprobit talk_movies $spec c_freq_movies
est store mod2
esttab mod1 mod2

bioprobit (talk_music $spec c_freq_music) (freq_music $spec)
est store mod1
oprobit talk_music $spec c_freq_music
est store mod2
esttab mod1 mod2

qui bioprobit (talk_books $spec c_freq_books) (freq_books $spec)
est store mod1
qui oprobit talk_books $spec c_freq_books
est store mod2
esttab mod1 mod2
