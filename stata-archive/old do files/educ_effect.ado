prog define educ_effect
syntax varlist [if]
mat drop _all
	/*Predicted probabilities of engaging in culture-mediated interaction and culture consumption by education*/
	local ed1 _Ieduc_2=0 _Ieduc_3=0 _Ieduc_4=0 _Ieduc_5=0
	local ed2 _Ieduc_2=1 _Ieduc_3=0 _Ieduc_4=0 _Ieduc_5=0
	local ed3 _Ieduc_2=0 _Ieduc_3=1 _Ieduc_4=0 _Ieduc_5=0
	local ed4 _Ieduc_2=0 _Ieduc_3=0 _Ieduc_4=1 _Ieduc_5=0
	local ed5 _Ieduc_2=0 _Ieduc_3=0 _Ieduc_4=0 _Ieduc_5=1
	local i=1
	foreach var of varlist `varlist' {
	qui xi:logit `var' $def_spec `if'
		forval j=1/5 {
			qui prvalue,delta x(`ed`j'') rest(mean)
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
