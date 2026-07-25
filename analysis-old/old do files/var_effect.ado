prog define var_effect
syntax varlist [if],x(varlist) cats(integer)
mat drop _all
	/*Predicted probabilities of engaging in culture-mediated interaction and culture consumption by education*/
	local i=1
	foreach y of varlist `varlist' {
	qui xi:logit `y' `x' $def_spec `if'
		forval j=1/`cats' {
			qui prvalue,delta x(`x'=`j') rest(mean)
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
