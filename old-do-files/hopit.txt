* DISCLAIMER: The following code is provided as is and should be used at your own risk. 
* No user support is available.

* Teresa Bago d'Uva, November 2006


* This program relates to the material described in Chapter 4 of the book 
* Jones, A.M., Rice, N., Bago d'Uva, T. & Balia, S. (2007)
* "Applied Health Economics", London: Routledge {ISBN: 9780415397728}  


/* DATASET CONTAINS DATA FOR INDIA FROM THE WHO - MULTI COUNTRY SURVEY
id- individual identifier
age - age in years
female - dummy variable
educ - number of education years 
lincome - log of monthly household income by equivalent adult (in national currency)
aff - self-assessed individual health in the domain affective behaviour (affect)
vaff1-vaff4 - ratings of 4 vignettes in the domain of affective behaviour           */


/* LOAD THE STATA DATASET */
clear
set memory 10m
use "WHOMCSIndia.dta"

/* DEFINE DEP VARIABLE */
rename aff y

/* CREATE LISTS OF VARIABLES */
global xvar female age educ lincome

/* ORD PROBIT FOR OWN HEALTH (imposing same cutpt => homogeneous reporting behaviour)  */

* ESTIMATE MODEL AND SAVE RESULTS
oprobit y $xvar
mat coefs_oprob=get(_b)
scalar k=colsof(coefs_oprob)-4
mat xbs_oprob=coefs_oprob[1,1..k]'
*mat list xbs_oprob
predict yf, xb

* PARTIAL EFFECTS ON PROBABILITY OF REPORTING BEST HEALTH CATEGORY
scalar mu4=_b[/cut4]
scalar bfemale=_b[female]
gen ae_p5_female=0
replace ae_p5_female=(1-norm(mu4-yf-bfemale))-(1-norm(mu4-yf)) if !female
replace ae_p5_female=(1-norm(mu4-yf))-(1-norm(mu4-yf+bfemale)) if female
summ ae_p5_female
drop yf ae_p5_female


/* REPORTING BEHAVIOUR (allowing for cutpt shift => heterogenous reporting behaviour)  */

* RENAME VIGNETTES *
rename vaff1 vig1
rename vaff2 vig2
rename vaff3 vig3
rename vaff4 vig4 

* TABULATION OF VIGNETTES
tab1 vig*

* CONVERT FILE TO LONG FORMAT * 
reshape long vig, i(id) j(vignum) 

* CREATE VIGNETTE DUMMIES
tab vignum, gen (vigdum)
drop vigdum1

/* OPROBIT FOR VIGNETTES (imposing parallel shift) */

* ESTIMATE OPROB FOR VIGNETTES * 
oprobit vig $xvar vigdum*

* COMPUTE INDIVIDUAL CUTPTS WITH PARALLEL SHIFT *
* set vignette dummies equal to zero to be able to use xb to predict cut-pt shift
replace vigdum2=0
replace vigdum3=0
replace vigdum4=0
predict minuscutptshift, xb
drop vigdum*
gen mu1par=_b[/cut1]-minuscutptshift
gen mu2par=_b[/cut2]-minuscutptshift
gen mu3par=_b[/cut3]-minuscutptshift
gen mu4par=_b[/cut4]-minuscutptshift

/* GOP FOR VIGNETTES (not imposing parallel shift) */

* CREATE VIGNETTE DUMMIES
tab vignum, gen (vigdum)
drop vigdum1

* PROGRAM FOR GENERALISED ORDERED PROBIT FOR VIGNETTES *
* - CUTPTS FUNCTIONS OF INDIVIDUAL CHARACTERISTICS
* - HEALTH INDEX FUNCTION OF VIGNETTE DUMMIES *
#delimit ;
cap program drop gop;
program define gop;
version 8.0; 

args lnf b m1 m2 m3 m4; 

	tempvar p1 p2 p3 p4 p5; 

    	quietly {;
	gen double `p1' = 0;
	gen double `p2' = 0;
	gen double `p3' = 0;
	gen double `p4' = 0;
	gen double `p5' = 0;

	replace `p1' = norm(`m1'-`b');
	replace `p2' = norm(`m2'-`b') - norm(`m1'-`b');
	replace `p3' = norm(`m3'-`b') - norm(`m2'-`b');
	replace `p4' = norm(`m4'-`b') - norm(`m3'-`b');
	replace `p5' = 1                   - norm(`m4'-`b');

	replace `lnf' = (vig==1)*ln(`p1')+ (vig==2)*ln(`p2')+ (vig==3)*ln(`p3')+(vig==4)*ln(`p4')+ (vig==5)*ln(`p5'); 
	};

end;
#delimit cr

