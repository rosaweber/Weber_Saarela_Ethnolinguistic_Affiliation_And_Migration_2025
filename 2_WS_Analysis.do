
clear 
macro drop all
set more off, perm
set scrollbufsize 320000
capture clear matrix 

*------------------------------------------------------------------------------*
*																			   *
*	 ROSA WEBER & JAN SAARELA	                                               *
*																			   *
*    Ethnolinguistic Affiliation and Migration: 						   	   *
*    Evidence from Multigenerational Population Registers                      *
*																			   *
*	 June 2025                                                                 *
*																		       *
*	 ANALYSIS                					                               *  *							       					                             *
*	 NB: The raw data of the analyses draw on total population administrative  *
*    register data. Access to pseudonymized data is regulated through ethical  *
*    and legal vetting. The permission number from Statistics Finland for      *
*    conducting these analyses is TK-52-694-18.								   *
*																		       *
*    The data are considered sensitive and were made available to the project  *
*    on the condition that there cannot be further distribution of the data.   *
*    For access to the underlying data, interested researchers are asked to    *
*    contact the national statistics agency.                                   *
*																			   *
*    All data access to Finish register data, data preparation, and analyses   *
*    were performed within Statistics Finland's remote access system FIONA.    *
*																			   *
*------------------------------------------------------------------------------*

cd "your directory path"

use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop4.dta", clear

*------------------------------------------------------------------------------*
* Event for migration 
*------------------------------------------------------------------------------*

gen event=0
replace event=1 if mig_indicator1==0 

gen ORIGIN2=ORIGIN+1									
 
gen ym_origin2=.
replace ym_origin2=ym(ORIGIN2, 01)
format ym_origin2 %tm

gen age_mig1=migyear1 - byear
replace event=0 if ym_origin2>=ym_emig & ym_emig!=.  
replace event=0 if (ym_emig>=ym_kuolv & ym_kuolv!=. & ym_emig!=.)

drop if age_mom==. & age_dad==. 

*------------------------------------------------------------------------------*
* Exit and ym_exit                                                 
*------------------------------------------------------------------------------*

gen EXIT=2020

gen ym_exit=ym(EXIT, 12)
format ym_exit %tm

*------------------------------------------------------------------------------*
* END and ym_end : 1) move, 2) move other times, before 18, 3) die, 4) 2020       
*------------------------------------------------------------------------------*

gen END=. 
replace END=migyear1 if event==1 	
replace END=migyear1 if END==. & migyear1!=.  
replace END=dyear if (END==. & dyear!=-99)  
replace END=2020 if END==. & status_2020==1

gen ym_end=.
replace ym_end=ym_emig if event==1 
replace ym_end=ym_emig if (ym_end==. & migyear1!=.) 
replace ym_end=ym_kuolv if (ym_end==. & ym_kuolv!=. ) 
replace ym_end=ym_exit if (ym_end==. & status_2020==1) 
format ym_end %tm

********************************************************************************
drop if ym_origin2==ym_end
drop if ym_end==.

replace event=0 if ind_multmoves_month==1 
replace event=0 if event==1 & ym_emig==ym_origin2 & ym_emig!=.
********************************************************************************

gen back2=0
replace back2=4 if background==1 
replace back2=1 if background==2
replace back2=2 if background==3
replace back2=3 if background==4 

label define back2 4 "Finnish uniform backgr." 1 "Swedish uniform backgr."  2 "Swedish mixed backgr." 3 "Finnish mixed backgr." , replace 
label values back2 back2

save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop5.dta", replace 

*------------------------------------------------------------------------------*
* Stset                                                                  
*------------------------------------------------------------------------------*

use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop5.dta", clear

stset ym_end, failure(event) origin (time ym_origin2) exit (time ym_exit) id(shnro)

save "path to data \swpop6_stset.dta", replace 

*------------------------------------------------------------------------------*
*
* Migration                                  
*      
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear  

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background t2-t16, d(e) vce(cluster shnro) hr
estimates store m1_all 

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16, d(e) vce(cluster shnro)  hr
estimates store m2_all

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19 i.cohort i.mkunta_a17 t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_all

estimate stats m1_all m2_all m3_all 

quietly streg b4.back2 i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.educ_19 i.female i.cohort i.mkunta_a17 t2-t16, d(e) vce(cluster shnro)  hr
estimates store m4_all

*male
streg b1.background t2-t16  if female==0, d(e) vce(cluster shnro) hr
estimates store m1_male 

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m2_male

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.educ_19 i.cohort i.mkunta_a17 t2-t16  if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_male

*female
streg b1.background t2-t16 if female==1, d(e) vce(cluster shnro) hr
estimates store m1_female 

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16 if female==1, d(e) vce(cluster shnro)  hr
estimates store m2_female

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.educ_19 i.cohort i.mkunta_a17 t2-t16  if female==1, d(e) vce(cluster shnro)  hr
estimates store m3_female

*------------------------------------------------------------------------------*
* Table 4 for migration to all destinations 
*------------------------------------------------------------------------------*

gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m5_all  

estimate stats  m5_all 

