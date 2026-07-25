program define graphcoeff
version 10.1
syntax [if] [in], ///
VARPos(numlist) LABNames(string) ///
model(string) depvar(string) inputvars(string) ///
filename(string) datafile(string) graphname(string) ///
[,conf1(integer 90) conf2(integer 50) graphopts(string) modopts(string) bmat(string)]

/* generating resultsset */
local length : list sizeof varpos
local numlabs : list sizeof labnames
	clear 
	set obs `length'
	if "`bmat'"=="" {
		local bmat e(b)
		}
	quietly {
		gen __b=. 
		gen __hi`conf1'=.
		gen __lo`conf1'=.
		gen __hi`conf2'=.
		gen __lo`conf2'=.
		gen __lab=_n
		}
		local numvars : list sizeof inputvars
		if `length'>`numvars' {
			disp as error "Length of selection vector must not exceed the number of predictors"
			exit
			}
		if `numlabs'!=`length' {
			disp as error "Number of labels must match length of selection vector"
			exit
			}
	local labdef
	local i=1
	foreach name of local labnames {
		if `i'==1 {
			label define lab `i' "`name'"
			}
		if `i'>1 {
			label define lab `i' "`name'",add
			}
		local i=`i'+1
		}
	lab val __lab lab
	save `filename',replace
	use `datafile',clear
	qui `model' `depvar' `inputvars' `if',`modopts'
	mat b=`bmat'
	mat v=e(V)
	use `filename',clear
	local c1=invnorm(1-(((100-`conf1')/2)/100))
	local c2=invnorm(1-(((100-`conf2')/2)/100))
	local k=1
	foreach i of numlist `varpos' {
		quietly {
			replace __b=b[1,`i'] in `k'
			replace __hi90=__b+(`c1'*sqrt(v[`i',`i'])) in `k'
			replace __lo90=__b-(`c1'*sqrt(v[`i',`i'])) in `k'
			replace __hi50=__b+(`c2'*sqrt(v[`i',`i'])) in `k'
			replace __lo50=__b-(`c2'*sqrt(v[`i',`i'])) in `k'
			}
		local k=`k'+1
		}
	save `filename',replace
	
	/* generating graph */
	use `filename',clear
	twoway rspike __hi90 __lo90 __lab, ///
	lw(vvthin) lc(black) horizontal || ///
	rspike __hi50 __lo50 __lab, ///
	lw(vthick) lc(black) horizontal || ///
	scatter __lab __b, ///
	msym(diamond) mc(black) mfc(black) msize(vlarge) ///
	ylab(1(1)`length',val angle(360) nogrid noticks labs(large)) yscal(range(1(1)`length') noline) xlab(,labs(large)) ///
	xline(0,lp(dash) lc(gray)) ytitle("") ///
	plotr(margin(b+5 t+5)) name(`graphname',replace) ///
	scheme(lean2) legend(off) `graphopts'
	clear
end