* ESTIMATE GENERALISED ORDERED PROBIT FOR VIGNETTES *
#delimit ;
set matsize 50;
ml model lf gop (xb: vigdum*, nocons)
				   (mu1: $xvar) (mu2: $xvar) (mu3: $xvar) (mu4: $xvar) if vig!=.;
ml search;
ml maximize;
#delimit cr
drop vigdum*

*             TESTS of SIGNIFICANCE OF VARS in CUTPTS (WALD TESTS)           *

*  SIGNIFICANCE OF ALL COVARS IN CUTPTS - TEST OF REPORTING HETEROGENEITY BY ALL COVARS *
test ([mu1]) ([mu2]) ([mu3]) ([mu4]) 

* SIGNIFICANCE OF GROUPS OF VARIABLES IN CUTPTS - TEST OF HETEROGENEITY BY GROUPS OF COVARS*
test [mu1]female [mu2]female [mu3]female [mu4]female
test [mu1]age [mu2]age [mu3]age [mu4]age
test [mu1]educ [mu2]educ [mu3]educ [mu4]educ
test [mu1]lincome [mu2]lincome [mu3]lincome [mu4]lincome

*  TESTS OF PARALLEL SHIFT *
test [mu1=mu2=mu3=mu4]
test [mu1]female=[mu2]female=[mu3]female=[mu4]female
test [mu1]age=[mu2]age=[mu3]age=[mu4]age
test [mu1]educ=[mu2]educ=[mu3]educ=[mu4]educ
test [mu1]lincome=[mu2]lincome=[mu3]lincome=[mu4]lincome


* COMPUTE INDIVIDUAL CUTPTS FROM ESTIMATES OF GOP FOR VIGNETTES*
predict mu1, eq(mu1)
predict mu2, eq(mu2)
predict mu3, eq(mu3)
predict mu4, eq(mu4)


/* HEALTH EQUATION ADJUSTED FOR HETEROGENEOUS REPORTING BEHAVIOUR */

/* HEALTH EQUATION WITH PARALLEL CUTPT SHIFT */

* RETURN TO WIDE FORMAT TO ESTIMATE INTREG WITH CUTPTS ADJUSTED CUTPT SHIFT *  
reshape wide vig, i(id) j(vignum) 

* CREATE LIMITS OF INTERVALS FOR INTREG WITH CUTPTS ADJUSTED FOR PARALLEL SHIFT *
gen y1par =                          mu1par*(y==2) + mu2par*(y==3) + mu3par*(y==4) + mu4par*(y==5)  if y>1
gen y2par = mu1par*(y==1) + mu2par*(y==2) + mu3par*(y==3) + mu4par*(y==4)		           if y<5

* ESTIMATE INTREG WITH CUTPTS ADJUSTED FOR PARALLEL SHIFT *  
intreg y1par y2par $xvar
predict yf, xb

* SAVE ESTIMATED INTREG COEFFS (COEFFS OF OF HEALTH EQUATION), ADJUSTED BY 
* PARALLEL CUTPOINT SHIFT *
mat coefs_intreg_parallel=get(_b)
mat xbs_parallel=coefs_intreg_parallel[1,1..k]'
*mat list coefs_intreg_parallel
predict lnsig, eq(lnsigma)
scalar sigma_parallel=exp(lnsig)
*display sigma_parallel
drop lnsig

* COMPARE COEFFS WITH NO CUTPT SHIFT WITH COEFFS ADJUSTED FOR PARALLEL SHIFT
mat xbs_oprob_parallel_comp=xbs_oprob* sigma_parallel
mat compxbs_parallel=(xbs_oprob_parallel_comp,xbs_parallel)
mat list compxbs_parallel

* PARTIAL EFFECTS ON PROBABILITY OF BEING IN BEST HEALTH CATEGORY
qui sum mu4par
scalar avgmu4=r(mean)
scalar bfemale=_b[female]
gen ae_p5_female=0
replace ae_p5_female=((1-norm(avgmu4-yf-bfemale))/sigma_parallel)-((1-norm(avgmu4-yf))/sigma_parallel) if !female
replace ae_p5_female=((1-norm(avgmu4-yf))/sigma_parallel)-((1-norm(avgmu4-yf+bfemale))/sigma_parallel) if female
summ ae_p5_female
drop yf ae_p5_female

/* HEALTH EQUATION WITH CUTPT FROM GOP (not imposing parallel shift)*/

* CREATE LIMITS OF INTERVALS FOR INTREG GOP*
gen y1 =			     mu1*(y==2) + mu2*(y==3) + mu3*(y==4) + mu4*(y==5) if y>1
gen y2 = mu1*(y==1) + mu2*(y==2) + mu3*(y==3) + mu4*(y==4)	                    if y<5

* ESTIMATE INTREG WITH CUTPTS ADJUSTED FOR CUTPT SHIFT (GOP) *  
intreg y1 y2 $xvar
predict yf

