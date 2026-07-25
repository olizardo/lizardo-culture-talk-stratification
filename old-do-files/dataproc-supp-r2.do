use "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",clear
cap drop *Xnum*
foreach name in movies music books arts plays {	
	local stub educ finc age gend black asn hisp marr urb
	local j=1
	foreach w of varlist c_educ_imp c_finc_imp c_age_imp women black asian hispanic married city {	
		local s : word `j' of `stub'
		qui gen `s'Xnum_`name'=`w'*num_`name'1
		local j=`j'+1
		}
	}
	
		cap lab var c_educ_imp "Education"
		cap lab var c_finc_imp "Family Income"
		cap lab var c_age_imp "Age"
		cap lab var educ_imp "Education"
		cap lab var finc_imp "Family Income"
		cap lab var age_imp "Age"
		cap lab var women "Gender (Women=1)"
		cap lab var black "Race (Afr. Amer.=1)"
		cap lab var asian "Race (Asian=1)"
		cap lab var hispanic "Race (Hispanic=1)"
		cap lab var city "Urban Location"
		cap lab var married "Married"
		cap lab var educXitem "Educ. X Talk"
		cap lab var fincXitem "Income X Talk"
		cap lab var ageXitem "Age X Talk"
		cap lab var gendXitem "Women X Talk"
		cap lab var blackXitem "Afr. Amer. X Talk"
		cap lab var asnXitem "Asian X Talk"
		cap lab var hispXitem "Hispanic X Talk"
		cap lab var marrXitem "Married X Talk"
		cap lab var urbXitem "Urban X Talk"
		foreach name in movies music books arts plays {	
			cap lab var educXnum_`name' "Educ. X Numeric Freq."
			cap lab var fincXnum_`name' "Income X Numeric Freq."
			cap lab var ageXnum_`name' "Age X Numeric Freq."
			cap lab var gendXnum_`name' "Women X Numeric Freq."
			cap lab var blackXnum_`name' "Afr. Amer. X Numeric Freq."
			cap lab var asnXnum_`name' "Asian X Numeric Freq."
			cap lab var hispXnum_`name' "Hispanic X Numeric Freq."
			cap lab var marrXnum_`name' "Married X Numeric Freq."
			cap lab var urbXnum_`name' "Urban X Numeric Freq."
			}
		cap lab var num_arts1 "Arts Frequency (Numeric)"
		cap lab var num_movies1 "Movies Frequency (Numeric)"
		cap lab var num_plays1 "Plays Frequency (Numeric)"
		cap lab var num_books1 "Books Frequency (Numeric)"
		cap lab var num_music1 "Music Frequency (Numeric)"
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta", replace