lincom 1.dummy_sw_pop - 3.background#1.dummy_sw_pop, hr
lincom 3.background#1.dummy_sw_pop -  3.background, hr 
lincom 1.dummy_sw_pop,hr 
lincom 3.background, hr 
lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Migration to Sweden
*------------------------------------------------------------------------------*
  
use "path to data \swpop6_stset.dta", clear
 
gen event2=0
replace event2=1 if event==1 & region_4cat1==1  

stset ym_end, failure(event2) origin (time ym_origin2) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19 i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_sw

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_sw_male

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1, d(e) vce(cluster shnro)  hr
estimates store m3_sw_female

estimate stats  m3_sw

*------------------------------------------------------------------------------*
* Table 4 for migration to Sweden
*------------------------------------------------------------------------------*

gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m5_sw  

estimate stats  m5_sw

lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Migration to other Nordics 
*------------------------------------------------------------------------------*
  
use "path to data \swpop6_stset.dta", clear

gen event2=0
replace event2=1 if event==1 & region_4cat1==2  

stset ym_end, failure(event2) origin (time ym_origin2) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19 i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_nord

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19  i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_nord_male

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1, d(e) vce(cluster shnro)  hr
estimates store m3_nord_female

estimate stats m3_nord

*------------------------------------------------------------------------------*
* Table 4 for migration to other Nordics 
*------------------------------------------------------------------------------*

gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m5_nord 

estimate stats m5_nord

lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Migration to rest of the world 
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear
 
gen event2=0
replace event2=1 if event==1 & (region_4cat1==3 |  region_4cat1==4)

stset ym_end, failure(event2) origin (time ym_origin2) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19 i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_world

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_world_male

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent  i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1, d(e) vce(cluster shnro)  hr
estimates store m3_world_female

estimate stats m3_world

*------------------------------------------------------------------------------*
* Table 4 for migration to the rest of the world                                                                 
*------------------------------------------------------------------------------*
 
gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m5_world  

estimate stats m5_world

lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
*																			   *
* Return migration                                                             *
*					                  									       *
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear

keep if event==1
drop event ORIGIN  EXIT  END ym_origin ym_exit ym_end 

gen event_return=0
replace event_return=1 if  mig_indicator2==1 & migyear2!=0

*Yearmonth_return
gen ym_return=ym(migyear2, migmonth2)
format ym_return %tm 

*Origin
gen ym_origin=ym_emig
replace ym_origin=ym(2020,11) if ym_origin==ym(2020,12)
format ym_origin %tm 

*Exit
gen ym_exit=ym(2020, 12)
format ym_exit %tm 

*End
gen ym_end=. 
replace ym_end=ym_return if event_return==1 
replace ym_end=ym_kuolv if (ym_end==. & ym_kuolv!=.) 
replace ym_end=ym_exit if (ym_end==. & status_2020==2) 
replace ym_end=ym_exit if (ym_end==.) 
format ym_end %tm 

*Age mig 1
recode age_mig1 (20/25 = 1 "20-25") (26/30 = 2 "26-30") (31/35 = 3 "31-35") (36/40 = 4 "36-40") (41/50 = 5 "41-50"),gen(age_cat)

save "path to data \return_stset.dta", replace 

use "path to data \return_stset.dta", clear 

stset ym_end, failure(event_return) origin (time ym_origin) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background t2-t16, d(e) vce(cluster shnro ) hr
estimates store m1_retall 

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16, d(e) vce(cluster shnro )  hr
estimates store m2_retall

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19 i.cohort i.mkunta_a17 t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_retall

estimate stats m1_retall m2_retall m3_retall 

quietly streg b4.back2 i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female   i.educ_19 i.age_cat i.cohort i.mkunta_a17 t2-t16, d(e) vce(cluster shnro)  hr
estimates store m4_retall

*female 
streg b1.background t2-t16 if female==1, d(e) vce(cluster shnro ) hr
estimates store m1_retfem 

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16 if female==1, d(e) vce(cluster shnro )  hr
estimates store m2_retfem

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.cohort i.mkunta_a17 t2-t16 if female==1, d(e) vce(cluster shnro)  hr
estimates store m3_retfem

estimate stats m1_retfem m2_retfem m3_retfem

*male
streg b1.background t2-t16 if female==0, d(e) vce(cluster shnro) hr
estimates store m1_retmale

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m2_retmale

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.cohort i.mkunta_a17 t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_retmale

estimate stats m1_retmale m2_retmale m3_retmale

*------------------------------------------------------------------------------*
* Table 5 for return from all destinations                                                                    
*------------------------------------------------------------------------------*
 
gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m6_retall  

estimate stats  m6_retall
 
lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Return from Sweden                                                  
*------------------------------------------------------------------------------*
 
use "path to data \return_stset.dta", clear

keep if region_4cat1==1

gen event_return2=0
replace event_return2=1 if event_return==1 & region_4cat1==1  

stset ym_end, failure(event_return2) origin (time ym_origin) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_retsw

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1 , d(e) vce(cluster shnro)  hr
estimates store m3_retswf

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_retswm

estimate stats  m3_retsw

