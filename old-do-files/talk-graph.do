do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\post-proc.do"
local domains Movies Music Books Arts Plays
local i=1
foreach name in movies music books arts plays {
	local domain : word `i' of `domains'
	cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
	use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\small.dta",clear
	graphcoeff,varpos(1 2 3 4 5 6 7 8 9 10 11 12) ///
	labnames($labels) ///
	model(oprobit) depvar(talk_`name') inputvars($spec c_freq_`name') ///
	filename(`name'.dta) datafile(small.dta) graphname(`name') ///
	graphopts(title("`domain'",size(huge)) xlab(-.75(.25).75) yscal(rev))
	window manage close graph
	local i=`i'+1		
	}
	
graph combine movies music books arts plays, ///
xsize(5) ysize(7.5) cols(1) iscale(.3) ///
xcommon name(talkgraph,replace) scheme(lean2) 
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2d"
graph export talkgraph.png,as(png) replace name(talkgraph) height(2500)



graph combine movies music books arts plays, ///
xsize(8.5) ysize(5.5) rows(2) iscale(.3)  ///
xcommon name(talkgraph,replace) scheme(lean2) 

