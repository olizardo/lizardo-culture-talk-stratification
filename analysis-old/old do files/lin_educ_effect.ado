prog define lin_educ_effect
syntax varlist [if]
mat drop _all
local spec i.age i.gender i.black i.hispanic  i.married i.num_childs i.no_art_friends i.city i.year
	/*Predicted probabilities of engaging in culture-mediated interaction and culture consumption by education*/
	local i=1
	foreach var of varlist `varlist' {
	qui xi:logit `var' educ `spec' `if'
		forval j=1/5 {
			qui prvalue,delta x(educ=`j') rest(mean)
			mat a=r(pred)
			if `j'==1 {
				mat b`i'=a
				}
			if `j'> 1 {
				mat b`i'=b`i'\a
				}
			}
		local i=`i'+1
		}
local e=`i'-1
forval i=1/`e' {
	mat li b`i'
	}
end
