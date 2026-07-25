*/estimating recursive models*/
local i=1
foreach name in movies music books arts plays  {
	constapply,stub(`name')
	*/effects of interaction on cosumption*/
	qui biprobit (talk_`name'bin=$controls,nocons)(freq_`name'bin=talk_`name'bin1 talk_`name'bin2 $controls,nocons),const(1/20 40) col tech(bhhh) nolog
	est store mod12_`i'
	*/effects of consumption on interaction*/
	qui biprobit (talk_`name'bin=freq_`name'bin1 freq_`name'bin2 $controls,nocons)(freq_`name'bin=$controls,nocons),const(1/20 41) col tech(bhhh) nolog
	est store mod21_`i'
	local i=`i'+1
	}	
esttab mod12_1 mod12_2 mod12_3 mod12_4 mod12_5,compress nogaps nolines unstack keep(talk*2)
esttab mod21_1 mod21_2 mod21_3 mod21_4 mod21_5,compress nogaps nolines unstack keep(freq*2)

*/estimating recursive models*/
local i=1
foreach name in movies music books arts plays  {
	constapply,stub(`name')
	*/effects of interaction on cosumption*/
	qui biprobit (talk_`name'bin=$controls,nocons)(freq_`name'bin=talk_`name'bin1 talk_`name'bin2 $controls $barrpart,nocons),const(1/20 35/39 40) col tech(bhhh) nolog
	est store mod12_`i'
	*/effects of consumption on interaction*/
	qui biprobit (talk_`name'bin=freq_`name'bin1 freq_`name'bin2 $controls,nocons)(freq_`name'bin=$controls $barrpart,nocons),const(1/20 35/39 41) col tech(bhhh) nolog
	est store mod21_`i'
	local i=`i'+1
	}	
esttab mod12_1 mod12_2 mod12_3 mod12_4 mod12_5,compress nogaps nolines unstack keep(talk*2)
esttab mod21_1 mod21_2 mod21_3 mod21_4 mod21_5,compress nogaps nolines unstack keep(freq*2)

*/estimating recursive models*/
local i=1
foreach name in movies music books arts plays  {
	constapply,stub(`name')
	*/effects of interaction on cosumption*/
	qui xi:biprobit (talk_`name'bin=$controls_i)(freq_`name'bin=talk_`name'bin $controls_i $barrpart_i),tech(bhhh) nolog
	est store mod12_`i'
	*/effects of consumption on interaction*/
	qui xi:biprobit (talk_`name'bin=freq_`name'bin $controls_i)(freq_`name'bin=$controls_i $barrpart_i),tech(bhhh) nolog
	est store mod21_`i'
	local i=`i'+1
	}	
esttab mod12_1 mod12_2 mod12_3 mod12_4 mod12_5,compress nogaps nolines unstack keep(talk*)
esttab mod21_1 mod21_2 mod21_3 mod21_4 mod21_5,compress nogaps nolines unstack keep(freq*)


*/estimating recursive models*/
local i=1
foreach name in opera jazz rock folk christ {
	disp "fav`name'"
	xi:biprobit (talk_musicbin=$controls_i fav`name')(fav`name'=$controls_i),tech(bhhh 10 nr 5)
	est store mod_fav`name'
	local i=`i'+1
	}	
esttab mod_fav*,compress nogaps nolines unstack keep(fav*)

est drop _all
*/estimating recursive models*/
local i=1
foreach name in opera jazz rock folk christ punk  {
	disp "imp`name'"
	xi:biprobit (talk_musicbin=$controls_i imp`name')(imp`name'=$controls_i),tech(bhhh 10 nr 5)
	est store mod_imp`name'
	local i=`i'+1
	}	
esttab mod*,compress nogaps nolines unstack keep(imp*)

opera jazz rock folk christ
*/estimating recursive models*/
local i=1
foreach name in punk {
	disp "fav`name'"
	xi:mvprobit (talk_musicbin=$controls_i fav`name' freq_musicbin)(fav`name'=$controls_i) (freq_musicbin=$controls_i $barrpart_i),tech(bhhh) draws(5)
	est store mod_fav`name'
	local i=`i'+1
	}	
esttab mod_fav*,compress nogaps nolines unstack keep(freq* fav*)