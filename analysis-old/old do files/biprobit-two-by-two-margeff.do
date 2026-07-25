local i=1
foreach name in movies music books arts plays {
	constapply,stub(`name')
	qui biprobit (talk_`name'bin=$full_list)(freq_`name'bin=$full_list),tech(bhhh) const(1/20) col
	*/predicting who talks without consuming (passing knowledge hypothesis)*/
	qui mfx,predict(p10) varlist(educ1 educ2 educ3 educ4 educ5 age1 age2 age3 age4 age5 age6 age7 gender2 hi_inc2 black2 hisp2) nose
	est store modp10_`i'
	*/predicting who consumes without talking (structural isolation hypothesis)*/
	qui mfx,predict(p01) varlist(educ1 educ2 educ3 educ4 educ5 age1 age2 age3 age4 age5 age6 age7 gender2 hi_inc2 black2 hisp2) nose
	est store modp01_`i'
	disp `i'
	local i=`i'+1
	}



forval i=1/5 {
	esttab modp*_`i',margin keep(educ* age* gender*) unstack b(%9.2f) not
	}

do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\lab.do"
local i=1
foreach name in movies music books arts plays {
	esttab modp10_`i',margin keep(educ* age* hi_inc2 gender2 black2 hisp2) drop(talk_`name'bin:) unstack plain lab tex compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles noeqli nodep noobs nonum stats(Xmfx_y)
	local i=`i'+1
	}
esttab modp10_1 modp10_2 modp10_3 modp10_4 modp10_5,margin keep(educ* age* hi_inc2 gender2 black2 hisp2) drop() unstack plain lab tex compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles noeqli nodep noobs nonum stats(Xmfx_y)



esttab  modp10_1 modp10_2 modp10_3 modp10_4 modp10_5,margin keep(educ* age* gender2 black2 hisp2) not plain lab tex compress b(%9.3f) par nogaps nolines onecell nomtitles noeqli nodep noobs nonum stats(Xmfx_y)

esttab  modp01_1 modp01_2 modp01_3 modp01_4 modp01_5,margin keep(educ* age* gender2 black2 hisp2) not plain lab tex compress b(%9.3f) par nogaps nolines onecell nomtitles noeqli nodep noobs nonum stats(Xmfx_y)



