program define constapply2
	version 10.1
	syntax,stub(string)
	const drop _all
	*/contrast coding constraints*/
	const def 1 [freq_`stub']age1+[freq_`stub']age2+[freq_`stub']age3+[freq_`stub']age4+[freq_`stub']age5+[freq_`stub']age6+[freq_`stub']age7=0
	const def 2 [talk_`stub']age1+[talk_`stub']age2+[talk_`stub']age3+[talk_`stub']age4+[talk_`stub']age5+[talk_`stub']age6+[talk_`stub']age7=0
	
	const def 3 [freq_`stub']educ1+[freq_`stub']educ2+[freq_`stub']educ3+[freq_`stub']educ4+[freq_`stub']educ5=0
	const def 4 [talk_`stub']educ1+[talk_`stub']educ2+[talk_`stub']educ3+[talk_`stub']educ4+[talk_`stub']educ5=0
	
	const def 5 [freq_`stub']finc1+[freq_`stub']finc2+[freq_`stub']finc3+[freq_`stub']finc4+[freq_`stub']finc5+[freq_`stub']finc6=0
	const def 6 [talk_`stub']finc1+[talk_`stub']finc2+[talk_`stub']finc3+[talk_`stub']finc4+[talk_`stub']finc5+[talk_`stub']finc6=0
	
	const def 7 [freq_`stub']race1+[freq_`stub']race2+[freq_`stub']race3+[freq_`stub']race4+[freq_`stub']race5=0
	const def 8 [talk_`stub']race1+[talk_`stub']race2+[talk_`stub']race3+[talk_`stub']race4+[talk_`stub']race5=0
	
	const def 9 [freq_`stub']gender1+[freq_`stub']gender2=0
	const def 10 [talk_`stub']gender1+[talk_`stub']gender2=0
	
	*/equality constraints*/
	const def 21 [talk_`stub']age1=[freq_`stub']age1
	const def 22 [talk_`stub']age2=[freq_`stub']age2
	const def 23 [talk_`stub']age3=[freq_`stub']age3
	const def 24 [talk_`stub']age4=[freq_`stub']age4
	const def 25 [talk_`stub']age5=[freq_`stub']age5
	const def 26 [talk_`stub']age6=[freq_`stub']age6

	const def 27 [talk_`stub']educ1=[freq_`stub']educ1
	const def 28 [talk_`stub']educ2=[freq_`stub']educ2
	const def 29 [talk_`stub']educ3=[freq_`stub']educ3
	const def 30 [talk_`stub']educ4=[freq_`stub']educ4

	const def 31 [talk_`stub']finc1=[freq_`stub']finc1
	const def 32 [talk_`stub']finc2=[freq_`stub']finc2
	const def 33 [talk_`stub']finc3=[freq_`stub']finc3
	const def 34 [talk_`stub']finc4=[freq_`stub']finc4
	const def 35 [talk_`stub']finc5=[freq_`stub']finc5

	const def 36 [talk_`stub']race1=[freq_`stub']race1
	const def 37 [talk_`stub']race2=[freq_`stub']race2
	const def 38 [talk_`stub']race3=[freq_`stub']race3
	const def 39 [talk_`stub']race4=[freq_`stub']race4
	
	const def 40 [talk_`stub']gender2=[freq_`stub']gender2	
end