*------------------------------------------------------------------------------*
* Table 5 for return from Sweden                                                                       
*------------------------------------------------------------------------------*
 
gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m6_retsw  

estimate stats  m6_retsw

lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Return from other Nordics                                         
*------------------------------------------------------------------------------*
 
use "path to data \return_stset.dta", clear

keep if region_4cat1==2

gen event_return2=0
replace event_return2=1 if event_return==1 & region_4cat1==2  

stset ym_end, failure(event_return2) origin (time ym_origin) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_retnord

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1 , d(e) vce(cluster shnro)  hr
estimates store m3_retnordf

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_retnordm

estimate stats  m3_retnord

*------------------------------------------------------------------------------*
* Table 5 for return from other Nordics                                                                         
*------------------------------------------------------------------------------*
  
gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m6_retnord 

estimate stats  m6_retnord
 
lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
* Return from rest of the world                                         
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear

keep if  (region_4cat1==3 |  region_4cat1==4)

gen event_return2=0
replace event_return2=1 if event_return==1 &  (region_4cat1==3 |  region_4cat1==4)

stset ym_end, failure(event_return2) origin (time ym_origin) exit (time ym_exit) id(shnro)

********************
*splitting data 
stsplit time, at (0(12)180)
tab time, gen(t)
********************

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16, d(e) vce(cluster shnro)  hr
estimates store m3_retworld

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==1 , d(e) vce(cluster shnro)  hr
estimates store m3_retworldf

streg b1.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.age_cat i.educ_19 i.mkunta_a17 i.cohort t2-t16 if female==0, d(e) vce(cluster shnro)  hr
estimates store m3_retworldm

estimate stats  m3_retworld

*------------------------------------------------------------------------------*
* Table 5 for return from rest of the world                                                                        
*------------------------------------------------------------------------------*
 
gen back_pop=0
replace back_pop=1 if background==4 & dummy_sw_pop==0
replace back_pop=2 if background==4 & dummy_sw_pop==1
replace back_pop=3 if background==3 & dummy_sw_pop==0
replace back_pop=4 if background==3 & dummy_sw_pop==1

label def back_pop 1 "Fi-low" 2 "Fi-high" 3 "Sw-low" 4 "Sw-high", replace 
label values back_pop back_pop

streg i.dummy_sw_pop  b4.background i.dummy_sw_pop##b4.background i.educ_parents i.employed_parents i.quarinc_parents i.single_parent i.female  i.age_cat i.educ_19  i.mkunta_a17  i.cohort t2-t16 if (background==3 | background ==4) , d(e) vce(cluster shnro)  hr
estimates store m6_retworld  

estimate stats  m6_retworld

lincom 3.background + 1.dummy_sw_pop + 3.background#1.dummy_sw_pop,hr

*------------------------------------------------------------------------------*
*
*  Figures 
*
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Figure 1                                                  
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear  

set scheme plotplainblind 

coefplot (m1_all, label(No controls) keep(*.background) xscale(log range(1,5)) eform ///
			mcolor(turquoise) msymbol(circle) msize(medium) mfcolor(turquoise) ciopt(lcolor(turquoise))) ///
		(m2_all, label(Parental education) keep(*.background) xscale(log range(1,5))  eform /// 
			mcolor(plg2) msize(medium) msymbol(triangle) mfcolor(plg2) ciopt(lcolor(plg2))) ///
		(m3_all, label (Parental education & individual char.) keep(*.background) xscale(log range(1,5)) eform ///
			mcolor(plg3) msymbol(diamond) msize(medium) mfcolor(plg3) ciopt(lcolor(plg3)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6) row(3)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5) aspectratio(1) xline(1, lcolor(gs8))) 
			
graph save "path to figures \Figure1.gph", replace

*------------------------------------------------------------------------------*
* Figure 2                                                   
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear  

set scheme plotplainblind 

coefplot (m3_sw, label(Sweden) keep(*.background) xscale(log range(1,8)) eform ///
			mcolor(vermillion) msymbol(circle) msize(medium) mfcolor(vermillion) ciopt(lcolor(vermillion))) ///
		(m3_nord, label(other Nordics) keep(*.background) xscale(log range(1,8))  eform /// 
			mcolor(plr2) msize(medium) msymbol(triangle) mfcolor(plr2) ciopt(lcolor(plr2))) ///
		(m3_world, label (Rest of the World) keep(*.background) xscale(log range(1,8)) eform ///
			mcolor(pll1) msymbol(diamond) msize(medium) mfcolor(pll1) ciopt(lcolor(pll1)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(1 "1 " 2 "2" 4 "4" 6 "6" 8 "8",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6) rows(1)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  aspectratio(1) xline(1, lcolor(gs8)))
			
graph save "path to figures \Figure2.gph", replace

*------------------------------------------------------------------------------*
* Figure 3                                                                     *
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear 

set scheme plotplainblind

coefplot (m1_retall, label(No controls) keep(*.background) xscale(log range(.7,1)) eform ///
			mcolor(turquoise) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(turquoise))) ///
		(m2_retall, label(Parental education) keep(*.background) xscale(log range(.7,1))  eform /// 
			mcolor(plg2) msize(medium) msymbol(triangle) mfcolor(white) ciopt(lcolor(plg2))) ///
		(m3_retall, label (Parental education & individual char.) keep(*.background) xscale(log range(.65,1)) eform ///
			mcolor(plg3) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(plg3)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(0.65 "0.65" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6) rows(3)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  aspectratio(1) xline(1, lcolor(gs8))) 
	
