global keeplist num* freq_* talk* race marital urban educ finc age gender married city black white hispanic asian *childs* *more* no_art* 
do "N:\Private\MISC DATA SOURCES\NSS\NSS2004_dataproc.do"

foreach name in favmystery favscifi favromance favfictlit favselfhelp favhistory favbio favsports favrel {
	gen `name'=0 if favbook1~=.
	}
forval i=1/16 {
	replace favmystery=favmystery+1 if favbook`i'==1
	replace favscifi=favscifi+1 if favbook`i'==2
	replace favromance=favromance+1 if favbook`i'==3
	replace favfictlit=favfictlit+1 if favbook`i'==4
	replace favfictlit=favfictlit+1 if favbook`i'==5
	replace favselfhelp=favselfhelp+1 if favbook`i'==6
	replace favhistory=favhistory+1 if favbook`i'==7
	replace favbio=favbio+1 if favbook`i'==8
	replace favsports=favsports+1 if favbook`i'==9
	replace favrel=favrel+1 if favbook`i'==14
	}
recode favfictlit 1/2=1
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
gen year=2004
keep  $keeplist fav* year
save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta",replace
do "N:\Private\MISC DATA SOURCES\NSS\NSS2002_dataproc.do"
keep $keeplist impmusic*
foreach name in rockpop folkcountry christgospel jazzblues operaclassical punkhvymetal {
	gen imp`name'=0
	}
forval i=1/10 {
	replace improckpop=improckpop+1 if impmusic`i'==1
	replace impoperaclassical=impoperaclassical+1 if impmusic`i'==2
	replace imppunkhvymetal=imppunkhvymetal+1 if impmusic`i'==3
	replace impfolkcountry=impfolkcountry+1 if impmusic`i'==4
	replace impjazzblues=impjazzblues+1 if impmusic`i'==6
	replace impchristgospel=impchristgospel+1 if impmusic`i'==8	
	}
append using "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta"

replace year=2002 if year==.
gen CASEID=_n
keep  CASEID $keeplist imp* fav* year

lab def educat2 1 "Less than H.S." 2 "High School" 3 "Some Coll." 4 "Bachelor" 5 "Graduate"
recode educ 1/2=2
replace educ=educ-1
lab val educ educat2
ren num_childs children
recode children 1/11=1
quietly {
	gen fincdk=finc==.
	qui levelsof educ,l(leduc)
	qui levelsof married,l(lmarr)
	qui levelsof gender,l(lgend)
	foreach e of local leduc {
		foreach m of local lmarr {
			foreach g of local lgend {
				sum finc if educ==`e'&married==`m'&gender==`g',det
				replace finc=r(p50) if (educ==`e'&married==`m'&gender==`g') & finc==.
				}
			}
		}
	lab def plusmin 1 "+" 0 "-"
	foreach var of varlist *more* no_art* {
		recode `var' 2/8=0 
		lab val `var' plusmin
		}
	}
for var favrock-favpunk:lab val X plusmin

drop *kid* CASEID
for var educ age city black hisp children married:drop if X==.
cap drop *bin
gen freq_moviesbin=freq_movies>=3 if freq_movies~=.
gen freq_booksbin=freq_books>=3 
gen freq_musicbin=freq_music==4
gen freq_artsbin=freq_arts>=3 if freq_arts~=.
gen freq_playsbin=freq_plays>=3 if freq_plays~=.
gen talk_booksbin=talk_books>=3
gen talk_musicbin=talk_music>=3
gen talk_moviesbin=talk_movies>=3
gen talk_artsbin=talk_arts>=3 if talk_arts~=.
gen talk_playsbin=talk_plays>=3 if talk_plays~=.
for var *bin fav*:lab val X plusmin
quietly {
	tab age,g(age)
	tab educ,g(educ)
	tab gender,g(gender)
	tab black,g(black)
	tab hisp,g(hisp)
	tab children,g(child)
	tab married,g(married)
	tab city,g(city)
	tab finc,g(finc)
	tab year,g(year)
	tab race,g(race)
	tab marital,g(marital)
	for var readmore_*:tab X,g(X)
	for var artmore_*:tab X,g(X)
	for var playsmore_*:tab X,g(X)
	for var moviesmore_*:tab X,g(X)
	for var no_art*:tab X,g(X)
	for var talk_*bin:tab X,g(X)
	for var freq_*bin:tab X,g(X)
	}

save "N:\Private\SOCIOLOGY OF CULTURE\culture-talk-stratification\NSS-2002-2004-using.dta", replace
