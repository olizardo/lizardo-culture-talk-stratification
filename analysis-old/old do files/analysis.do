do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\dataproc.do"
use "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\NSS-2002-2004-using.dta",clear


cd "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do"

do "N:\Private\SOCIOLOGY OF CULTURE\cultural-capital-interaction\do\globals.do"

*/recursive model that works*/
xi:bioprobit (talk_musicbin=$controls_i freq_music)(freq_music=$controls_i i.no_art_time i.no_art_health i.no_art_friends),tech(bhhh)



foreach name in movies music books arts plays  {
	foreach y in artmore_cheap artmore_info artmore_closer {
		qui xi:biprobit (freq_`name'bin=$controls_i)(`y'=$controls_i)
		disp "combo: freq_`name'bin and `y'"
		test [athrho]_cons=0
		}
	}

foreach name in movies music books arts plays  {
	foreach y in no_art_health no_art_time no_art_friends  {
		qui xi:biprobit (freq_`name'bin=$controls_i)(`y'=$controls_i)
		disp "combo: freq_`name'bin and `y'"
		test [athrho]_cons=0
		}
	}
	
foreach name in movies music books arts plays  {
	foreach y in no_art_health no_art_time no_art_friends {
		qui xi:biprobit (talk_`name'bin=$controls_i)(`y'=$controls_i)
		disp "combo: talk_`name'bin and `y'"
		test [athrho]_cons=0
		}
	}

foreach name in movies music books arts plays  {
	foreach y in artmore_cheap artmore_info artmore_closer {
		qui xi:biprobit (talk_`name'bin=$controls_i)(`y'=$controls_i)
		disp "combo: talk_`name'bin and `y'"
		test [athrho]_cons=0
		}
	}
		
		
			




	