graph save "path to figures \Figure3.gph", replace

*------------------------------------------------------------------------------*
* Figure 4                                           
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear 

set scheme plotplainblind

coefplot (m3_retsw, label(Sweden) keep(*.background) xscale(log range(0.5,1.2)) eform ///
			mcolor(vermillion) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(vermillion))) ///
			(m3_retnord, label(other Nordics) keep(*.background) xscale(log range(0.5,1.1))  eform /// 
			mcolor(plr2) msize(medium) msymbol(triangle) mfcolor(white) ciopt(lcolor(plr2))) ///
			(m3_retworld, label (Rest of the World) keep(*.background) xscale(log range(0.5,1.2)) eform ///
			mcolor(pll1) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(pll1)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(0.5 "0.5" 0.6 "0.6" 0.8 "0.8" 1 "1" 1.1 "1.1" ,labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6) rows(1)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5) aspectratio(1) xline(1, lcolor(gs8))) 
			
graph save "path to figures \Figure4.gph", replace

*------------------------------------------------------------------------------*
* Figure A1    
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear
 
set scheme plotplainblind

preserve
keep if background==1 
hist sw_pop_a17,title({bf:Finnish uniform background}) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6"  ,angle(horizontal)) ytitle("Proportion", size(small)) xtitle("Share Swedish speakers in municipality", size(small)) name(c1,replace) percent discrete color(sea)
restore

preserve
keep if background==2 
hist sw_pop_a17,title({bf:Swedish uniform background})ylabel(0 "0" 0.2 "0.2" 0.4 "0.4"  ,angle(horizontal)) ytitle("Proportion", size(small)) xtitle("Share Swedish speakers in municipality", size(small)) name(c2,replace) percent discrete color(plb1)
restore

preserve
keep if background==3 
hist sw_pop_a17,title({bf:Swedish mixed background}) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6"  ,angle(horizontal)) ytitle("Proportion",size(small)) xtitle("Share Swedish speakers in municipality",size(small)) name(c3,replace) percent discrete color(plr1)
restore

preserve
keep if background==4 
hist sw_pop_a17,title({bf:Finnish mixed background}) ylabel(0 "0" 0.2 "0.2" 0.4 "0.4" 0.6 "0.6"  ,angle(horizontal)) ytitle("Proportion",size(small)) xtitle("Share Swedish speakers in municipality",size(small)) name(c4,replace) percent discrete color(plr2)
restore

graph combine c1 c2 c3 c4, rows(4) iscale(1)  imargins(0 0 0 0) name(grc1leg, replace)
gr draw grc1leg, ysize(15) xsize(8)
graph save "path to figures \FigureA1.gph", replace

*------------------------------------------------------------------------------*
* Figure A2                                            
*------------------------------------------------------------------------------*

*migration 
use "path to data \swpop6_stset.dta", clear  

gen back_f=background if female==1 
	replace back_f=background+4 if female==0
 
