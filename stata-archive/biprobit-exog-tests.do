cap gen chi2=.
cap gen chi2_p=.
local i=1
foreach name in movies music books arts plays {
	*\testing whether tastes are exogenous vis a vis interaction
	qui xi:biprobit (talk_`name'bin=$talk_spec freq_`name'bin)(freq_`name'bin=$`name'freq_spec)
	est store mod1
	qui xi:biprobit (talk_`name'bin=$talk_spec  freq_`name'bin)(freq_`name'bin=$`name'freq_spec),const(1)
	est store mod2
	lrtest mod1 mod2
	replace chi2=r(chi2) in `i'
	replace chi2_p=r(p) in `i'
	local i=`i'+1
	*\testing whether interaction is exogenous vis a vis tastes
	qui xi:biprobit (freq_`name'bin=$`name'freq_spec  talk_`name'bin)(talk_`name'bin=$talk_spec)
	est store mod1
	qui xi:biprobit (freq_`name'bin=$`name'freq_spec talk_`name'bin)(talk_`name'bin=$talk_spec),const(1)
	est store mod2
	lrtest mod1 mod2
	replace chi2=r(chi2) in `i'
	replace chi2_p=r(p) in `i'
	local i=`i'+1
	}
format chi2_p %9.4f
format chi2 %9.1f
list chi2 chi2_p in 1/10,clean
listtex chi2 chi2_p in 1/10,type rstyle(tabular)