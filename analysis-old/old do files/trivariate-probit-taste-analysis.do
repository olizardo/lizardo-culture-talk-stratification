cap gen chi2=.
cap gen p=.
cap gen names=""
local i=1
foreach name in opera jazz rock folk christ punk {
	qui xi:bioprobit (talk_music=$controls_i fav`name')(fav`name'=$controls_i) 
	disp `i'
	replace chi2=e(chi2_c) in `i'
	replace p=e(p_c) in `i'
	local i=`i'+1
	}	
local i=1
local names Classical Jazz Rock Country Gospel Punk
foreach l of local names {
	replace names="`l'" in `i'	
	local i=`i'+1
	}
format chi2 %9.1f
format p %9.2f
list names chi2 p in 1/6,clean

foreach name in operaclassical jazzblues rockpop punkhvymetal christgospel folkcountry {
	tab fav`name',g(fav`name')
	}

est drop _all
local i=1
foreach name in operaclassical jazzblues rockpop punkhvymetal christgospel folkcountry {
	if "`name'"=="operaclassical"|"`name'"=="folkcountry" {
		local c=21
		}
	else {
		local c=22
		}
	constapply3,stub1(music) stub2(`name')
	bioprobit (talk_music=$full_list fav`name'1 fav`name'2)(fav`name'=$full_list),const(1/`c') col tech(dfp)
	disp `i'
	est store mod`i'
	local i=`i'+1
	}
esttab mod*,keep(fav*2) unstack plain lab compress t(%9.2f) b(%9.2f) par nogaps nolines nomtitles noeqli nodep nonum tex 

do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\lab.do"
esttab mod*,unstack plain lab compress t(%9.2f) b(%9.2f) par nogaps nolines onecell nomtitles noeqli nodep nonum tex keep(educ*) drop(talk_music:)



cap gen chi2=.
cap gen p=.
cap gen names=""
local i=1
foreach name in operaclassical jazzblues rockpop punkhvymetal christgospel  {
	xi:bioprobit (talk_books=$controls_i fav`name')(fav`name'=$controls_i) 
	disp `i'
	replace chi2=e(chi2_c) in `i'
	replace p=e(p_c) in `i'
	local i=`i'+1
	}	
local i=1
local names Classical Jazz Rock Country Gospel Punk
foreach l of local names {
	replace names="`l'" in `i'	
	local i=`i'+1
	}
format chi2 %9.1f
format p %9.2f
list names chi2 p in 1/6,clean