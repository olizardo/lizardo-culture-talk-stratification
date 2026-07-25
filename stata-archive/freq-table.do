do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"
est drop _all
local i=1
foreach name in movies music books arts plays {
	qui oprobit freq_`name' $spec 
	est store mod`i'
	local i=`i'+1
	}
	
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\newlabs.do"
esttab mod*, varw(30) lab 
esttab mod* using freq-tab1.tex,stats(N bic chi2, ///
labels("Obs" "BIC" "Model $\chi^{2}$") fmt(%9.0f %9.1g %9.1g)) ///
lab varw(20) cells(b(star fmt(%9.2f)) t(par fmt(%9.2f))) starlevels(* .1) ///
onecell nogaps width(\hsize) booktabs ///
mtitles(Movies Music Books Arts Plays) nonotes nonumbers replace nolegend 
