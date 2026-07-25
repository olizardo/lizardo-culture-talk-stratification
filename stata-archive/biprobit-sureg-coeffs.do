*/estimating seemingly unrelated models*/
local i=1
foreach name in movies music books arts plays  {
	constapply2,stub(`name')
	bioprobit (talk_`name'=$full_list)(freq_`name'=$full_list),tech(bhhh) const(1/20) col	
	est store mod`i'
	local i=`i'+1
	}
do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\lab.do"
esttab mod1 mod2 mod3,unstack plain lab tex compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles noeqli nodep nonum drop(_cons gender1 hi_inc1 black1 hisp1 city1 year1 married1 children1)

esttab mod4 mod5,unstack plain lab tex compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles noeqli nodep nonum drop(_cons gender1 hi_inc1 black1 hisp1 city1 year1 married1 children1)


