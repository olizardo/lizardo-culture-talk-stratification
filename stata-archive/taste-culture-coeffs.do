do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\dataproc.do"
est drop _all
local i=1
foreach name in operaclassical jazzblues rockpop  punkhvymetal christgospel folkcountry   {
	quietly {
		if "`name'"=="punkhvymetal" {
			global spec educ1-educ5 age1-age7 gender1-gender2 race1-race5	
			}
		else {
			global spec educ1-educ5 age1-age7 finc1-finc6 gender1-gender2 race1-race5	
			}
		tab fav`name',g(fav`name')
		constapply3,stub1(music) stub2(`name')
		bioprobit (talk_music=$spec fav`name'1 fav`name'2)(fav`name'=$spec),const(1/11) col 
		if `e(p_c)'>0.05 {
			const def 12 [athrho]_cons=0
				bioprobit (talk_music=$spec fav`name'1 fav`name'2)(fav`name'=$spec),const(1/12) col  
				}
		disp `i'
		est store mod`i'
		local i=`i'+1
		}
	}
esttab mod*,keep(fav*2 educ*) unstack plain lab compress t(%9.2f) b(%9.2f) par nogaps nolines nomtitles noeqli nodep nonum tex onecell
esttab mod*,keep(educ*) unstack plain lab compress t(%9.2f) b(%9.2f) par nogaps nolines nomtitles noeqli nodep nonum tex  drop(talk_music:) onecell



