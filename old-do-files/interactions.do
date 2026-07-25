gen ageXeduc=c_age_imp*c_educ_imp
gen educXfinc=c_educ_imp*c_finc_imp
gen gendXeduc=c_gender*c_educ_imp
gen gendXage=c_gender*c_age_imp
gen cityXeduc=c_city*c_educ_imp
foreach name in movies music books arts plays {
	gen educX`name'=c_freq_`name'*c_educ_imp
	gen fincX`name'=c_freq_`name'*c_finc_imp
	gen ageX`name'=c_freq_`name'*c_age_imp
	gen gendX`name'=c_freq_`name'*c_gender
	gen urbanX`name'=c_freq_`name'*c_city
	}
