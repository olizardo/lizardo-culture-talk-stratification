cap gen rho1=.
cap gen rho1_chi2=.
cap gen rho1_p=.
cap gen rho2=.
cap gen rho2_chi2=.
cap gen rho2_p=.
cap gen rho3=.
cap gen rho3_chi2=.
cap gen rho3_p=.
cap gen beta1=.
cap gen t1=.
cap gen beta2=.
cap gen t2=.
cap gen beta3=.
cap gen t3=.
cap gen beta4=.
cap gen t4=.
cap gen corr=.
cap gen p=.
cap gen name=""

*/estimating "naive" models*/
local i=1
foreach name in movies music books arts plays  {
	qui xi:probit freq_`name'bin talk_`name'bin $controls_i $barrpart_i
	mat b=e(b)
	mat v=e(V)
	replace beta1=b[1,1] in `i'
	replace t1=b[1,1]/sqrt(v[1,1]) in `i'
	qui xi:probit talk_`name'bin  freq_`name'bin $controls_i
	mat b=e(b)
	mat v=e(V)
	replace beta2=b[1,1] in `i'
	replace t2=b[1,1]/sqrt(v[1,1]) in `i'
	local i=`i'+1
	}
	
*/estimating polychoric correlations*/
local i=1
foreach name in movies music books arts plays {
	qui tetrachoric talk_`name'bin freq_`name'bin
	replace corr=r(rho) in `i'
	replace p=r(p) in `i'	
	replace name="`name'bin" in `i'
	local i=`i'+1
	}
format corr p %9.2f
*/estimating seemingly unrelated models*/
local i=1
foreach name in movies music books arts plays  {
	qui xi:biprobit (talk_`name'bin=$controls_i) (freq_`name'bin=$controls_i $barrpart_i),tech(bhhh)
	mat b=e(b)
	mat v=e(V)
	replace rho1=r(est) in `i'
	replace rho1_chi2=e(chi2_c) in `i'
	local c=e(chi2_c)
	local p=chi2tail(1,`c')
	replace rho1_p=`p' in `i'
	local i=`i'+1
	}
format rho* t* %9.2f

*/estimating recursive models*/
local i=1
*/effects of interaction on cosumption*/
foreach name in movies music books arts plays  {
	qui xi:biprobit (freq_`name'bin= talk_`name'bin  $controls_i $barrpart_i) (talk_`name'bin=$controls_i),tech(bhhh)
	mat b=e(b)
	mat v=e(V)
	replace rho2=r(est) in `i'
	replace rho2_chi2=e(chi2_c) in `i'
	local c=e(chi2_c)
	local p=chi2tail(1,`c')
	replace rho2_p=`p' in `i'
	replace beta3=b[1,1] in `i'
	replace t3=b[1,1]/sqrt(v[1,1]) in `i'
	local i=`i'+1
	}	
local i=1
*/effects of consumption on interaction*/
foreach name in movies music books arts plays  {
	qui xi:biprobit (talk_`name'bin=freq_`name'bin $controls_i)(freq_`name'bin=$controls_i $barrpart_i),tech(bhhh)
	mat b=e(b)
	mat v=e(V)
	replace rho3=r(est) in `i'
	replace rho3_chi2=e(chi2_c) in `i'
	local c=e(chi2_c)
	local p=chi2tail(1,`c')
	replace rho3_p=`p' in `i'
	replace beta4=b[1,1] in `i'
	replace t4=b[1,1]/sqrt(v[1,1]) in `i'
	local i=`i'+1
	}	
local i=1
local names Movies Music Books Arts Plays
foreach l of local names {
	replace name="`l'" in `i'	
	local i=`i'+1
	}
	
format rho* t* beta* %9.2f
list name corr p rho1 rho1_p rho2 rho2_p  rho3 rho3_p in 1/5,clean
list name beta1 t1 beta3 t3 beta2 t2 beta4 t4 in 1/5,clean

listtex name corr p rho1 rho1_p rho2 rho2_p  rho3 rho3_p in 1/5,type rstyle(tabular)
listtex name beta1 t1 beta3 t3 beta2 t2 beta4 t4 in 1/5,type rstyle(tabular)