sts graph, survival by(back_f) xlabel(0 "20" 60 "25" 120 "30" 180 "35" 240 "40" 300 "45" 360 "50" 420 "55" ,labsize(medsmall)) ylabel(1(0.25)0.75,labsize(medsmall)) xtitle(Age, size(medsmall)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(6)  legend(order(5 "Finnish uniform men" 8 "Finnish mixed men" 1 "Finnish uniform women" 4 "Finnish mixed women"  7 "Swedish mixed men" 6 "Swedish uniform men" 3 "Swedish mixed women"  2 "Swedish uniform women") size(medsmall) position(3)) title("") ///
	plot5opts(lcolor(turquoise) lpattern(solid)) ///
	plot8opts(lcolor(turquoise) lpattern(dash_dot)) ///
	plot1opts(lcolor(vermillion) lpattern(solid)) ///
	plot4opts(lcolor(vermillion) lpattern(dash_dot)) ///
	plot7opts(lcolor(turquoise) lpattern(dash)) ///
	plot6opts(lcolor(turquoise) lpattern(dot)) ///
	plot3opts(lcolor(vermillion) lpattern(dash)) ///
	plot2opts(lcolor(vermillion) lpattern(dot))

graph save "path to figures \FigureA2_migrationsurvival.gph", replace

sts graph, h nob by(back_f) xlabel(0 "20" 60 "25" 120 "30" 180 "35" 240 "40" 300 "45" 360 "50" 420 "55" ,labsize(medsmall)) ylabel(,labsize(medsmall)) xtitle(Age, size(small)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  legend(order(2 "Swedish uniform women" 3 "Swedish mixed women" 6 "Swedish uniform men" 7 "Swedish mixed men" 4 "Finnish mixed women" 1 "Finnish uniform women" 8 "Finnish mixed men" 5 "Finnish uniform men") size(medsmall) position(3))  title("") ///
	plot2opts(lcolor(vermillion) lpattern(dot)) ///
	plot3opts(lcolor(vermillion) lpattern(dash)) ///
	plot6opts(lcolor(turquoise) lpattern(dot)) ///
	plot7opts(lcolor(turquoise) lpattern(dash)) ///
	plot4opts(lcolor(vermillion) lpattern(dash_dot)) ///
	plot1opts(lcolor(vermillion) lpattern(solid)) ///
	plot8opts(lcolor(turquoise) lpattern(dash_dot)) ///
	plot5opts(lcolor(turquoise) lpattern(solid))
	
graph save "path to figures \FigureA2_migrationhazard.gph", replace

*return migration 
use "path to data \return_stset.dta", clear 

stset ym_end, failure(event_return) origin (time ym_origin) exit (time ym_exit) id(shnro)

gen back_f=background if female==1 
	replace back_f=background+4 if female==0

sts graph, h nob by(back_f) xlabel(0 "0" 24 "2" 48 "4" 72 "6" 96 "8" 120 "10" 144 "12" 168 "14" 192 "16" 216 "18" 240 "20" 264 "22" 288 "24" 312 "26" 336 "28" ,labsize(medsmall)) ylabel(0(0.01)0.02,labsize(medsmall)) xtitle(Years since first migration, size(medsmall)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(6)  legend(order(8 "Finnish mixed men" 5 "Finnish uniform men" 7 "Swedish mixed men" 6 "Swedish uniform men"  4 "Finnish mixed women"   3 "Swedish mixed women"  1 "Finnish uniform women" 2 "Swedish uniform women") size(medsmall) position(3)) title("") ///
	plot8opts(lcolor(turquoise) lpattern(dash_dot)) ///
	plot5opts(lcolor(turquoise) lpattern(solid)) ///
	plot7opts(lcolor(turquoise) lpattern(dash)) ///
	plot6opts(lcolor(turquoise) lpattern(dot)) ///
	plot4opts(lcolor(vermillion) lpattern(dash_dot)) ///
	plot3opts(lcolor(vermillion) lpattern(dash)) ///
	plot1opts(lcolor(vermillion) lpattern(solid)) ///
	plot2opts(lcolor(vermillion) lpattern(dot))

graph save "path to figures \FigureA2_returnhazard.gph", replace

sts graph, survival  by(back_f) xlabel(0 "0" 24 "2" 48 "4" 72 "6" 96 "8" 120 "10" 144 "12" 168 "14" 192 "16" 216 "18" 240 "20" 264 "22" 288 "24" 312 "26" 336 "28" 360 "30",labsize(small)) ylabel(,labsize(small)) xtitle(Years since first migration, size(small)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  legend(order(2 "Swedish uniform women" 3 "Swedish mixed women" 4 "Finnish mixed women" 1 "Finnish uniform women" 7 "Swedish mixed men"  6 "Swedish uniform men" 8 "Finnish mixed men" 5 "Finnish uniform men") size(small) position(3)) title("")  ///
	plot2opts(lcolor(vermillion) lpattern(dot)) ///
	plot3opts(lcolor(vermillion) lpattern(dash)) ///
	plot4opts(lcolor(vermillion) lpattern(dash_dot)) ///
	plot1opts(lcolor(vermillion) lpattern(solid)) ///
	plot7opts(lcolor(turquoise) lpattern(dash)) ///
	plot6opts(lcolor(turquoise) lpattern(dot)) ///
	plot8opts(lcolor(turquoise) lpattern(dash_dot)) ///
	plot5opts(lcolor(turquoise) lpattern(solid))

graph save "path to figures \FigureA2_returnsurvival.gph", replace

*------------------------------------------------------------------------------*
* Figure A3                                                         
*------------------------------------------------------------------------------*
 
use "path to data \swpop6_stset.dta", clear  

set scheme plotplainblind 

coefplot  (m1_female, label(No controls - Female) keep(*.background) xscale(log range(1,5)) eform ///
			mcolor(turquoise) msymbol(circle) msize(medium) mfcolor(turquoise) ciopt(lcolor(turquoise))) ///
			(m2_female, label(Parental education - Female) keep(*.background) xscale(log range(1,5))  eform ///
			msize(medium) mcolor(plg2) msymbol(triangle) mfcolor(plg2) ciopt(lcolor(plg2))) ///
			(m3_female, label (Parental education & individual char. - Female) keep(*.background) xscale(log range(1,5)) eform /// 
			mcolor(plg3) msymbol(diamond) msize(medium) mfcolor(plg3) ciopt(lcolor(plg3))) ///
			(m1_male, label(No controls - Male)  keep(*.background)  xscale(log range(1,5)) eform ///
			mcolor(turquoise%30) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(turquoise%30))) ///
			(m2_male, label(Parental education - Male ) keep(*.background)  xscale(log range(1,5))  eform /// 
			msize(medium) mcolor(plg2%30) msymbol(triangle) mfcolor(white) ciopt(lcolor(plg2%30))) ///
			(m3_male, label (Parental education & individual char. - male) keep(*.background) xscale(log range(1,5)) eform ///  
			mcolor(plg3%30) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(plg3%30)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(1 "1" 2 "2" 3 "3" 4 "4" 5 "5",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  aspectratio(1) xline(1, lcolor(gs8)) )
		
graph save "path to figures \FigureA3.gph", replace

*------------------------------------------------------------------------------*
* Figure A4                                                  
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear  

set scheme plotplainblind 

coefplot  (m3_sw_female, label(Sweden - Female) keep(*.background) xscale(log range(1,8)) eform ///
			mcolor(vermillion) msymbol(circle) msize(medium) mfcolor(vermillion) ciopt(lcolor(vermillion))) ///
			(m3_nord_female, label(other Nordics - Female) keep(*.background) xscale(log range(1,8))  eform ///
			msize(medium) mcolor(plr2) msymbol(triangle) mfcolor(plr2) ciopt(lcolor(plr2))) ///
			(m3_world_female, label (Rest of the World - Female) keep(*.background) xscale(log range(1,8)) eform /// 
			mcolor(pll1) msymbol(diamond) msize(medium) mfcolor(pll1) ciopt(lcolor(pll1))) ///
			(m3_sw_male, label(Sweden - Male)  keep(*.background)  xscale(log range(1,8)) eform ///
			mcolor(vermillion%30) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(vermillion%30))) ///
			(m3_nord_male, label(other Nordics - Male ) keep(*.background)  xscale(log range(1,8))  eform /// 
			msize(medium) mcolor(plr2%30) msymbol(triangle) mfcolor(white) ciopt(lcolor(plr2%30))) ///
			(m3_world_male, label (Rest of the World- Male) keep(*.background) xscale(log range(1,8)) eform ///  
			mcolor(pll1%30) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(pll1%30)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(1 "1 " 2 "2" 4 "4" 6 "6" 8 "8",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6)) plotregion(margin(medsmall)) graphregion(margin(zero))  ysize(4) xsize(5)  aspectratio(1) xline(1, lcolor(gs8)))
		
graph save "path to figures \FigureA4.gph", replace

*------------------------------------------------------------------------------*
* Figure A5
*------------------------------------------------------------------------------*
 
use "path to data \return_stset.dta", clear 

set scheme plotplainblind

coefplot  (m1_retfem, label(No controls - Female) keep(*.background) xscale(log range(.7,1)) eform ///
			mcolor(turquoise) msymbol(diamond) msize(medium) mfcolor(turquoise) ciopt(lcolor(turquoise))) ///
			(m2_retfem, label(Parental education - Female) keep(*.background) xscale(log range(.7,1))  eform ///
			msize(medium) mcolor(plg2) msymbol(triangle) mfcolor(plg2) ciopt(lcolor(plg2))) ///
			(m3_retfem, label (Parental education & individual char. - Female) keep(*.background) xscale(log range(.7,1)) eform /// 
			mcolor(plg3) msymbol(circle) msize(medium) mfcolor(plg3) ciopt(lcolor(plg3))) ///
			(m1_retmale, label(No controls - Male)  keep(*.background)  xscale(log range(.7,1)) eform ///
			mcolor(turquoise%30) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(turquoise%30))) ///
			(m2_retmale, label(Parental education - Male ) keep(*.background)  xscale(log range(.7,1))  eform /// 
			msize(medium) mcolor(plg2%30) msymbol(triangle) mfcolor(white) ciopt(lcolor(plg2%30))) ///
			(m3_retmale, label (Parental education & individual char. - male) keep(*.background) xscale(log range(0.65,1)) eform ///  
			mcolor(plg3%30) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(plg3%30)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(0.65 "0.65" 0.7 "0.7" 0.8 "0.8" 0.9 "0.9" 1 "1",labsize(medsmall) gmin gmax) /// 		
			ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6)) plotregion(margin(medsmall)) graphregion(margin(zero)) ysize(4) xsize(5)  aspectratio(1)  xline(1, lcolor(gs8)))
		
