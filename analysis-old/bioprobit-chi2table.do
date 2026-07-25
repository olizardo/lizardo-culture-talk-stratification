do  "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\biprobit-analysis\dataproc"

quietly {
cap gen educ_chi21=.
cap gen educ_p1=.
cap gen educ_per1=.
cap gen age_chi21=.
cap gen age_p1=.
cap gen age_per1=.
cap gen gender_chi21=.
cap gen gender_p1=.
cap gen gender_per1=.
cap gen race_chi21=.
cap gen race_p1=.
cap gen race_per1=.
cap gen finc_chi21=.
cap gen finc_p1=.
cap gen finc_per1=.
cap gen educ_chi22=.
cap gen educ_p2=.
cap gen educ_per2=.
cap gen age_chi22=.
cap gen age_p2=.
cap gen age_per2=.
cap gen gender_chi22=.
cap gen gender_p2=.
cap gen gender_per2=.
cap gen race_chi22=.
cap gen race_p2=.
cap gen race_per2=.
cap gen finc_chi22=.
cap gen finc_p2=.
cap gen finc_per2=.
cap gen names=""
global allvars educ1 educ2 educ3 educ4 educ5 age1 age2 age3 age4 age5 age6 age7 finc1 finc2 finc3 finc4 finc5 finc6 gender1 gender2 race1 race2 race3 race4 race5 
*/estimating seemingly unrelated models*/
local i=1
foreach name in movies music books arts plays  {
	constapply2,stub(`name')
	const def 11 [athrho]_cons=0
	bioprobit (talk_`name'=$spec freq_`name')(freq_`name'=$spec),tech(nr) const(1/10 11) col	
	test [talk_`name']:$allvars freq_`name'
	local tc=r(chi2)
	test [freq_`name']:$allvars  
	local fc=r(chi2)
	test [talk_`name']:educ1 educ2 educ3 educ4 educ5 
	replace educ_chi21=r(chi2) in `i'
	replace educ_p1=r(p) in `i'
	replace educ_per1=r(chi2)/`tc' in `i'
	test [freq_`name']:educ1 educ2 educ3 educ4 educ5 
	replace educ_chi22=r(chi2) in `i'
	replace educ_p2=r(p) in `i'
	replace educ_per2=r(chi2)/`fc' in `i'
	test [talk_`name']: age1 age2 age3 age4 age5 age6 age7
	replace age_chi21=r(chi2) in `i'
	replace age_p1=r(p) in `i'
	replace age_per1=r(chi2)/`tc' in `i'
	test [freq_`name']: age1 age2 age3 age4 age5 age6 age7
	replace age_chi22=r(chi2) in `i'
	replace age_p2=r(p) in `i'
	replace age_per2=r(chi2)/`fc' in `i'
	test [talk_`name']: gender1 gender2
	replace gender_chi21=r(chi2) in `i'
	replace gender_p1=r(p) in `i'
	replace gender_per1=r(chi2)/`tc' in `i'
	test [freq_`name']: gender1 gender2
	replace gender_chi22=r(chi2) in `i'
	replace gender_p2=r(p) in `i'
	replace gender_per2=r(chi2)/`fc' in `i'
	test [talk_`name']:race1 race2 race3 race4 race5
	replace race_chi21=r(chi2) in `i'
	replace race_p1=r(p) in `i'
	replace race_per1=r(chi2)/`tc' in `i'
	test [freq_`name']:race1 race2 race3 race4 race5
	replace race_chi22=r(chi2) in `i'
	replace race_p2=r(p) in `i'
	replace race_per2=r(chi2)/`fc' in `i'
	test [talk_`name']:finc1 finc2 finc3 finc4 finc5 finc6
	replace finc_chi21=r(chi2) in `i'
	replace finc_p1=r(p) in `i'
	replace finc_per1=r(chi2)/`tc' in `i'
	test [freq_`name']:finc1 finc2 finc3 finc4 finc5 finc6
	replace finc_chi22=r(chi2) in `i'
	replace finc_p2=r(p) in `i'
	replace finc_per2=r(chi2)/`fc' in `i'
	local i=`i'+1
	}
local i=1
local names Movies Music Books Arts Plays
foreach l of local names {
	replace names="`l'" in `i'	
	local i=`i'+1
	}

format *_chi* *_per* %9.1f
format *_p* %9.3f
}
listtex names educ_chi21 educ_p1 educ_per1 age_chi21 age_p1 age_per1 gender_chi21 gender_p1 gender_per1 race_chi21 race_p1 race_per1 finc_chi21 finc_p1 finc_per1 in 1/5,type
listtex names educ_chi22 educ_p2 educ_per2 age_chi22 age_p2 age_per2 gender_chi22 gender_p2 gender_per2 race_chi22 race_p2 race_per2 finc_chi22 finc_p2 finc_per2 in 1/5,type
