program define constapply3
	version 10.1
	syntax,stub1(string) stub2(string)
	const drop _all
	*/contrast coding constraints*/
	const def 1 [talk_`stub1']age1+[talk_`stub1']age2+[talk_`stub1']age3+[talk_`stub1']age4+[talk_`stub1']age5+[talk_`stub1']age6+[talk_`stub1']age7=0	
	const def 2 [talk_`stub1']educ1+[talk_`stub1']educ2+[talk_`stub1']educ3+[talk_`stub1']educ4+[talk_`stub1']educ5=0	
	const def 3 [talk_`stub1']finc1+[talk_`stub1']finc2+[talk_`stub1']finc3+[talk_`stub1']finc4+[talk_`stub1']finc5+[talk_`stub1']finc6=0
	const def 4 [talk_`stub1']race1+[talk_`stub1']race2+[talk_`stub1']race3+[talk_`stub1']race4+[talk_`stub1']race5=0
	const def 5 [talk_`stub1']gender1+[talk_`stub1']gender2=0
	const def 6 [fav`stub2']age1+[fav`stub2']age2+[fav`stub2']age3+[fav`stub2']age4+[fav`stub2']age5+[fav`stub2']age6+[fav`stub2']age7=0	
	const def 7 [fav`stub2']educ1+[fav`stub2']educ2+[fav`stub2']educ3+[fav`stub2']educ4+[fav`stub2']educ5=0	
	const def 8 [fav`stub2']finc1+[fav`stub2']finc2+[fav`stub2']finc3+[fav`stub2']finc4+[fav`stub2']finc5+[fav`stub2']finc6=0
	const def 9 [fav`stub2']race1+[fav`stub2']race2+[fav`stub2']race3+[fav`stub2']race4+[fav`stub2']race5=0
	const def 10 [fav`stub2']gender1+[fav`stub2']gender2=0
	const def 11 [talk_`stub1']fav`stub2'1+[talk_`stub1']fav`stub2'2=0
end

