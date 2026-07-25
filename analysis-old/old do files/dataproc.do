use "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\NSS-2002-2004-using.dta",clear
keep talk_books-talk_music freq_books-freq_movies educ finc marital race urban age gender married year child_young
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
	gen children=child_young!=.
	drop child_young
	foreach var of varlist educ finc marital race urban age gender children fincdk year {
		tab `var',g(`var')
		}
	}
drop educ finc marital race urban age gender married children

cd "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\biprobit-analysis"
 
global spec age1-age7 educ1-educ6 finc1-finc6 race1-race5 marital1-marital4 urban1-urban3 gender1-gender2  children1-children2 fincdk1-fincdk2 year1-year2
constapply2,stub(books)
bioprobit (talk_books $spec)(freq_books $spec),collin const(1/20) tech(nr)

