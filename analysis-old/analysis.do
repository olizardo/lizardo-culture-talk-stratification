do  "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\dataproc"

global spec i.educ i.age i.gender i.finc i.race

est drop _all
*/estimating bivariate probit models*/
local i=1
foreach name in movies music books arts plays  {
	constapply2,stub(`name')
	qui bioprobit (talk_`name'=$spec) (freq_`name'=$spec),const(1/10) col
	est store mod`i'
	local i=`i'+1
	}
do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\lab.do"
	esttab mod*, ///
	unstack stats(chi2 N,fmt(%9.2f %9.0f) ) ///
	plain lab par nogaps nolines onecell nomtitles tex ///
	varw(30) compress t(%9.2f) b(%9.2f)  ///
	keep(talk*:)
	
	esttab mod*, ///
	unstack stats(chi2 N,fmt(%9.2f %9.0f) ) ///
	plain lab par nogaps nolines onecell nomtitles tex ///
	varw(30) compress t(%9.2f) b(%9.2f)  ///
	keep(freq*:)

preserve
*/table 1*/
do  "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\bioprobit-chi2table" 
restore

preserve
*/table 2*/
do  "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\bioprobit-eq-const-table"
restore

do  "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\marg-effects-matrix"

est drop _all
local domain music
quietly {
	xi:oprobit talk_`domain' i.educ i.age i.gender i.finc i.race i.favoperaclassical if year==2004
	est store mod1
	xi:bioprobit (talk_`domain'=i.educ i.age i.gender i.finc i.race i.favoperaclassical) (favoperaclassical i.educ i.age i.gender i.finc i.race)
	est store mod2
	}
esttab mod1 mod2, ///
	unstack stats(chi2 N,fmt(%9.2f %9.0f) )  ///
	drop(cut1: cut2: cut3: cut11: cut12: cut13: cut21:   favoperaclassical: athrho:) ///
	plain lab par nogaps nolines onecell nomtitles tex ///
	compress t(%9.4f) b(%9.4f)  
	
mat drop _all
local i=1
foreach name in movies music books arts play {
	constapply2,stub(`name')
	quietly {
		bioprobit (talk_`name' $spec)(freq_`name' $spec),const(1/10) col
		mfx compute, predict(outcome(3,.)) nose
		}
		if `i'==1 {
			mat Marg=e(Xmfx_dydx)'
			}
		else if `i'>1 {
			mat Marg=Marg,e(Xmfx_dydx)'
			}
		disp in red `names'
		local i=`i'+1
		}
mat li Marg

local i=1
foreach name in movies music books arts play {
	constapply2,stub(`name')
	const def 11 [athrho]_cons=0
	quietly { 
		bioprobit (talk_`name' freq_`name' $spec)(freq_`name' $spec),const(1/11) col
		mfx compute, predict(outcome(3,.)) nose
		}
		if `i'==1 {
			mat Margadj=e(Xmfx_dydx)'
			}
		else if `i'>1 {
			mat Margadj=Margadj,e(Xmfx_dydx)'
			}
		disp in red `names'
		local i=`i'+1
		}
mat li Margadj
