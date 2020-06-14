** Analysis do file for "Investing in school readiness"
** This file replicates tables and figures in main manuscript & appendix

/*
Date: August 15, 2018
Author: Nozomi Nakajima
*/


clear

set matsize 7500
set mem 1g
set scheme s1color

*global path "SET PATH HERE"*
global data "$path/data"
global output "$path/output"

********************************************************************************

use "$data/clean_ECED_Pathways.dta", clear

* sample=1 if type_student!=. & zcompscore_total!=. & year==3
* Only kids for whom we know their sequence, have their test scores, and observed in 2013
keep if sample==1


********************************************************************************
* Table 1. Summary Statistics
********************************************************************************

outreg2 using table1.xls, replace sum(log) keep( ///
zcompscore_lang zcompscore_math zcompscore_cog ///
type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
agecat1 agecat2 agecat3 agecat4 ///
classcat1 classcat2 classcat3 ///
girl ///
stuntingcat1 ///
zwealth ///
mother_edyrs_max ///
std_pquality ///
std_centerquality ///
fee_monthly) ///
groupvar(TestScores zcompscore_lang zcompscore_math zcompscore_cog ///
ECDSequence type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
ChildChar agecat1 agecat2 agecat3 agecat4 classcat1 classcat2 classcat3 girl stuntingcat1 ///  
FamilyChar zwealth mother_edyrs_max std_pquality ///
PreschoolChar std_centerquality fee_monthly) see label 


********************************************************************************
* Table 2. Diff. in enrollment patterns
********************************************************************************

tab mothered_mean, gen(mothered_mean)
tab vquality
replace vquality=. if vquality==9
	
preserve
keep type_student3 type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_5 type_studentB_6 type_studentB_7 ///
	cov7 agecat1 agecat2 agecat3 agecat4 ///
	cov3 classcat1 classcat2 classcat3 ///
	girl girlcat1 girlcat2 ///
	stuntingcat stuntingcat1 stuntingcat2 ///
	wealthquintile wealthcat1 wealthcat5 ///
	mothered_mean mothered_mean1 mothered_mean2 ///
	pquality pqualitycat1 pqualitycat5 ///
	vquality vqualitycat1 vqualitycat3 
order type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5

bysort cov7: outreg2 using table2.xls, replace sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label 
	
bysort cov3: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label

bysort girl: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label

bysort stuntingcat: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label

bysort mothered_mean: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label
	
bysort wealthquintile: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label	
	
bysort pquality: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label	

bysort vquality: outreg2 using table2.xls, append sum(log) keep( ///
	type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5) ///
	eqkeep(N mean sd min max) label	
	
restore


********************************************************************************
* Table 3. Diff. in test scores
********************************************************************************

estimates drop _all
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo: mean `y', over(cov7) 
eststo: mean `y', over(cov3)
eststo: mean `y', over(girl) 
eststo: mean `y', over(stuntingcat) 
eststo: mean `y', over(wealthquintile) 
eststo: mean `y', over(mothered_mean) 
eststo: mean `y', over(pquality) 
eststo: mean `y', over(vquality)
}
outreg2 [est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11 est12 est13 est14 est15 est16 est17 est18 est19 est20 est21 est22 est23 est24] using "$output/table3.xls", replace excel label ci br 

estimates drop _all
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo: reg `y' i.cov7 
eststo: reg `y' i.cov3
eststo: reg `y' i.girl
eststo: reg `y' i.stuntingcat
eststo: reg `y' i.wealthquintile
eststo: reg `y' i. mothered_mean
eststo: reg `y' i.pquality
eststo: reg `y' i.vquality
}
outreg2 [est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 est11 est12 est13 est14 est15 est16 est17 est18 est19 est20 est21 est22 est23 est24] using "$output/table3_diff.xls", replace excel label ci br 


********************************************************************************
* Table 4. Multinomial logistic regression
********************************************************************************
* Do household and preschool characteristics predict selection into different ECED sequence? 

local control2 "zwealth mother_edyrs_max std_pquality cov7 girlcat2 stuntingcat1"
local missing2 "zhawhom zwealthm mother_edyrs_max_m pquality_m"

gen fee_monthly_cat = 0 if fee_monthly==0
 replace fee_monthly_cat = 1 if fee_monthly>0 & fee_monthly<=10000
 replace fee_monthly_cat = 2 if fee_monthly>10000 & fee_monthly<.
 tab fee_monthly_cat, summ(fee_monthly)
 label define fee 0 "No fee" 1 "Less than 10,000" 2 "More than 10,000" 
 label values fee_monthly_cat fee

