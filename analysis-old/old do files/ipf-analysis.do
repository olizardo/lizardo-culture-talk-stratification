use "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\NSS-2002-2004-using.dta", clear
cd "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do"
drop if age==.
drop if educ==.
gen g2=.
gen df=.
gen p=.
gen bic=.
gen name=""

do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\ipf.do"
list name g2 p df bic in 1/28,clean
listtex g2 df bic in 1/28, type rstyle(tabular)

cap drop *pred
xi3:ologit talk_music i.age i.educ
qui postgr3 age,out(4) nodraw gen(age_pred)
qui postgr3 educ,out(4) nodraw gen(educ_pred)

twoway line educ_pred educ,sort ///
xlab(,valuelabel angle(45) labs(small))  ///
||line age_pred age,sort xaxis(2) ///
xlab(1(1)7,valuelabel angle(45) labs(small) axis(2)) ///
ytitle("Pr(Talk About Music = Often)") ///
legend(label(1 "Effect of Education") label(2 "Effect of Age") pos(6)) ///
ysize(8) xsize(6) ylab(0(.05).3,glc(gs11)) graphr(margin(r+10)) 

qui xi3:ologit talk_music i.age i.educ
est store mod1
xi3:ologit talk_music i.age*i.educ
est store mod2
lrtest mod1 mod2