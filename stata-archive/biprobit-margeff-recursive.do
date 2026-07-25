*/computing marginal effects
cap gen marg_eff12=.
cap gen marg_eff_t12=.
cap gen marg_eff21=.
cap gen marg_eff_t21=.
cap gen dom=""
local i=1
*/effects of interaction on cosumption*/
foreach name in movies music books arts plays {
	qui xi:biprobit (freq_`name'bin= talk_`name'bin  $`name'freq_spec) (talk_`name'bin=$talk_spec),tech(bhhh) nolog
	mfx,predict(pmarg1) force
	mat mb=e(Xmfx_dydx)
	mat mse=e(Xmfx_se_dydx) 
	replace marg_eff12=mb[1,1] in `i'
	replace marg_eff12=mb[1,1]/mse[1,1] in `i'
	replace dom="`name'" in `i'
   local i=`i'+1
	}
	
local i=1
*/effects of consumption on interaction*/
foreach name in movies music books arts plays  {
	qui xi:biprobit (talk_`name'bin=freq_`name'bin $talk_spec) (freq_`name'bin=$`name'freq_spec),tech(bhhh) nolog
	qui mfx,predict(pmarg1) force
	qui mat mb=e(Xmfx_dydx)
	mat mse=e(Xmfx_se_dydx)
	replace marg_eff21=mb[1,1] in `i'
	replace marg_eff21=mb[1,1]/mse[1,1] in `i'
   local i=`i'+1
	}	
format marg* %9.2f
scatter marg_eff12 marg_eff21 in 1/5,over(dom) ///
legend(label(1 "Effect of Interaction on Consumption") ///
label(2 "Effect of Consumption on Interaction") pos(6)) ///
ylab(,nogrid) yline(0) ysize(6) xsize(5)

