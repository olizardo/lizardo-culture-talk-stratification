do "N:\Private\MISC DATA SOURCES\National Social Survey\NSS2004_dataproc.do"

keep freq_movies talk_movies freq_music  talk_music  educ age gender
for var freq* talk*:recode X 1/2=0 3/4=1
ren freq_movies resp1
ren talk_movies resp2
ren freq_music resp3
ren talk_music resp4
gen id=_n
drop if educ==.
drop if age==.
reshape long resp,i(id)

keep favbook* educ age gender 
drop if educ==9|age==9
for var favbook*:recode X 16/99=.
gen id=_n
reshape long favbook,i(id)
drop if educ==.
drop if age==.
gen choice=favbook~=.
xi:xtgee choice i.favbook,fam(bin) l(logit) i(id)


qui levelsof freq,l(freq)
tokenize `freq'
local i=1
foreach num of numlist `freq' {
	expand `num' in `i'
	local i=`i'+1
	}
local i=1
foreach var of varlist  mem_t1 att_t1 mem_t2 att_t2 {
	ren `var' resp`i'
	local i=`i'+1
	}
drop freq
gen id=_n
reshape long resp,i(id)
recode _j 3=1 4=2,g(var)


	