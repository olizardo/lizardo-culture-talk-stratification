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
cap gen names=""
*/estimating seemingly unrelated models*/
local i=1
foreach name in movies music books arts plays  {
	constapply2,stub(`name')
	bioprobit (talk_`name'=$full_list)(freq_`name'=$full_list),tech(bhhh) const(1/20) col	
	test [talk_`name']:$controls
	local tc=r(chi2)
	test [freq_`name']:$controls
	local fc=r(chi2)
	test [talk_`name']:educ1 educ2 educ3 educ4 educ5
	replace educ_chi21=r(chi2) in `i'
	replace educ_p1=r(p) in `i'
	replace educ_per1=r(chi2)/`tc' in `i'
	test [freq_`name']:educ1  educ2 educ3 educ4 educ5
	replace educ_chi22=r(chi2) in `i'
	replace educ_p2=r(p) in `i'
	replace educ_per2=r(chi2)/`fc' in `i'
	test [talk_`name']: age1 age2 age3 age4 age6 age7
	replace age_chi21=r(chi2) in `i'
	replace age_p1=r(p) in `i'
	replace age_per1=r(chi2)/`tc' in `i'
	test [freq_`name']: age1 age2 age3 age4 age6 age7
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
	test [talk_`name']:black1 black2 hisp1 hisp2
	replace race_chi21=r(chi2) in `i'
	replace race_p1=r(p) in `i'
	replace race_per1=r(chi2)/`tc' in `i'
	test [freq_`name']:black1 black2 hisp1 hisp2
	replace race_chi22=r(chi2) in `i'
	replace race_p2=r(p) in `i'
	replace race_per2=r(chi2)/`fc' in `i'
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


listtex names educ_chi21 educ_p1 age_chi21 age_p1 gender_chi21 gender_p1 race_chi21 race_p1 educ_per1 age_per1 gender_per1 race_per1 in 1/5,type

listtex names educ_chi22 educ_p2 age_chi22 age_p2 gender_chi22 gender_p2 race_chi22 race_p2 educ_per2 age_per2 gender_per2 race_per2 in 1/5,type