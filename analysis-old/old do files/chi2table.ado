program def chi2table
	syntax varlist [if],fac(varlist max=3) cmd(string)
	cap drop *_chi2
	cap drop *_p
	cap drop *_per
	cap drop *_df
	gettoken x1 rhs : fac
	gettoken x2 rhs : rhs
   gettoken x3 rhs : rhs
	cap gen mod_chi2=.
	cap gen `x1'_chi2=.
	cap gen `x1'_p=.
	cap gen `x1'_df=.
	cap gen `x1'_per=.
	cap gen `x2'_chi2=.
	cap gen `x2'_p=.
	cap gen `x2'_df=.
	cap gen `x2'_per=.
	cap gen `x3'_chi2=.
	cap gen `x3'_p=.
	cap gen `x3'_df=.
	cap gen `x3'_per=.
	cap gen dep=""
	local i=1
	foreach var of varlist `varlist' {
		quietly {
			xi:`cmd' `var' $def_spec `if'
			replace mod_chi2=e(chi2) in `i'
			foreach name in `x1' `x2' `x3' {
				testparm _I`name'_*		
				replace `name'_per=(r(chi2)/e(chi2))*100 in `i'
				replace `name'_chi2=r(chi2) in `i'			
				replace `name'_p=r(p) in `i'
				replace `name'_df=r(df) in `i'
				replace dep="`var'" in `i'
				}
			}
		local i=`i'+1
		}
	local e=`i'-1
	format *_p %9.4f
	format *_per *chi2 %9.1f
	list dep `x1'_chi2 `x1'_p `x1'_df `x2'_chi2 `x2'_p `x2'_df  `x3'_chi2 `x3'_p `x3'_df mod_chi2 `x1'_per `x2'_per `x3'_per in 1/`e',clean
	listtex dep `x1'_chi2 `x1'_p `x1'_df `x2'_chi2 `x2'_p `x2'_df  `x3'_chi2 `x3'_p `x3'_df mod_chi2 `x1'_per `x2'_per `x3'_per in 1/`e', type rstyle(tabular)
end
