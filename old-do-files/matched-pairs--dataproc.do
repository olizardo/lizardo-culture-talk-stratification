/*processing data for analysis*/
use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta", clear
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
lab val rec_urban urban
lab val rec_marital marital
lab val rec_race race
center educ_imp finc_imp age_imp
foreach name in movies music books arts plays {
	preserve
		quietly {
			keep CASEID freq_`name' talk_`name' rec_* *imp _mi* gender married city race fav* num*`name'1
			gen resp=.
			expand 2
			qui bysort CASEID:replace resp=freq_`name' if _n==1
			qui bysort CASEID:replace resp=talk_`name' if _n==2
			gen item=.
			qui bysort CASEID:replace item=1 if _n==1
			qui bysort CASEID:replace item=2 if _n==2
			lab def item 1 "consumption" 2 "talk"
			lab val item item
			gen item1=item==2
			gen women=gender==2
			gen white=race==1
			gen black=race==2
			gen asian=race==3
			gen hispanic=race==4
			local stub educ finc age gend black asn hisp marr urb
			local j=1 
			foreach w of varlist c_educ_imp c_finc_imp c_age_imp women black asian hispanic married city {
				local s : word `j' of `stub'
				gen `s'Xitem=`w'*item1
				gen `s'Xfreq=`w'*freq_`name'
				gen `s'Xnum=`w'*num_`name'1
				local j=`j'+1
				}
		disp `i'
		do "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\labs.do"
		save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-`name'.dta",replace
		local i=`i'+1		
		restore
		}
	}
/*end data processing*/