estimates drop _all

eststo est1 : mlogit type_student3 i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(4) rrr
eststo est2 : mlogit months_attend_playgroup i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(1) rrr
eststo est3 : mlogit months_attend_kinder i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(1) rrr

esttab est1 using "$output/table4.csv", replace se star(* 0.1 ** 0.05 *** 0.01) pr2 label eform
outreg2 [est1] using "$output/table4.xls", replace se label eform


********************************************************************************
* Figure 1
********************************************************************************

mlogit type_student3 i.vquality zwealth if vquality!=9, robust cluster(ea) base(6) rrr
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(1)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(2)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(3)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(4)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(5)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(6)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) vquality=(1 2 3)) pr(out(7)) vsquish
 
 predict p1 p2 p3 p4 p5 p6 p7
 sort zwealth
foreach y in p1 p2 p6 p4{
twoway (line `y' zwealth if vquality==1 & vquality!=9) ///
 (line `y' zwealth if vquality==2 & vquality!=9) ///
 (line `y' zwealth if vquality==3 & vquality!=9), /// 
 legend(order(1 "Bottom tercile ECED quality" 2 "Middle tercile ECED quality" 3 "Top tercile ECED quality") ///
 ring(0) col(1) size(small)) name(`y', replace) ///
 ytitle(Predicted probability, size(small)) title(`y', size(small)) ///
 xtitle(,size(small)) ylabel(,labsize(small)) ///
 xlabel(,labsize(small)) scheme(s2mono) graphregion(color(white)) 
}
grc1leg p1 p2 p6 p4, ycommon xcommon imargin(0 0 0 0)
graph export figure1a.pdf, replace

drop p1 p2 p3 p4 p5 p6 p7

mlogit type_student3 i.vquality mother_edyrs_max if vquality!=9, robust cluster(ea) base(4) rrr
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(1)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(2)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(3)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(4)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(5)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(6)) vsquish
 margins, at(mother_edyrs_max=(1 6 9 12 15) vquality=(1 2 3)) pr(out(7)) vsquish
 
 predict p1 p2 p3 p4 p5 p6 p7
 sort mother_edyrs_max
foreach y in p1 p2 p6 p4 {
twoway (line `y' mother_edyrs_max if vquality==1 & vquality!=9) ///
 (line `y' mother_edyrs_max if vquality==2 & vquality!=9) ///
 (line `y' mother_edyrs_max if vquality==3 & vquality!=9), /// 
 legend(order(1 "Bottom tercile ECED quality" 2 "Middle tercile ECED quality" 3 "Top tercile ECED quality") ///
 ring(0) col(1) size(small)) name(`y', replace) ///
 ytitle(Predicted probability, size(small)) title(`y', size(small)) ///
 xtitle(,size(small)) ylabel(,labsize(small)) ///
 xlabel(,labsize(small)) scheme(s2mono) graphregion(color(white)) 
}
grc1leg p1 p2 p6 p4, ycommon xcommon imargin(0 0 0 0)
graph export figure1b.pdf, replace

drop p1 p2 p3 p4 p5 p6 p7


********************************************************************************
* Figure 2
********************************************************************************

mlogit type_student3 i.fee_monthly_cat zwealth if vquality!=9, robust cluster(ea) base(6) rrr
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(1)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(2)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(3)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(4)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(5)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(6)) vsquish
 margins, at(zwealth=(-3 -2 -1 0 1 2 3) fee_monthly_cat=(0 1 2))  pr(out(7)) vsquish
 
 predict p1 p2 p3 p4 p5 p6 p7
 sort zwealth
foreach y in p1 p2 p6 p4 {
twoway (line `y' zwealth if fee_monthly_cat==0) ///
 (line `y' zwealth if fee_monthly_cat==1) ///
 (line `y' zwealth if fee_monthly_cat==2), /// 
 legend(order(1 "No fee" 2 "Less than 10,000 IDR" 3 "More than 10,000 IDR") ///
 ring(0) row(1) size(small)) name(`y', replace) ///
 ytitle(Predicted probability, size(small)) title(`y', size(small)) ///
 xtitle(,size(small)) ylabel(,labsize(small)) ///
 xlabel(,labsize(small)) scheme(s2mono) graphregion(color(white)) 
}
grc1leg p1 p2 p6 p4, ycommon xcommon imargin(0 0 0 0)
graph export figure2.pdf, replace

drop p1 p2 p3 p4 p5 p6 p7


********************************************************************************
* Table 5. Association of ECED pathway and test score
********************************************************************************

local child "agecat2- agecat4 classcat2- classcat6 girlcat2 stuntingcat1"
local childm "cov3m zhawhom"

local fam "zwealth mother_edyrs_max std_pquality"
local famm "zwealthm mother_edyrs_max_m pquality_m"

local ecd "std_centerquality fee_monthly"

estimates drop _all

foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo `y'_2d: quietly reg `y' i.type_student3 $child $childm $fam $famm $ecd , robust
eststo `y'_2a: quietly reg `y' i.type_student3 if e(sample)==1, robust
eststo `y'_2b: quietly reg `y' i.type_student3 $child $childm if e(sample)==1, robust
eststo `y'_2c: quietly reg `y' i.type_student3 $child $childm $fam $famm if e(sample)==1, robust
}

// pariwise contrasts
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
reg `y' i.type_student3 $child $childm $fam $famm $ecd , robust
pwcompare type_student3, effects sort
}

outreg2 [zcompscore_lang_2d zcompscore_math_2d zcompscore_cog_2d] ///
using "$output/table5.xls", replace se r2 label


********************************************************************************
* Figure 3. Cost-effectiveness
********************************************************************************
** See "ce_analyses.xlsx" for assumptions 

gen type_student_alt=.
replace type_student_alt=1 if type_student==1
replace type_student_alt=2 if type_student==2 | type_student==3
replace type_student_alt=3 if type_student==4
replace type_student_alt=4 if type_student==5
label define alt 1 "No ECED" 2 "Some ECED" 3 "Ideal" 4 "Other"
label values type_student_alt alt

gen type_student_alt2 = .
replace type_student_alt2 = 1 if type_student3 ==1 
replace type_student_alt2 = 2 if type_student3 ==2 | type_student3 ==3 | type_student3 ==6 | type_student3 ==7   
replace type_student_alt2 = 3 if type_student3 ==4  
replace type_student_alt2 = 4 if type_student3 ==5 
label values type_student_alt2 alt

estimates drop _all
foreach y in zcompscore_lang zcompscore_math {
reg `y' i.type_student_alt2 $child $childm $fam $famm $ecd , robust cluster(ea)
eststo: reg `y' i.type_student_alt2 if e(sample)==1, robust cluster(ea)
eststo: reg `y' i.type_student_alt2 $child $childm if e(sample)==1, robust cluster(ea)
eststo: reg `y' i.type_student_alt2 $child $childm $fam $famm if e(sample)==1, robust cluster(ea)
eststo: reg `y' i.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)

eststo: reg `y' ib2.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
}
outreg2 [est1 est2 est3 est4 est5 est6 est7 est8 est9 est10] using "$output/ce_estimates.xls", replace excel label br 


********************************************************************************
********************************************************************************
********************************************************************************


********************************************************************************
* Appendix 1
********************************************************************************

* Figure 1.1
twoway kdensity compscore_total, by(cov7)
graph export appendix_figure1a.pdf, replace


* Figure 1.2
kdensity zcompscore_total
graph export appendix_figure1b.pdf, replace


********************************************************************************
* Appendix 3
********************************************************************************

local control2 "zwealth mother_edyrs_max std_pquality cov7 girlcat2 stuntingcat1"
local missing2 "zhawhom zwealthm mother_edyrs_max_m pquality_m"

estimates drop _all

eststo est1 : mlogit type_student3 i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(4) rrr
eststo est2 : mlogit months_attend_playgroup i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(1) rrr
eststo est3 : mlogit months_attend_kinder i.vquality i.fee_monthly_cat $control2 if sample==1 & vquality!=9, robust cluster(ea) base(1) rrr

esttab est2 est3 using "$output/appendix_table3.csv", replace se star(* 0.1 ** 0.05 *** 0.01) pr2 label eform
outreg2 [est2 est3] using "$output/appendix_table3.xls", replace se label eform


********************************************************************************
* Appendix 4
********************************************************************************

local child "agecat2- agecat4 classcat2- classcat6 girlcat2 stuntingcat1"
local childm "cov3m zhawhom"

local fam "zwealth mother_edyrs_max std_pquality"
local famm "zwealthm mother_edyrs_max_m pquality_m"

local ecd "std_centerquality fee_monthly"

estimates drop _all

foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo `y'_3d: quietly reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder $child $childm $fam $famm $ecd , robust
eststo `y'_3a: quietly reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder if e(sample)==1, robust
eststo `y'_3b: quietly reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder $child $childm if e(sample)==1, robust
eststo `y'_3c: quietly reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder $child $childm $fam $famm if e(sample)==1, robust
*pwcompare type_student3, effects mcompare(bonferroni) groups sort 
*pwcompare type_student3, effects mcompare(bonferroni) groups sort coeflegend
pwcompare type_student3, effects sort
}

// pairwise contrasts
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder $child $childm $fam $famm $ecd , robust
pwcompare type_student3, effects sort
}

outreg2 [zcompscore_lang_3d zcompscore_math_3d zcompscore_cog_3d] ///
using "$output/appendix_table4.xls", replace se r2 label


********************************************************************************
* Appendix 5
********************************************************************************

putexcel set "$output/appendix5.xls", replace
  putexcel B1 = ("Baseline Coef")
  putexcel C1 = ("Baseline SE")
  putexcel D1 = ("Baseline R2")
  putexcel E1 = ("Control Coef")
  putexcel F1 = ("Control SE")
  putexcel G1 = ("Control R2")
  putexcel H1 = ("Adjusted Coef")
  putexcel I1 = ("Adjusted SE Bootsrap")
  putexcel J1 = ("Lower bound")
  putexcel K1 = ("Upper bound")
  putexcel L1 = ("Delta")

** Rmax = 1.3 * R-tilde (see end of Section 5 of Oster 2017)
** Identified Set = [ Beta-tilde, Beta*(min{1.3R-tilde, 1}, 1) ] 

// Language - Some ECED
quietly reg zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd, robust cluster(ea)
regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 if e(sample)==1, robust cluster(ea)
	local col1_b  = _b[2.type_student_alt2]
	local col1_se = _se[2.type_student_alt2]
	local col1_r  = e(r2)
	display `col1_b' `col1_se' `col1_r'

regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
	local col2_b  = _b[2.type_student_alt2]
	local col2_se = _se[2.type_student_alt2]
	local col2_r  = e(r2)
	display `col2_b' `col2_se' `col2_r'
	
local rmax_lang = e(r2) * 1.33

bs r(beta), rep(100): psacalc beta 2.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2) model(regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd)
	local col3_b = _b[_bs_1]
	local col3_se = _se[_bs_1]
	
regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
psacalc beta 2.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2)
	local col4_1 = r(beta)
	local col4_2 = `col2_b'
	
psacalc delta 2.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2)
	local col5_delta = r(delta)

  putexcel A2 = ("Language Test z-score (Rmax=`rmax_lang')")
  putexcel A3 = ("Some ECED")
  matrix B3 = `col1_b', `col1_se', `col1_r',  `col2_b', `col2_se', `col2_r', `col3_b', `col3_se', `col4_1', `col4_2', `col5_delta'
  putexcel B3 = matrix(B3)
 
// Language - Ideal ECED
quietly reg zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd, robust cluster(ea)
regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 if e(sample)==1, robust cluster(ea)
	local col1_b  = _b[3.type_student_alt2]
	local col1_se = _se[3.type_student_alt2]
	local col1_r  = e(r2)
	display `col1_b' `col1_se' `col1_r'

regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
	local col2_b  = _b[3.type_student_alt2]
	local col2_se = _se[3.type_student_alt2]
	local col2_r  = e(r2)
	display `col2_b' `col2_se' `col2_r'
	
local rmax_lang = e(r2) * 1.33

bs r(beta), rep(100): psacalc beta 3.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2) model(regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd)
	local col3_b = _b[_bs_1]
	local col3_se = _se[_bs_1]

regress zcompscore_lang 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
psacalc beta 3.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2)
	local col4_1 = r(beta)
	local col4_2 = `col2_b' 
	
psacalc delta 3.type_student_alt2, rmax(`rmax_lang') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2)
	local col5_delta = r(delta)
  
  putexcel A4 = ("Ideal ECED")
  matrix B4 = `col1_b', `col1_se', `col1_r',  `col2_b', `col2_se', `col2_r', `col3_b', `col3_se', `col4_1', `col4_2', `col5_delta'
  putexcel B4 = matrix(B4)

  
// Langauge - diff base
gen var = 1 if type_student_alt2 == 2
   replace var = 2 if type_student_alt2 == 1
   replace var = 3 if type_student_alt2 == 3
   replace var = 4 if type_student_alt2 == 4
reg zcompscore_lang 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd, robust cluster(ea) 
  psacalc beta 3.var, rmax(`rmax_lang') mcontrol(1.var 2.var 4.var)
reg zcompscore_lang 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd, robust cluster(ea) 
  bs r(beta), rep(100): psacalc beta 3.var, rmax(`rmax_lang') mcontrol(1.var 2.var 4.var) model(regress zcompscore_lang 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd)
 
 
********************************************************************************
// Math - Some ECED
quietly reg zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd, robust cluster(ea)
regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 if e(sample)==1, robust cluster(ea)
	local col1_b  = _b[2.type_student_alt2]
	local col1_se = _se[2.type_student_alt2]
	local col1_r  = e(r2)
	display `col1_b' `col1_se' `col1_r'

regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
	local col2_b  = _b[2.type_student_alt2]
	local col2_se = _se[2.type_student_alt2]
	local col2_r  = e(r2)
	display `col2_b' `col2_se' `col2_r'
	
local rmax_math = e(r2) * 1.33

bs r(beta), rep(100): psacalc beta 2.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2) model(regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd)
	local col3_b = _b[_bs_1]
	local col3_se = _se[_bs_1]

regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
psacalc beta 2.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2)
	local col4_1 = r(beta)
	local col4_2 = `col2_b'
	
psacalc delta 2.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 3.type_student_alt2 4.type_student_alt2)
	local col5_delta = r(delta)
  
  putexcel A5 = ("Math Test z-score (Rmax=`rmax_math')")
  putexcel A6 = ("Some ECED")
  matrix B6 = `col1_b', `col1_se', `col1_r',  `col2_b', `col2_se', `col2_r', `col3_b', `col3_se', `col4_1', `col4_2', `col5_delta'
  putexcel B6 = matrix(B6)

// Math - Ideal ECED
quietly reg zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd, robust cluster(ea)
regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 if e(sample)==1, robust cluster(ea)
	local col1_b  = _b[3.type_student_alt2]
	local col1_se = _se[3.type_student_alt2]
	local col1_r  = e(r2)
	display `col1_b' `col1_se' `col1_r'

regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
	local col2_b  = _b[3.type_student_alt2]
	local col2_se = _se[3.type_student_alt2]
	local col2_r  = e(r2)
	display `col2_b' `col2_se' `col2_r'
	
local rmax_math = e(r2) * 1.33

bs r(beta), rep(100): psacalc beta 3.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2) model(regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd)
	local col3_b = _b[_bs_1]
	local col3_se = _se[_bs_1]

regress zcompscore_math 1.type_student_alt2 2.type_student_alt2 3.type_student_alt2 4.type_student_alt2 $child $childm $fam $famm $ecd if e(sample)==1, robust cluster(ea)
psacalc beta 3.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2)
	local col4_1 = r(beta)
	local col4_2 = `col2_b' 
	
psacalc delta 3.type_student_alt2, rmax(`rmax_math') mcontrol(1.type_student_alt2 2.type_student_alt2 4.type_student_alt2)
	local col5_delta = r(delta)
  
  putexcel A7 = ("Ideal ECED")
  matrix B7 = `col1_b', `col1_se', `col1_r',  `col2_b', `col2_se', `col2_r', `col3_b', `col3_se', `col4_1', `col4_2', `col5_delta'
  putexcel B7 = matrix(B7)  
	
	
// Math - diff base
reg zcompscore_math 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd, robust cluster(ea) 
  psacalc beta 3.var, rmax(`rmax_lang') mcontrol(1.var 2.var 4.var)
reg zcompscore_math 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd, robust cluster(ea) 
  bs r(beta), rep(100): psacalc beta 3.var, rmax(`rmax_lang') mcontrol(1.var 2.var 4.var) model(regress zcompscore_math 1.var 2.var 3.var 4.var $child $childm $fam $famm $ecd)
 
 
 
********************************************************************************
* Additional analyses for PANEL KIDS
********************************************************************************

use "$data/clean_ECED_Pathways.dta", clear


*Baseline EDIs for PANEL KIDS
foreach x in short_phys short_soc short_emot short_langcog short_comgen {
egen b_`x'=std(`x') if year==1
egen bl_`x'=max(b_`x'), by(childid)
drop b_`x'
}
gen sample_panel=0 if sample==1 
replace sample_panel=1 if sample==1 & !missing(bl_short_langcog)

la define sample_panel 0 "Non-panel" 1 "Panel"
la val sample_panel sample_panel


*Regress test scores on sequence for panel kids
local control "agecat2- agecat4 classcat2- classcat6 girlcat2 stuntingcat1 zwealth mother_edyrs_max std_pquality std_centerquality fee_monthly"
local missing "cov3m zhawhom zwealthm mother_edyrs_max_m pquality_m"
local baseline "bl_short_phys bl_short_soc bl_short_emot bl_short_langcog bl_short_comgen"

estimates drop _all

*1. Sequence
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo `y'_1: quietly reg `y' i.type_student $baseline $control $missing if sample_panel==1, robust  
*pwcompare type_student, effects mcompare(bonferroni) groups sort
*pwcompare type_student, effects mcompare(bonferroni) groups sort coeflegend
pwcompare type_student, effects sort
}
*2. Sequence & Timing
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo `y'_2: quietly reg `y' i.type_student3 $baseline $control $missing if sample_panel==1, robust 
*pwcompare type_student3, effects mcompare(bonferroni) groups sort
*pwcompare type_student3, effects mcompare(bonferroni) groups sort coeflegend
pwcompare type_student3, effects sort
}
*2b. Duration
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
eststo `y'_2b: quietly reg `y' i.type_student3 ib1.months_attend_playgroup ib1.months_attend_kinder $baseline $control $missing if sample_panel==1, robust 
*pwcompare type_student3, effects mcompare(bonferroni) groups sort 
*pwcompare type_student3, effects mcompare(bonferroni) groups sort coeflegend
pwcompare type_student3, effects sort
}
outreg2 [zcompscore_lang_1 zcompscore_lang_2 zcompscore_lang_2b ///
zcompscore_math_1 zcompscore_math_2 zcompscore_math_2b ///
zcompscore_cog_1 zcompscore_cog_2 zcompscore_cog_2b] ///
using "$output/reg_panel.xls", replace se r2 label