graph save "path to figures \FigureA5.gph", replace

*------------------------------------------------------------------------------*
* Figure A6                                                             
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear 

set scheme plotplainblind

coefplot  (m3_retswf, label(Sweden - Female) keep(*.background) xscale(log range(0.5,1.2)) eform ///
			mcolor(vermillion) msymbol(diamond) msize(medium) mfcolor(vermillion) ciopt(lcolor(vermillion))) ///
			(m3_retnordf, label(other Nordics - Female) keep(*.background) xscale(log range(0.5,1.2))  eform ///
			msize(medium) mcolor(plr2) msymbol(triangle) mfcolor(plr2) ciopt(lcolor(plr2))) ///
			(m3_retworldf, label (Rest of the World - Female) keep(*.background) xscale(log range(0.5,1.2)) eform /// 
			mcolor(pll1) msymbol(circle) msize(medium) mfcolor(pll1) ciopt(lcolor(pll1))) ///
			(m3_retswm, label(Sweden - Male)  keep(*.background)  xscale(log range(0.5,1.2)) eform ///
			mcolor(vermillion%30) msymbol(diamond) msize(medium) mfcolor(white) ciopt(lcolor(vermillion%30))) ///
			(m3_retnordm, label(other Nordics - Male ) keep(*.background)  xscale(log range(0.5,1.2))  eform /// 
			msize(medium) mcolor(plr2%30) msymbol(triangle) mfcolor(white) ciopt(lcolor(plr2%30))) ///
			(m3_retworldm, label (Rest of the World- Male) keep(*.background) xscale(log range(0.5,1.2)) eform ///  
			mcolor(pll1%30) msymbol(circle) msize(medium) mfcolor(white) ciopt(lcolor(pll1%30)) ///
			xtitle("Logged hazard ratios", size(medsmall)) xlabel(0.5 "0.5" 0.6 "0.6" 0.8 "0.8" 1 "1" 1.2 "1.2",labsize(medsmall) gmin gmax) ylabel(,labsize(medsmall) nogrid) ///
			legend(size(medsmall) position(6) cols(2)) plotregion(margin(medsmall)) graphregion(margin(zero))  ysize(4) xsize(5) aspectratio(1) xline(1, lcolor(gs8))) 
		
