local i=1
foreach var of varlist  talk_books talk_music talk_movies talk_plays talk_arts {
	gen cat`i'=`var'
	local i=`i'+1
	}
reshape long cat,i(CASEID) j(item)
tab item,g(talk)
lab val cat freq

lab def item 1 "Books" 2 "Music" 3 "Movies" 4 "Plays" 5 "Arts"
lab val item item

qui xi3:ologit cat i.item i.educ i.age i.asian i.hispanic i.black i.married i.city 
fitstat,saving(mod1) /*setting up a baseline model*/

qui xi3:ologit cat i.item educ i.age i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that a linear specification of education is better*/
fitstat,using(mod1) /*the hypothesis appears to be supported by the BIC criterion but is rejected by the LR test*/

qui xi3:ologit cat i.item i.educ age i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that a linear specification of age is better*/
fitstat,using(mod1)/*the hypothesis appears to be supported by both the BIC and LR criterion*/

qui xi3:ologit cat i.item educ age i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that a linear specification of age is better*/
fitstat,saving(mod2) /*setting up a new baseline model*/

qui xi3:ologit cat i.item*educ age i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that education helps individuals engage in culture-mediated interaction differentially across cultural forms*/
fitstat,using(mod2)/*the hypothesis is rejected by both the BIC and the LR criteria: education has the same positive effect on engaging in culture-mediated social interaction regardless of the type of cultural activity*/
postgr3 educ,by(item) out(4) 

qui xi3:ologit cat i.item*age educ i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that people of different ages engage in culture-mediated interaction differentially across cultural forms*/
fitstat,using(mod2)/*the hypothesis appears to be supported by both the BIC and the LR criteria*/
fitstat,saving(mod3) /*setting up new baseline model*/
postgr3 age,by(item) out(4) 

qui xi3:ologit cat i.item  i.talk3*age educ i.asian i.hispanic i.black i.married i.city  /*This model tests the hypothesis that the age x cultural form interaction is restricted to movies*/
fitstat,using(mod3)/*the hypothesis appears to be supported by both the BIC and the LR criteria*/
fitstat,saving(mod4) /*Setting up new baseline model*/

qui xi3:ologit cat i.item i.talk2*age i.talk3*age educ i.asian i.hispanic i.black i.married i.city  /*This model tests the hypothesis that we need a music x age interaction*/
fitstat,using(mod4) /*The hypothesis is rejected by the BIC criterion but supported by the LR criterion*/

local i=1
foreach var of varlist freq_books-freq_arts {
	gen `var'Xtalk`i'=`var'*talk`i'
	local i=`i'+1
	}
xi3:ologit cat i.item freq_books-freq_arts i.talk3*age educ i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that aesthetic consumption is associated with culture-mediated interaction*/
fitstat,using(mod4)  /*The hypothesis receives overwhelming support by both the BIC and the LR ratio criteria*/
fitstat,saving(mod5) /*Setting up a new baseline model*/

qui xi3:ologit cat i.talk1*freq_books i.talk2*freq_music i.talk3*freq_movies i.talk4*freq_plays i.talk5*freq_arts i.talk3*age educ i.asian i.hispanic i.black i.married i.city   /*This model tests the hypothesis that aesthetic consumption is associated with culture-mediated interaction and the effect of consumption is stronger for the focal cultural form*/
fitstat,using(mod5) /*The hypothesis receives overwhelming support by both the BIC and the LR ratio criteria*/
fitstat,saving(mod6) /*Setting up new baseline model*/

qui xi3:ologit cat i.talk1*i.freq_books i.talk2*i.freq_music i.talk3*i.freq_movies i.talk4*i.freq_plays i.talk5*i.freq_arts i.talk3*age educ i.asian i.hispanic i.black i.married i.city   /*this model tests the hypothesis that the effect of aesthetic consumption on culture-mediated interaction can be restricted to a linear by linear specification*/
fitstat,using(mod6) /*The hypothesis is supported by the BIC criterion rejected by the LR ratio test*/


qui xi3:ologit cat i.item*freq_books i.item*freq_music i.item*freq_movies i.item*freq_plays i.item*freq_arts i.talk3*age educ i.asian i.hispanic i.black i.married i.city  /*This model tests the hypothesis aesthetic consumption of different genres facilitate culture-mediated interaction across cultural forms*/
fitstat,using(mod6) /*The hypothesis is rejected by the BIC criterion but receives strong support according to the LR ratio test*/
fitstat,saving(mod7) /*setting up new baseline model*/

foreach var of varlist freq_books-freq_arts {
	postgr3 `var',by(item) nodraw out(4) saving(`var'.gph,replace) legend(off)
	}
graph combine "freq_books" "freq_music" "freq_movies" "freq_plays" "freq_arts",cols(2) rows(3) ysize(9) xsize(6.5)

qui xi3:ologit cat i.talk1*freq_books*educ i.talk2*freq_music*educ i.talk3*freq_movies*educ i.talk4*freq_plays*educ i.talk5*freq_arts*educ i.talk3*age educ i.asian i.hispanic i.black i.married i.city/*This model tests the hypothesis that the association between aesthetic consumption and culture mediated interaction differs across levels of education*/  
fitstat,using(mod6) /*The hypothesis is REJECTED by both BIC and LR criteria*/

qui xi3:ologit cat i.item*freq_books i.item*freq_music i.item*freq_movies i.item*freq_plays i.item*freq_arts i.talk3*age i.educ i.asian i.hispanic i.black i.married i.city  
fitstat,saving(mod8) /*setting up new baseline model*/
qui xi3:ologit cat i.talk1*freq_books*age i.talk2*freq_music*age i.talk3*freq_movies*age i.talk4*freq_plays*age i.talk5*freq_arts*age i.talk3*age educ i.asian i.hispanic i.black i.married i.city /*This model tests the hypothesis that the association between aesthetic consumption and culture mediated interaction differs across levels of age*/  
fitstat,using(mod6) /*The hypothesis is rejected according to the BIC criterion but supported by the likelihood ratio test*/






