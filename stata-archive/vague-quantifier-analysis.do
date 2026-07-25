use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
est drop _all
local i=`i'+1
foreach name in movies music books arts plays {
	qui gologit2 talk_`name'  ///
	educ_imp finc_imp age_imp women black asian hispanic married city freq_`name' ///
	num_`name'1,gamma(mod`i') autofit(0.10)
	local i=`i'+1
	}
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\tex\R2b"
qui esttab mod1 mod2 mod3 mod4 mod5 using gologit.tex, ///
mti(Movies Music Books Arts Plays) star(* 0.10) ///
label replace booktabs long nogaps nonum