graph save "path to figures \FigureA6.gph", replace

*------------------------------------------------------------------------------*
* Figure A7 																	
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear  

set scheme plotplainblind 

label define mkunta_a17 1 "Greater Helsinki" 2 "Uusimaa" 3 "Southwest Finland" 5 "Satakunta" 6 "Kanta-Häme" 7 "Pirkanmaa" 8 "Päijät-Häme" 9 "Kymenlaakso" 10 "South Karelia" 11 "South Savo" 12 "North Savo" 13 "North Karelia" 14 "Central Finland" 15 "South Ostrobothnia" 16 "Ostrobothnia" 17 "Central Ostrobothnia" 18 "North Ostrobothnia" 19 "Kainuu" 20 "Lapland" 22 "Aland Islands" 23 "Ceded Areas" 200 "Abroad" 999 "Unknown",replace 
label values mkunta_a17 mkunta_a17

coefplot m4_all, keep(*.back2 *.educ_parents *.employed_parents *.quarinc_parents *.sinlge_parent *.female *.educ_19 *.cohort *.mkunta_a17) ///
	ylabel(,labsize(small)) headings(1.back2 = "{bf:Background}" 1.educ_parents = "{bf:Parental education}" 1.employed_parents = "{bf:Parental employment}" 1.quarinc_parents = "{bf:Parental income}" 0.female = "{bf:Individual characteristics}" 1.educ_19 = "{bf:Educational attainment}" 1.mkunta_a17 = "{bf:Region of residence}" 1.cohort = "{bf:Birth cohort}") ///
	msize(small) mcolor(turquoise) msymbol(circle) mfcolor(turquoise) ciopt(lcolor(turquoise)) ///
	xline(1, lcolor(gs8)) xscale(log range(0.5,5)) eform baselevels ///
	xlabel(.5 "0.5" 1 "1" 2 "2" 3 "3" 4 "4" 5 "5" ,labsize(small)) ///
	plotregion(margin(medsmall)) graphregion(margin(vsmall)) ///
	ysize(15) xsize(5) xline(1, lcolor(gs8))

graph save "path to data \FigureA7.gph", replace

*------------------------------------------------------------------------------*
* Figure A8                         
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear 

set scheme plotplainblind

label define mkunta_a17 1 "Greater Helsinki" 2 "Uusimaa" 3 "Southwest Finland" 5 "Satakunta" 6 "Kanta-Häme" 7 "Pirkanmaa" 8 "Päijät-Häme" 9 "Kymenlaakso" 10 "South Karelia" 11 "South Savo" 12 "North Savo" 13 "North Karelia" 14 "Central Finland" 15 "South Ostrobothnia" 16 "Ostrobothnia" 17 "Central Ostrobothnia" 18 "North Ostrobothnia" 19 "Kainuu" 20 "Lapland" 22 "Aland Islands" 23 "Ceded Areas" 200 "Abroad" 999 "Unknown",replace 
label values mkunta_a17 mkunta_a17

set scheme plotplainblind 
coefplot m4_retall, keep(*.back2 *.educ_parents *.employed_parents *.quarinc_parents *.sinlge_parent *.female *.educ_19 *.age_cat  *.cohort *.mkunta_a17) ///
	ylabel(,labsize(medsmall)) headings(1.back2 = "{bf:Background}" 1.educ_parents = "{bf:Parental education}" 1.employed_parents = "{bf:Parental employment}" 1.quarinc_parents = "{bf:Parental income}" 0.female = "{bf:Individual characteristics}" 1.educ_19 = "{bf:Educational attainment}" 1.age_cat = "{bf:Age at first mig}" 1.cohort = "{bf:Birth cohort}"  1.mkunta_a17 = "{bf:Region of residence}") ///
	msize(medsmall) mcolor(turquoise) msymbol(circle) mfcolor(white) ciopt(lcolor(turquoise)) ///
	xline(1, lcolor(gs8)) xscale(log range(0.5,1.5)) eform baselevels ///
	xlabel(0.5 "0.5" 1 "1" 1.2 "1.2" 1.5 "1.5" ,labsize(medsmall)) ///
	plotregion(margin(medsmall)) graphregion(margin(vsmall)) ///
	ysize(15) xsize(5)

