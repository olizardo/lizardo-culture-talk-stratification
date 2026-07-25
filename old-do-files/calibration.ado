program define calibration
syntax varlist(max=1),midpoint(real) upper(real) lower(real) fuzzycuts(numlist)
	local uppercut : word 1 of `fuzzycuts'
	local lowercut : word 2 of `fuzzycuts'
	quietly {
		gen prod_`varlist'=.
		gen dev_`varlist'=`varlist'-`midpoint'
		local k=_N
		forval i=1/`k' {
			sum dev_`varlist' in `i',meanonly
			local dev=r(mean)
			if `dev'>=0 {
				replace prod_`varlist'=`dev'*(ln(`uppercut'/(1-`uppercut'))/(`upper'-`midpoint')) in `i'
				}
			if `dev'<0 {
				replace prod_`varlist'=`dev'*(ln(`lowercut'/(1-`lowercut'))/(`lower'-`midpoint')) in `i'
				}
			}
		gen cal_`varlist'=exp(prod_`varlist')/(1+exp(prod_`varlist'))
		}
	end

