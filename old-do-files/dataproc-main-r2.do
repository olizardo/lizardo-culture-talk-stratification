global keeplist freq_* talk* race marital urban educ finc age gender *childs* rec* num* imp*
do "N:\Private\MISC DATA SOURCES\NSS\NSS2004_dataproc.do"
gen year=2004
foreach name in rockpop folkcountry christgospel jazzblues operaclassical punkhvymetal {
	gen fav`name'=0
	}
forval i=1/11 {
	replace favrockpop=favrockpop+1 if favmusic`i'==1
	replace favfolkcountry=favfolkcountry+1 if favmusic`i'==2
	replace favchristgospel=favchristgospel+1 if favmusic`i'==3
	replace favjazzblues=favjazzblues+1 if favmusic`i'==4
	replace favoperaclassical=favoperaclassical+1 if favmusic`i'==5
	replace favpunkhvymetal=favpunkhvymetal+1 if favmusic`i'==6
	}
keep  $keeplist favrockpop-favpunkhvymetal year
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",replace
do "N:\Private\MISC DATA SOURCES\NSS\NSS2002_dataproc.do"
keep $keeplist 
append using "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta"

foreach name in suburb_type urban educ age finc marital race {
	lab val rec_`name' `name'
	}

replace year=2002 if year==.
gen CASEID=_n
keep CASEID $keeplist favrockpop-favpunkhvymetal year
lab def educat2 1 "Less than H.S." 2 "High School" 3 "Some Coll." 4 "Bachelor" 5 "Graduate"
recode educ 1/2=2
replace educ=educ-1
lab val educ educat2
ren num_childs children
recode children 1/11=1
drop *kid* *create
/*for var educ age city black hisp children married:drop if X==.*/
cd "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification"
mi set wide
mi register imputed rec_finc rec_age rec_educ
mi impute ologit rec_finc i.educ age i.race gender i.marital i.urban i.children,add(1) replace force
mi impute ologit rec_age i.educ i.finc i.race i.gender i.marital i.urban i.children,add(1) replace force
mi impute ologit rec_educ i.age i.finc i.race i.gender i.marital i.urban i.children,add(1) replace force
ren _1_rec_finc finc_imp
ren _2_rec_age age_imp
ren _3_rec_educ educ_imp
/* drop _*_* */

gen married=marital==1
gen city=urban<3
gen women=gender==2
gen white=race==1
gen black=race==2
gen asian=race==3
gen hispanic=race==4
center educ_imp finc_imp age_imp city married white black asian hispanic gender ///
freq*,replace
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta", replace