graph save "path to data \FigureA8.gph", replace

*------------------------------------------------------------------------------*
*
* Descriptive statistics  
*
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Table 1                                                                      *
*------------------------------------------------------------------------------*

use "path to data \swpop6_stset.dta", clear
 
* Migrants 
tab background  if event==1 & _st==1 ,m  
tab educ_parents if event==1 & _st==1,m
tab employed_parents if event==1 & _st==1,m
tab quarinc_parents if event==1 & _st==1,m 
tab single_parent if event==1 & _st==1,m 
tab female if event==1 & _st==1,m 
tab educ_19 if event==1 & _st==1,m 
*Table A3 
tab  cohort if event==1 & _st==1,m
tab mkunta_a17 if event==1 & _st==1,m

*Nonmigrants 
tab background  if event==0 & _st==1 ,m 
tab educ_parents if event==0 & _st==1,m
tab employed_parents if event==0 & _st==1,m
tab quarinc_parents if event==0 & _st==1,m 
tab single_parent if event==0 & _st==1,m 
tab female if event==0 & _st==1,m 
tab educ_19 if event==0 & _st==1,m 
*Table A3 
tab  cohort if event==0 & _st==1,m 
tab mkunta_a17 if event==0 & _st==1,m

*Total 
tab background  if _st==1 ,m 
tab educ_parents if  _st==1,m
tab employed_parents if _st==1,m
tab quarinc_parents if  _st==1,m 
tab single_parent if _st==1,m 
tab female if _st==1,m 
tab educ_19 if _st==1,m 
*Table A3 
tab  cohort if _st==1,m 
tab mkunta_a17 if _st==1,m

*------------------------------------------------------------------------------*
* Table 2                                                                      *
*------------------------------------------------------------------------------*

use "path to data \return_stset.dta", clear 

stset ym_end, failure(event_return) origin (time ym_origin) exit (time ym_exit) id(shnro)

* Returnees 
tab background  if event==1 & _st==1 ,m 
tab educ_parents if event==1 & _st==1,m
tab employed_parents if event==1 & _st==1,m
tab quarinc_parents if event==1 & _st==1,m 
tab single_parent if event==1 & _st==1,m 
tab female if event==1 & _st==1,m 
tab educ_19 if event==1 & _st==1,m 
tab age_cat if  event==1 & _st==1,m
*Table A4
tab  cohort if event==1 & _st==1,m 
tab mkunta_a17 if event==1 & _st==1,m

* Nonreturnees 
tab background  if event==0 & _st==1 ,m 
tab educ_parents if event==0 & _st==1,m
tab employed_parents if event==0 & _st==1,m
tab quarinc_parents if event==0 & _st==1,m 
tab single_parent if event==0 & _st==1,m 
tab female if event==0 & _st==1,m 
tab educ_19 if event==0 & _st==1,m 
tab age_cat if  event==0 & _st==1,m
*Table A4
tab  cohort if event==0 & _st==1,m 
tab mkunta_a17 if event==0 & _st==1,m

* Total                                            
tab background  if _st==1 ,m 
tab educ_parents if  _st==1,m
tab employed_parents if _st==1,m
tab quarinc_parents if  _st==1,m 
tab single_parent if _st==1,m 
tab female if _st==1,m 
tab educ_19 if _st==1,m 
tab age_cat if   _st==1,m
*Table A4
tab  cohort if _st==1,m 
tab mkunta_a17 if _st==1,m

*------------------------------------------------------------------------------*
* Table 3                                                          
*------------------------------------------------------------------------------*

*Migration
use "path to data \swpop6_stset.dta", clear

gen reg=region_4cat1
replace reg=3 if region_4cat1==4 

tab background if event==1 & _st==1 ,m 
tab  reg background if event==1  & _st==1 ,m col row

*Return migration
use "path to data \return_stset.dta", clear 

stset ym_end, failure(event_return) origin (time ym_origin) exit (time ym_exit) id(shnro)

gen reg=region_4cat1
replace reg=3 if region_4cat1==4 

tab background if event==1 & _st==1 ,m 
tab  reg background if event==1  & _st==1 ,m col row 

*------------------------------------------------------------------------------*
* Table A1                                                           
*------------------------------------------------------------------------------*

*Migration
use "path to data \swpop6_stset.dta", clear

tab event background  if _st==1 ,m col
tab educ_parents background if  _st==1,m col
tab employed_parents background if _st==1,m col
tab quarinc_parents background if  _st==1,m col
tab single_parent background if _st==1,m col
tab female background if _st==1,m col
tab educ_19 background if _st==1,m col
tab  cohort background if _st==1,m col
tab mkunta_a17 background if _st==1,m col

*Return migration
use "path to data \return_stset.dta", clear 

stset ym_end, failure(event_return) origin (time ym_origin) exit (time ym_exit) id(shnro)

tab event background if  _st==1 ,m col

*end do file*
