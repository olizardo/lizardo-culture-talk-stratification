program define constapply
	version 10.1
	syntax,stub(string)
	const drop _all
	*/contrast coding constraints*/
	const def 1 [freq_`stub'bin]age1+[freq_`stub'bin]age2+[freq_`stub'bin]age3+[freq_`stub'bin]age4+[freq_`stub'bin]age5+[freq_`stub'bin]age6+[freq_`stub'bin]age7=0
	const def 2 [talk_`stub'bin]age1+[talk_`stub'bin]age2+[talk_`stub'bin]age3+[talk_`stub'bin]age4+[talk_`stub'bin]age5+[talk_`stub'bin]age6+[talk_`stub'bin]age7=0
	const def 3 [freq_`stub'bin]educ1+[freq_`stub'bin]educ2+[freq_`stub'bin]educ3+[freq_`stub'bin]educ4+[freq_`stub'bin]educ5=0
	const def 4 [talk_`stub'bin]educ1+[talk_`stub'bin]educ2+[talk_`stub'bin]educ3+[talk_`stub'bin]educ4+[talk_`stub'bin]educ5=0
	
	const def 5 [freq_`stub'bin]gender1+[freq_`stub'bin]gender2=0
	const def 6 [talk_`stub'bin]gender1+[talk_`stub'bin]gender2=0
	const def 7 [freq_`stub'bin]hi_inc1+[freq_`stub'bin]hi_inc2=0
	const def 8 [talk_`stub'bin]hi_inc1+[talk_`stub'bin]hi_inc2=0
	const def 9 [freq_`stub'bin]black1+[freq_`stub'bin]black2=0
	const def 10 [talk_`stub'bin]black1+[talk_`stub'bin]black2=0
	const def 11 [freq_`stub'bin]hisp1+[freq_`stub'bin]hisp2=0
	const def 12 [talk_`stub'bin]hisp1+[talk_`stub'bin]hisp2=0
	const def 13 [freq_`stub'bin]married1+[freq_`stub'bin]married2=0
	const def 14 [talk_`stub'bin]married1+[talk_`stub'bin]married2=0
	const def 15 [freq_`stub'bin]children1+[freq_`stub'bin]children2=0
	const def 16 [talk_`stub'bin]children1+[talk_`stub'bin]children2=0
	const def 17 [freq_`stub'bin]city1+[freq_`stub'bin]city2=0
	const def 18 [talk_`stub'bin]city1+[talk_`stub'bin]city2=0
	const def 19 [freq_`stub'bin]year1+[freq_`stub'bin]year2=0
	const def 20 [talk_`stub'bin]year1+[talk_`stub'bin]year2=0
	
	*/equality constraints*/
	const def 21 [talk_`stub'bin]age1=[freq_`stub'bin]age1
	const def 22 [talk_`stub'bin]age2=[freq_`stub'bin]age2
	const def 23 [talk_`stub'bin]age3=[freq_`stub'bin]age3
	const def 24 [talk_`stub'bin]age4=[freq_`stub'bin]age4
	const def 25 [talk_`stub'bin]age5=[freq_`stub'bin]age5
	const def 26 [talk_`stub'bin]age6=[freq_`stub'bin]age6
	const def 27 [talk_`stub'bin]age7=[freq_`stub'bin]age7

	const def 28 [talk_`stub'bin]educ1=[freq_`stub'bin]educ1
	const def 29 [talk_`stub'bin]educ2=[freq_`stub'bin]educ2
	const def 30 [talk_`stub'bin]educ3=[freq_`stub'bin]educ3
	const def 31 [talk_`stub'bin]educ4=[freq_`stub'bin]educ4
	const def 32 [talk_`stub'bin]educ5=[freq_`stub'bin]educ5
	
	const def 33 [talk_`stub'bin]gender2=[freq_`stub'bin]gender2
	const def 34 [talk_`stub'bin]black2=[freq_`stub'bin]black2
	const def 35 [talk_`stub'bin]hisp2=[freq_`stub'bin]hisp2
	
	const def 36 [talk_`stub'bin]_cons=[freq_`stub'bin]_cons
	
	*/additional contrast-coding constraints on the "barriers to participation" variables*/
	const def 37 [freq_`stub'bin]no_art_health1+[freq_`stub'bin]no_art_health2=0
	const def 38 [freq_`stub'bin]no_art_time1+[freq_`stub'bin]no_art_time2=0
	const def 39 [freq_`stub'bin]no_art_friends1+[freq_`stub'bin]no_art_friends2=0	
	const def 40 [freq_`stub'bin]artmore_cheap1+[freq_`stub'bin]artmore_cheap2=0
	const def 41  [freq_`stub'bin]artmore_info1+[freq_`stub'bin]artmore_info2=0
	const def 42 [freq_`stub'bin]artmore_closer1+[freq_`stub'bin]artmore_closer2=0
	
	*/recursive model constraints*/
	const def 44 [freq_`stub'bin]talk_`stub'bin1+[freq_`stub'bin]talk_`stub'bin2=0
	const def 45 [talk_`stub'bin]freq_`stub'bin1+[talk_`stub'bin]freq_`stub'bin2=0
	
	
end

