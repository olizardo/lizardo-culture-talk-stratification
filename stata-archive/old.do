
cap drop b11-b56
local titles Movies Books Plays Arts Music
tokenize titles
cap gen educ_axis=.
forval i=1/5 {
	local j=`i'-1
	svmat b`i'
	cap drop b`j'5-b`j'6
	local b=1
	local e=5
	forval k=1/5 {
		qui replace educ_axis=`k' in `b'/`e'
		local b=`b'+4
		local e=`e'+4
		}
	lab val educ_axis educat2
	lab val b`i'4 xaxis
	local opts nodraw legend(pos(6)) ylab(0(.1).5,nogrid) legend(off) 	msize(small) msym(diamond) mfc(white)  xlab(,val angle(45)) 
	twoway rspike  b`i'2 b`i'3 b`i'4 if educ_axis==1,xtitle("") || 	connected b`i'1 b`i'4 if educ_axis==1,saving(graph1,replace) `opts' title("Less than H.S.")
	twoway rspike  b`i'2 b`i'3 b`i'4 if educ_axis==2,xtitle("")|| connected b`i'1 b`i'4 if educ_axis==2,saving(graph2,replace) `opts' title("High School")
	twoway rspike  b`i'2 b`i'3 b`i'4 if educ_axis==3,xtitle("")|| connected b`i'1 b`i'4 if educ_axis==3,saving(graph3,replace) `opts' title("Some Coll.")
	twoway rspike  b`i'2 b`i'3 b`i'4 if educ_axis==4,xtitle("") || connected b`i'1 b`i'4 if educ_axis==4,saving(graph4,replace) `opts' title("College Degree")
	twoway rspike  b`i'2 b`i'3 b`i'4 if educ_axis==5,xtitle("") || connected b`i'1 b`i'4 if educ_axis==5,saving(graph5,replace) `opts' title("Graduate Degree")
	local title: word `i' of `titles'
	graph combine "graph1" "graph2" "graph3" "graph4" "graph5",rows(1) cols(5) xsize(6.5) ysize(3) saving(combgraph`i',replace) nodraw title(""`title'"")
	}

graph combine "combgraph1" "combgraph2" "combgraph3",rows(5) cols(1) ysize(9) xsize(6.5) saving(combograph1,replace)

graph combine "combgraph4" "combgraph5",rows(5) cols(1) ysize(6) xsize(6.5) saving(combograph2,replace)

polychoric talk_movies talk_books talk_plays talk_arts talk_music
matout4 R using "N:\Private\SOCIOLOGY OF THE ARTS\cultural-capital-conversation\polycorr_talk.mat",replace



foreach var of varlist talk_movies-talk_music {
	tab `var',g(`var')
	forval i=1/4 {
		qui xi:logit `var'`i' i.educ i.age
		adjust _Iage_3 _Iage_4 _Iage_5 _Iage_6 _Iage_7,by(educ) ci nokey nohead pr
		}	
	}
drop  talk_movies1-talk_music4

preserve 
	local i=1
	foreach var of varlist talk_* {
		ren `var' talk`i'
		local i=`i'+1
		}
	lab def item 1 books 2 musicals 3 	movies 4 plays 5 arts 
	reshape long talk,i(CASEID) j(item)
	lab val item item
	table talk item
restore

foreeach var of varlist talk* {
	ologit i.


for var talk* freq_books freq_music freq_movies freq_plays freq_arts:recode X 1/2=1 3/4=0,g(Xbin)
lab def howoft 1 "often" 0 "not often"
for var talk_booksbin-talk_artsbin freq_booksbin freq_musicbin freq_moviesbin freq_playsbin freq_artsbin:lab val X howoft

cap drop temp*
cap gen temp_chi2=.
cap gen temp_chi2p=.
local i=1
foreach supername in books music movies plays arts {
	foreach subname in books music movies plays arts {
		qui tab talk_`supername' freq_`subname' if educ==1,chi2
		replace temp_chi2=`r(chi2)' in `i'
		replace temp_chi2p=`r(p)' in `i'
		local i=`i'+1
		}
	}
format temp_chi2p %9.3f
list temp_chi2 temp_chi2p in 1/25,clean		

cap drop temp*
cap gen temp_chi2=.
cap gen temp_chi2p=.
local i=1
foreach name in books music movies plays arts {
	forval j=1/6 {
		qui tab talk_`name' freq_`name' if educ==`j',chi2
		replace temp_chi2=`r(chi2)' in `i'
		replace temp_chi2p=`r(p)' in `i'
		local i=`i'+1
		}
	}
format temp_chi2p %9.3f
list temp_chi2 temp_chi2p in 1/30,clean	

cap drop temp*
cap gen temp_chi2=.
cap gen temp_chi2p=.
local i=1
	forval j=1/6 {
		qui tab freq_books nfav_book_genres if educ==`j',chi2
		replace temp_chi2=`r(chi2)' in `i'
		replace temp_chi2p=`r(p)' in `i'
		local i=`i'+1
		}
format temp_chi2p %9.3f
list temp_chi2 temp_chi2p in 1/6,clean	

foreach name in books music movies plays arts {
	qui graph bar talk_`name'bin,over(freq_`name'bin) over(educ) saving(`name'.gph,replace) hor ytitle("") title("`name'")
	}

graph combine "books" "music" "movies" "plays" "arts",rows(3) cols(3) ysize(6) xsize(9)





local i=1
foreach var of varlist talk_* {
	ren `var' talk`i'
	local i=`i'+1
	}
lab def item 1 books 2 musicals 3 movies 4 plays 5 arts 
reshape long talk,i(CASEID) j(item)
lab val item item
tab item,g(item)
constraint define 1  item1+item2+item3+item4+item5=0
constraint define 2  educXitem1+educXitem2+educXitem3+educXitem4+educXitem5=0

gen talk_often=talk==1 

center educ age
foreach var of varlist item1-item5 {
	gen educX`var'=c_educ*`var'
	}

xi:xtlogit talk_often item1-item5 i.item3*c_educ c_age i.item1*i.gender i.city i.married,i(CASEID)  constraint(1) re nocons

xi:xtlogit talk_often c_educ c_age,i(CASEID)   



est drop _all
qui xi:ologit talk_movie i.educ i.freq_movies,
fitstat,saving(mod1)
qui xi:ologit talk_movie educ i.freq_movies,
fitstat,using(mod1)
qui fitstat,saving(mod2)
qui xi:ologit talk_movie educ freq_movies
fitstat,using(mod2)
qui fitstat,saving(mod3)
qui xi:ologit talk_movie educ freq_movies i.freq_movies*educ
fitstat,using(mod3)
qui xi:ologit talk_movie educ freq_movies educXfreq_movies
fitstat,using(mod3)
postgr3 educ,by(freq_movies) out(3)

do "N:\Private\MISC DATA SOURCES\National Social Survey\NSS2004_dataproc.do"
keep freq* talk* educ-asian CASEID 
gen year=2004
save "N:\Private\SOCIOLOGY OF THE ARTS\Cultural Capital in Conversation\NSS2004-using.dta",replace
do "N:\Private\MISC DATA SOURCES\National Social Survey\NSS2002_dataproc.do"
keep freq* talk* educ-asian CASEID
gen year=2002
append using "N:\Private\SOCIOLOGY OF THE ARTS\Cultural Capital in Conversation\NSS2004-using.dta"
gen id=_n
revrs freq* talk*,replace
char age[omit] 4

est drop _all
foreach name in movies books plays arts music {	
	quietly {
		ren freq_`name' freq
		eststo:xi:ologit talk_`name' i.freq i.age i.gender i.white i.city i.year
		eststo:xi:ologit talk_`name' i.freq i.educ_rec i.age i.gender i.white i.city i.year
		ren freq freq_`name' 
		}
	}
esttab,compress nolines nogaps star(* 0.10)