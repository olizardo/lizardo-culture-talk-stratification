local i=1
foreach name in movies music books arts plays {
                    local pos educ
                    if "`name'"=="movies"|"`name'"=="music" {
                              local pos age
                              }
                    ipf,fit(`pos'*freq_`name'+`pos'*talk_`name')
                    replace name="`name'" in `i'
                    replace g2=r(g2) in `i'
                    replace df=r(df) in `i'
                    replace p=r(pvg) in `i'
                    replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                    local i=`i'+1       
                    ipf,fit(`pos'*talk_`name'+talk_`name'*freq_`name')
                    replace name="`name'" in `i'
                    replace g2=r(g2) in `i'
                    replace df=r(df) in `i'
                    replace p=r(pvg) in `i'
                    replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                    local i=`i'+1                 
                    ipf,fit(`pos'*freq_`name'+freq_`name'*talk_`name')
                    replace name="`name'" in `i'
                    replace g2=r(g2) in `i'
                    replace df=r(df) in `i'
                    replace p=r(pvg) in `i'
                    replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                    local i=`i'+1
                    ipf,fit(`pos'*freq_`name'+freq_`name'*talk_`name'+`pos'*talk_`name')
                    replace name="`name'" in `i'
                    replace g2=r(g2) in `i'
                    replace df=r(df) in `i'
                    replace p=r(pvg) in `i'
                    replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                    local i=`i'+1
                    if "`name'"=="books" {
                              ipf,fit(gender*freq_`name'+gender*talk_`name')
                              replace name="`name'" in `i'
                              replace g2=r(g2) in `i'
                              replace df=r(df) in `i'
                              replace p=r(pvg) in `i'
                              replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                              local i=`i'+1       
                              ipf,fit(gender*talk_`name'+talk_`name'*freq_`name')
                              replace name="`name'" in `i'
                              replace g2=r(g2) in `i'
                              replace df=r(df) in `i'
                              replace p=r(pvg) in `i'
                              replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                              local i=`i'+1                 
                              ipf,fit(gender*freq_`name'+freq_`name'*talk_`name')
                              replace name="`name'" in `i'
                              replace g2=r(g2) in `i'
                              replace df=r(df) in `i'
                              replace p=r(pvg) in `i'
                              replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                              local i=`i'+1
                              ipf,fit(gender*freq_`name'+freq_`name'*talk_`name'+gender*talk_`name')
                              replace name="`name'" in `i'
                              replace g2=r(g2) in `i'
                              replace df=r(df) in `i'
                              replace p=r(pvg) in `i'
                              replace bic=r(g2)-r(df)*log(r(ncells)) in `i'
                              local i=`i'+1
                              }

          }
format p %9.4f
format bic g2 %9.2f
