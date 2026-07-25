cap gen N=.
cap gen ll=.
cap gen df=.
cap gen bic=.
cap gen var=""
cons def 1 [athrho]_cons=0
local i=1
foreach name in movies music books arts plays {
	disp "`name'"
	local pre freq
	if "`name'bin"=="music"|"`name'bin"=="books" {
		local pre freq
		}		
	qui xi:biprobit (`pre'_`name'bin=$controls_i $barrpart_i)(talk_`name'bin=$controls_i),tech(bhhh)
	estat ic
	mat S=r(S)
	replace N=S[1,1] in `i'
	replace ll=S[1,3] in `i'
	replace df=S[1,4] in `i'
	replace bic=S[1,6] in `i'
	replace var="`name'bin" in `i'
	local i=`i'+1
	qui xi:biprobit (talk_`name'bin=$controls_i)(`pre'_`name'bin=talk_`name'bin $controls_i $barrpart_i),tech(bhhh)
	estat ic
	mat S=r(S)
	replace N=S[1,1] in `i'
	replace ll=S[1,3] in `i'
	replace df=S[1,4] in `i'
	replace bic=S[1,6] in `i'
	replace var="`name'bin" in `i'
	local i=`i'+1
	qui xi:biprobit (`pre'_`name'bin=$controls_i $barrpart_i)(talk_`name'bin=`pre'_`name'bin $controls_i),tech(bhhh)
	estat ic
	mat S=r(S)
	replace N=S[1,1] in `i'
	replace ll=S[1,3] in `i'
	replace df=S[1,4] in `i'
	replace bic=S[1,6] in `i'
	replace var="`name'bin" in `i'
	local i=`i'+1
	}
cap gen mod=""
local j=1
forval i=1/15 {
	local mod1 "Seemingly unrelated"
	local mod2 "Interaction as Intervening"
	local mod3 "Taste as Intervening"
	replace mod="`mod`j''" in `i'
	local j=`j'+1
	 if `j'==4 {
	 	local j=1
	 	}
	 }
format ll bic %9.1f
list mod bic df in 1/15,clean
listtex mod bic df in 1/15,type rstyle(tabular)