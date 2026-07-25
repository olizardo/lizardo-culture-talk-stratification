do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\dataproc.do"
local i=1
foreach name in movies music books arts plays  {
	quietly {
		constapply2,stub(`name')
		const def 11 [athrho]_cons=0
		bioprobit (talk_`name' $spec freq_`name') (freq_`name' $spec),col const(1/11)
		est store mod`i'
		local i=`i'+1
		}
	}
	do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\lab.do"

	esttab mod*,keep(talk*: freq*) unstack plain lab compress t(%9.2f) b(%9.2f) par nogaps nolines nomtitles noeqli nodep nonum  onecell tex
	

	