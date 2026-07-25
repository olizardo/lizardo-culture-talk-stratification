local i=1
local matnames M S B A P 
foreach name in movies music books arts play {
	local m : word `i' of `matnames'
	constapply2,stub(`name')
	qui bioprobit (talk_`name' $spec)(freq_`name' $spec),const(1/10) col
	forval j=4/4 {
		qui mfx compute, predict(outcome(`j',.)) nose
			if `j'==1 {
				mat `m't=e(Xmfx_dydx)'
				}
			else if `j'>1 {
				mat `m't=`m't,e(Xmfx_dydx)'
				}
			}
		disp in red `names'
		mat li `m't
		local i=`i'+1
		}
	
local i=1
local matnames M S B A P 
foreach name in movies music books arts play {
	local m : word `i' of `matnames'
	constapply2,stub(`name')
	qui bioprobit (talk_`name' $spec)(freq_`name' $spec),const(1/10) col
	forval j=1/4 {
		qui mfx compute, predict(outcome(.,`j')) nose
			if `j'==1 {
				mat `m'c=e(Xmfx_dydx)'
				}
			else if `j'>1 {
				mat `m'c=`m'c,e(Xmfx_dydx)'
				}
			}
		disp in red `names'
		mat li `m'c
		local i=`i'+1
		}
	