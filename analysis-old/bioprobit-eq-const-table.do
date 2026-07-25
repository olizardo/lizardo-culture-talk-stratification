cap gen age_chi2=.
cap gen age_p=.
cap gen educ_chi2=.
cap gen educ_p=.
cap gen gender_chi2=.
cap gen gender_p=.
cap gen race_chi2=.
cap gen race_p=.
cap gen finc_chi2=.
cap gen finc_p=.
cap gen names=""
discard
*/estimating seemingly unrelated models*/
quietly {
local i=1
foreach name in movies music books arts plays{
	constapply2,stub(`name')
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),tech(nr) const(1/10) col	
	est store mod1
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),const(1/10 21/26) col tech(nr)
	est store mod2
	lrtest mod2 mod1
	replace age_chi2=r(chi2) in `i'
	replace age_p=r(p) in `i'
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),const(1/10 27/30) col tech(nr)	
	est store mod3
	lrtest mod3 mod1
	replace educ_chi2=r(chi2) in `i'
	replace educ_p=r(p) in `i'
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),const(1/10 40) col tech(nr)
	est store mod4
	lrtest mod4 mod1
	replace gender_chi2=r(chi2) in `i'
	replace gender_p=r(p) in `i'
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),const(1/10 36/39) col tech(nr)
	est store mod5
	lrtest mod5 mod1
	replace race_chi2=r(chi2) in `i'
	replace race_p=r(p) in `i'
	bioprobit (talk_`name'=$spec)(freq_`name'=$spec),const(1/10 31/35) col tech(nr)
	est store mod6
	lrtest mod6 mod1
	replace finc_chi2=r(chi2) in `i'
	replace finc_p=r(p) in `i'
	local i=`i'+1
	}
local i=1
local names Movies Music Books Arts Plays
foreach l of local names {
	replace names="`l'" in `i'	
	local i=`i'+1
	}
format *_chi* %9.2f
format *_p* %9.3f
}
listtex names  educ_chi2 educ_p age_chi2 age_p gender_chi2 gender_p race_chi2 race_p finc_chi2 finc_p in 1/5,type