* SAVE ESTIMATED INTREG COEFFS (COEFFS OF OF HEALTH EQUATION), ADJUSTED CUTPOINT SHIFT (GOP) *
mat coefs_intreg=get(_b)
mat xbs_intreg=coefs_intreg[1,1..k]'
predict lnsig, eq(lnsigma)
scalar sigma_intreg=exp(lnsig)
*display sigma_intreg
drop lnsig

* COMPARE COEFFS WITH NO CUTPT SHIFT WITH COEFFS ADJUSTED FOR CUTPOINT SHIFT (GOP) *
mat xbs_oprob_comp=xbs_oprob* sigma_intreg
mat compxbs=(xbs_oprob_comp,xbs_intreg)
mat list compxbs

* PARTIAL EFFECTS ON PROBABILITY OF BEING IN BEST HEALTH CATEGORY
qui sum mu4
scalar avgmu4=r(mean)
scalar bfemale=_b[female]
gen ae_p5_female=0
replace ae_p5_female=((1-norm(avgmu4-yf-bfemale))/sigma_intreg)-((1-norm(avgmu4-yf))/sigma_intreg) if !female
replace ae_p5_female=((1-norm(avgmu4-yf))/sigma_intreg)-((1-norm(avgmu4-yf+bfemale))/sigma_intreg) if female
summ ae_p5_female
drop yf ae_p5_female


 /*    1 STEP ESTIMATION OF HOPIT MODEL    */

* PROGRAM FOR HOPIT, joint estimation of vignette component and own health model with cutpts determined by vignette component*
* 1. CUTPTS FUNCTIONS OF INDIVIDUAL CHARACTERISTICS, HEALTH INDEX FUNCTION OF VIGNETTE DUMMIES *
* 2. CUTPTS DEFINED BY VIGNETTE COMPONENT, HEALTH INDEX FUNCTION OF INDIVIDUAL CHARACTERISTICS *
#delimit ;
cap program drop hopit;
program define hopit;
version 8.0; 

