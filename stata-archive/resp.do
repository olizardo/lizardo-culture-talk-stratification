for var talk*:recode X 1/2=0 3/4=1
lab def plusmin 1 + 0 -
for varl talk*: lab val X plusmin

local i=1
foreach var of varlist talk_books talk_music talk_movies talk_plays talk_arts {
	gen cat`i'=`var'
	local i=`i'+1
	}
reshape long cat,i(CASEID) j(item)
tab item,g(talk)
lab val cat plusmin
drop if age==.
drop if educ==.

lab def item 1 "Books" 2 "Music" 3 "Movies" 4 "Plays" 5 "Arts"
lab val item item

foreach x of varlist talk1-talk5 {
	foreach w of varlist educ age {
		gen `w'X`x'=`w'*`x'
		}
	}
local i=1
foreach Xi of varlist freq_books-freq_movies {
	foreach Xj of varlist talk1-talk5 {
		gen `Xi'X`Xj'=`Xi'*`Xj'
		local i=`i'+1
		}
	}
	
for var  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5:gen Xxeduc=X*educ
for var  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5:gen Xxage=X*age

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 i.educ i.age  i.gender i.asian i.hispanic i.black i.married i.city,i(CASEID) nocons nolog 
est store mod1 /*setting up a baseline model*/
qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 educ i.age i.gender  i.asian i.hispanic i.black i.married i.city,i(CASEID) nocons nolog/*This model tests the hypothesis that a linear specification of education is better*/
est store mod2
lrtest mod1 mod2 /*The hypothesis is supported*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 i.educ age i.gender i.asian i.hispanic i.black i.married i.city,i(CASEID) nocons nolog/*This model tests the hypothesis that a linear specification of age is better*/
est store mod3
lrtest mod1 mod3 /*The hypothesis is supported*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 educ age i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog 
est store mod4 /*setting up a baseline model*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 educXt* age i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog 
est store mod5  /*This model tests the omnivorousness hypothesis:  education helps individuals engage in culture-mediated interaction across all cultural forms at comparable levels of intensity*/
lrtest mod4 mod5 
/*the hypothesis is supported*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 i.item*age educ i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog /*This model tests the hypothesis that people of different ages engage in culture-mediated interaction differentially across cultural forms*/
est store mod6 
lrtest mod4 mod6 
/*the hypothesis is supported; older individuals have a lower propensity to engage in culture-mediated interaction when it comes to music and movies*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 age ageXtalk2 ageXtalk3  educ i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog  /*This model tests the hypothesis that the age x cultural form interaction is restricted to movies and music*/
est store mod7
lrtest mod6 mod7 
/*the hypothesis is supported*/
	
qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5 educ age ageXtalk2 ageXtalk3  i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog  /*This model tests the hypothesis that aesthetic consumption is associated with culture-mediated interaction*/
est store mod8
lrtest mod7 mod8
/*The hypothesis is overwhelmingly supported*/

cons def 1 freq_booksXtalk1=freq_musicXtalk2
cons def 2 freq_musicXtalk2=freq_moviesXtalk3
cons def 3 freq_moviesXtalk3=freq_playsXtalk4
cons def 4 freq_playsXtalk4=freq_artsXtalk5
qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5 educ age ageXtalk2 ageXtalk3  i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog constr(1/4) /*This model tests the hypothesis that aesthetic consumption is associated with culture-mediated interaction in the same way across cultural forms*/
est store mod8b
lrtest mod8 mod8b
/*The hypothesis is overwhelmingly rejected*/


qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5 freq*talk* educ educ age ageXtalk2 ageXtalk3 i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog     /*This model tests the hypothesis aesthetic consumption of different genres facilitate culture-mediated interaction across cultural forms*/
est store mod9
lrtest mod8 mod9
/*The hypothesis is overwhelmingly supported*/

cons def 1 freq_booksXtalk1xeduc=freq_musicXtalk2xeduc
cons def 2 freq_musicXtalk2xeduc=freq_moviesXtalk3xeduc
cons def 3 freq_moviesXtalk3xeduc=freq_playsXtalk4xeduc
cons def 4 freq_playsXtalk4xeduc=freq_artsXtalk5xeduc
qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5  freq_booksXtalk1xeduc freq_musicXtalk2xeduc freq_moviesXtalk3xeduc freq_playsXtalk4xeduc freq_artsXtalk5xeduc educ age ageXtalk2 ageXtalk3 i.gender i.asian i.hispanic i.black i.married i.city i.year,i(CASEID) nocons nolog constraints(1/4) /*This model tests the hypothesis that the association between aesthetic consumption and culture mediated interaction differs across levels of education*/  
est store mod10
lrtest mod8 mod10
/*The hypothesis is supported*/

qui xi:xtlogit cat  talk1 talk2 talk3 talk4 talk5  freq_booksXtalk1 freq_musicXtalk2 freq_moviesXtalk3 freq_playsXtalk4 freq_artsXtalk5  freq_booksXtalk1xage freq_musicXtalk2xage freq_moviesXtalk3xage freq_playsXtalk4xage freq_artsXtalk5xage educXt* ageXtalk2 ageXtalk3  i.gender i.asian i.hispanic i.black i.married i.city,i(CASEID) nocons nolog/*This model tests the hypothesis that the association between aesthetic consumption and culture mediated interaction differs across levels of age*/  
est store mod11
lrtest mod8 mod11
/*The hypothesis is rejected*/