*For cost-effectiveness estimates
foreach y in zcompscore_lang zcompscore_math zcompscore_cog {
reg `y' i.type_student3 i.months_attend_playgroup i.months_attend_kinder $control $missing if sample_panel==1, robust 
margins, dydx(type_student3) at(months_attend_playgroup=(0 1 2) months_attend_kinder=(0 1 2)) vsquish
}

*Summary statistics of panel children vs. non-panel children
outreg2 using desc_nonpanel.xls if sample_panel==0, replace sum(log) keep( ///
zcompscore_lang zcompscore_math zcompscore_cog ///
type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
agecat1 agecat2 agecat3 agecat4 ///
classcat1 classcat2 classcat3 ///
girl ///
stuntingcat1 ///
zwealth ///
mother_edyrs_max ///
std_pquality ///
std_centerquality ///
fee_monthly) ///
groupvar(TestScores zcompscore_lang zcompscore_math zcompscore_cog ///
ECDSequence type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
ChildChar agecat1 agecat2 agecat3 agecat4 classcat1 classcat2 classcat3 girl stuntingcat1 ///  
FamilyChar zwealth mother_edyrs_max std_pquality ///
PreschoolChar std_centerquality fee_monthly) see label 

outreg2 using desc_panel.xls if sample_panel==1, replace sum(log) keep( ///
zcompscore_lang zcompscore_math zcompscore_cog ///
type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
agecat1 agecat2 agecat3 agecat4 ///
classcat1 classcat2 classcat3 ///
girl ///
stuntingcat1 ///
zwealth ///
mother_edyrs_max ///
std_pquality ///
std_centerquality ///
fee_monthly) ///
groupvar(TestScores zcompscore_lang zcompscore_math zcompscore_cog ///
ECDSequence type_studentB_1 type_studentB_2 type_studentB_3 type_studentB_4 type_studentB_7 type_studentB_6 type_studentB_5 ///
ChildChar agecat1 agecat2 agecat3 agecat4 classcat1 classcat2 classcat3 girl stuntingcat1 ///  
FamilyChar zwealth mother_edyrs_max std_pquality ///
PreschoolChar std_centerquality fee_monthly) see label 