args lnf b s 
		b_2 b_3 b_4
		m1 m2 m3 m4 ; 

	tempvar b_1  p1_1 p2_1 p3_1 p4_1 p5_1
				 p1_2 p2_2 p3_2 p4_2 p5_2
				 p1_3 p2_3 p3_3 p4_3 p5_3
			       p1_4 p2_4 p3_4 p4_4 p5_4
				 p1 p2 p3 p4 p5; 

    	quietly {;
	gen double `p1_1' = 0; gen double `p2_1' = 0;	gen double `p3_1' = 0; gen double `p4_1' = 0; gen double `p5_1' = 0;
	gen double `p1_2' = 0; gen double `p2_2' = 0; gen double `p3_2' = 0; gen double `p4_2' = 0; gen double `p5_2' = 0; 
	gen double `p1_3' = 0; gen double `p2_3' = 0;	gen double `p3_3' = 0; gen double `p4_3' = 0; gen double `p5_3' = 0;
	gen double `p1_4' = 0; gen double `p2_4' = 0;	gen double `p3_4' = 0; gen double `p4_4' = 0; gen double `p5_4' = 0;

	gen double `p1' = 0; 	gen double `p2' = 0; gen double `p3' = 0; gen double `p4' = 0; gen double `p5' = 0; 

	gen double `b_1' = 0;

	replace `p1_1' = norm(`m1'-`b_1');
	replace `p2_1' = norm(`m2'-`b_1') - norm(`m1'-`b_1');
	replace `p3_1' = norm(`m3'-`b_1') - norm(`m2'-`b_1');
	replace `p4_1' = norm(`m4'-`b_1') - norm(`m3'-`b_1');
	replace `p5_1' = 1                      - norm(`m4'-`b_1');

	replace `p1_2' = norm(`m1'-`b_2');
	replace `p2_2' = norm(`m2'-`b_2') - norm(`m1'-`b_2');
	replace `p3_2' = norm(`m3'-`b_2') - norm(`m2'-`b_2');
	replace `p4_2' = norm(`m4'-`b_2') - norm(`m3'-`b_2');
	replace `p5_2' = 1                      - norm(`m4'-`b_2');

	replace `p1_3' = norm(`m1'-`b_3');
	replace `p2_3' = norm(`m2'-`b_3') - norm(`m1'-`b_3');
	replace `p3_3' = norm(`m3'-`b_3') - norm(`m2'-`b_3');
	replace `p4_3' = norm(`m4'-`b_3') - norm(`m3'-`b_3');
	replace `p5_3' = 1                      - norm(`m4'-`b_3');

	replace `p1_4' = norm(`m1'-`b_4');
	replace `p2_4' = norm(`m2'-`b_4') - norm(`m1'-`b_4');
	replace `p3_4' = norm(`m3'-`b_4') - norm(`m2'-`b_4');
	replace `p4_4' = norm(`m4'-`b_4') - norm(`m3'-`b_4');
	replace `p5_4' = 1                      - norm(`m4'-`b_4');

	replace `p1' = norm((`m1'-`b')/`s') ;
	replace `p2' = norm((`m2'-`b')/`s') - norm((`m1'-`b')/`s');
	replace `p3' = norm((`m3'-`b')/`s') - norm((`m2'-`b')/`s');
	replace `p4' = norm((`m4'-`b')/`s')  - norm((`m3'-`b')/`s');
	replace `p5' = 1                          - norm((`m4'-`b')/`s');

	replace `lnf' =  ((vig1==1)*ln(`p1_1')+ (vig1==2)*ln(`p2_1')+ (vig1==3)*ln(`p3_1')+(vig1==4)*ln(`p4_1')+ (vig1==5)*ln(`p5_1'))
				+ ((vig2==1)*ln(`p1_2')+ (vig2==2)*ln(`p2_2')+ (vig2==3)*ln(`p3_2')+(vig2==4)*ln(`p4_2')+ (vig2==5)*ln(`p5_2'))
				+ ((vig3==1)*ln(`p1_3')+ (vig3==2)*ln(`p2_3')+ (vig3==3)*ln(`p3_3')+(vig3==4)*ln(`p4_3')+ (vig3==5)*ln(`p5_3'))
				+ ((vig4==1)*ln(`p1_4')+ (vig4==2)*ln(`p2_4')+ (vig4==3)*ln(`p3_4')+(vig4==4)*ln(`p4_4')+ (vig4==5)*ln(`p5_4'))

				+ ((y==1)*ln(`p1')+ (y==2)*ln(`p2')+ (y==3)*ln(`p3')+(y==4)*ln(`p4')+ (y==5)*ln(`p5')); 
	
	};

end;
#delimit cr


* ESTIMATE HOPIT *
#delimit ;
set matsize 70;
ml model lf hopit (xb: $xvar) (sig:)
				 (vigdum2:) (vigdum3:) (vigdum4:) 
				 (mu1: $xvar) (mu2: $xvar) (mu3: $xvar) (mu4: $xvar) ;
*ml check;
ml search;
ml maximize;
#delimit cr

*             TESTS of SIGNIFICANCE OF VARS IN CUTPTS  (WALD TESTS)           *

*  SIGNIFICANCE OF ALL COVARS IN CUTPTS - TEST OF REPORTING HETEROGENEITY BY ALL COVARS *
test ([mu1]) ([mu2]) ([mu3]) ([mu4]) 

* SIGNIFICANCE OF GROUPS OF VARIABLES IN CUTPTS - TEST OF HETEROGENEITY BY GROUPS OF COVARS*
test [mu1]female [mu2]female [mu3]female [mu4]female
test [mu1]age [mu2]age [mu3]age [mu4]age
test [mu1]educ [mu2]educ [mu3]educ [mu4]educ
test  [mu1]lincome [mu2]lincome [mu3]lincome [mu4]lincome

*  TESTS OF PARALLEL SHIFT *
test [mu1=mu2=mu3=mu4]
test [mu1]female=[mu2]female=[mu3]female=[mu4]female
test  [mu1]age=[mu2]age=[mu3]age=[mu4]age
test  [mu1]educ=[mu2]educ=[mu3]educ=[mu4]educ
test  [mu1]lincome=[mu2]lincome=[mu3]lincome=[mu4]lincome

* SAVE ESTIMATED HOPIT COEFFS (COEFFS OF OF HEALTH EQUATION), ADJUSTED BY 
* CUTPOINT SHIFT *
mat coefs=get(_b)
mat xbhopit=coefs[1,1..k]'
scalar sigma=_b[sig:_cons]
display sigma

* COMPARE COEFFS WITH NO CUTPT SHIFT WITH COEFFS ADJUSTED FOR NON-PARALLEL SHIFT
mat xbs_oprob_comp=xbs_oprob* sigma
mat compxbs=(xbs_oprob_comp,xbhopit)
mat list compxbs

* PARTIAL EFFECTS ON PROBABILITY OF BEING IN BEST HEALTH CATEGORY
predict yf, eq(xb)
predict mu, eq(mu4)
qui sum mu4
scalar avgmu4=r(mean)
scalar bfemale=_b[female]
gen ae_p5_female=0
replace ae_p5_female=((1-norm(avgmu4-yf-bfemale))/sigma_parallel)-((1-norm(avgmu4-yf))/sigma_parallel) if !female
replace ae_p5_female=((1-norm(avgmu4-yf))/sigma_parallel)-((1-norm(avgmu4-yf+bfemale))/sigma_parallel) if female
summ ae_p5_female
drop yf ae_p5_female
