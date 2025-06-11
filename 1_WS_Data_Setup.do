
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
*	 DATA CLEANING AND SETUP                                                   * 
*																			   *
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

use "path to data \muutot_s_2020.dta", clear
destring _all, replace 
 
*------------------------------------------------------------------------------*
* Migration date        			     									   *
*------------------------------------------------------------------------------*

rename muuttopvm mig_date
gen migmonth=month(mig_date)
gen migyear=year(mig_date)
gen migday=day(mig_date)

*------------------------------------------------------------------------------*
* Indicator variable for immigration and emigration     			    	   *
*------------------------------------------------------------------------------*

gen mig_indicator=0
replace mig_indicator=1 if muuttolaji==41
label define ind 0 "emig (from fin)" 1 "immig (to fin)", replace 
label values mig_indicator ind

gen country_movefrom=lahtomaakoodi
destring country_movefrom, replace 

gen country_moveto=tulomaakoodi
destring country_moveto, replace 

*------------------------------------------------------------------------------*
* Country and region of destination        			    					   *
*------------------------------------------------------------------------------*

gen country=0
replace country=country_moveto if mig_indicator==0

gen countryh=0
replace countryh=country_movefrom if mig_indicator==1
replace country=country_movefrom if mig_indicator==1
label values country country 
replace country=999 if country==0

label define country 0 "miss" 4 "Afghanistan" 8 "Albania" 12 "Algeria" 16 "American Samoa"  20 "Andorra" 24 "Angola" 660 "Anguilla" 10 "Antarctica" 28 "Antigua and Barbuda"32 "Argentina"  51 "Armenia" 533 "Aruba" 36 "Australia"  40 "Austria"  31 "Azerbajan" 44 "Bahamas" 48 "Bahrain" 50 "Bangladesh" 52 "Barbados" 112 "Belarus"  56 "Belgium"   84 "Belize" 204 "Benin"  60 "Bermuda" 64 "Bhutan" 68 "Bolivia" 535 "Bonaire, Sint Eustatis and Saba" 70 "Bosnia and Herzegovina" 72 "Botswana" 74 "Bouvet Island"  76 "Brazil" 86 "British Indian Ocean Territory" 96 "Brunei Darussalam" 100 "Bulgaria" 845 "Burkina Faso" 108 "Burundi" 116 "Cambodia" 120 "Cameroon" 124 "Canada" 132 "Cabo Verde" 136 "Cayman Islands" 140 "Central African Republic" 148 "Chad" 152 "Chile" 156 "China" 162 "Christmas Island" 166 "Cocos (Keeling) Island" 170 "Colombia" 174 "Comoros" 178 "Congo (Congo-Brazzaville)" 180 "Congo (Congo-Kinshasa)" 184 "Cook Islands" 188 "Costa Rica" 384 "Cote d'Ivoire" 191 "Croatia"  192 "Cuba" 531 "Curacao" 196 "Cyprus" 203 "Czechia" 208 "Denmark" 262 "Djibouti" 212 "Dominica" 214 "Dominican Republic"  626 "East Timor" 218 "Ecuador" 818 "Egypt" 222 "El Salvador" 226 "Equatorial Guinea" 232 "Eritrea" 233 "Estonia" 231 "Ethiopia" 238 "Falkland Islands (Malvinas)" 234 "Faroe Islands" 242 "Fiji" 246 "Finland" 250 "France" 254 "French Guinea" 258 "French Polynesia" 260 "French Southern territories" 266 "Gabon" 270 "Gambia" 268 "Georgia" 276 "Germany" 288 "Ghana" 292 "Gibraltar" 300 "Greece"  304 "Greenland" 308 "Grenada" 312 "Guadaeloupe" 316 "Guam" 320 "Guatelmala" 831 "Guernsey" 324 "Guinea" 624 "Guinea-Bissau" 328 "Guyana" 332 "Haiti" 334 "Heard Island and McDonald Islands" 336 "Holy See (Vatican City State)" 340 "Honduras" 344 "Hong Kong" 348 "Hungary"  352  "Iceland" 356  "India" 360 "Indonesia" 360 "Iran, Islamic Republic" 368 "Iraq" 372 "Ireland" 833 "Isle of Man" 376  "Israel" 380 "Italy" 388 "Jamaica"  392 "Japan" 832 "Jersey" 400 "Jordan" 398 "Kazakstan" 404 "Kenya" 296 "Kiribati" 408 "Korea (north korea)" 410 "Korea (south korea)" 414 "Kuwait" 417 "Kyrgyzstan" 418 "Lao People's Democratic Republic" 418 "Latvia" 422 "Lebanon" 426 "Lesotho" 430 "Liberia" 434 "Libyan Arab Jamahiriya" 438 "Liechtenstein" 440 "Lithuania" 442 "Luxemburg" 446 "Macau" 807 "North Macedonia" 450 "Madagascar" 454 "Malawi" 458 "Malaysia" 462 "Maldives" 466 "Mali" 470 "Malta" 584 "Mashall Islands" 474 "Martinique" 478 "Mauritania" 480 "Mauritius" 175 "Mayotte" 484 "Mexico" 583 "Micronesia, Federated States of" 498 "Moldova" 492 "Monaco" 496 "Mongolia" 499 "Montenegro" 500 "Montserrat" 504 "Morocco" 508 "Mozambique" 104 "Myanmar" 516 "Namibia" 520 "Nauru" 524 "Nepal" 528 "Netherlands" 540 "New Caledonia" 554 "New Zealand" 558 "Nicaragua" 562 "Niger" 566 "Nigeria" 570 "Niue" 574 "Norfolk Island" 580 "Northern Mariana Islands" 578 "Norway" 512 "Oman" 586 "Pakistan" 585 "Palau" 275 "Palestine" 591 "Panama" 598 "Papua New Guinea" 600 "Paraguay" 604 "Peru" 608 "Philippines" 612 "Pitcairn" 616 "Poland"   620 "Portugal"  630 "Puerto Rico" 634 "Qatar" 638 "Reunion" 642 "Romania" 643 "Russian Federation" 646 "Rwanda" 652 "Saint Bathelemy" 654 "Saint Helena, Ascension and Tristan da Cunha" 659 "Saint Kitts and Nevis" 662 "Saint Lucia" 663 "Saint Martin" 666 "Saint Pierre and Miquelon" 670 "Saint Vincent and the Grenadines" 882 "Samoa" 674 "San Marino" 678 "Sao Tome and Principe" 682 "Saudi Arabia" 686 "Senegal" 688 "Serbia" 690 "Seychelles" 694 "Sierra Leone" 702 " Singapore" 534 "Sint maaten (Dutch Part)" 704 "Slovakia" 705 "Slovenia" 90 "Solomon Islands" 706 "Somalia" 710 "South Africa" 239 "South Georgia and the South Sandwich Islands" 728 "South Sudan" 724 "Spain" 144 "Sri Lanka" 729 "Sudan" 740 "Suriname" 744 "Svalbard and Jan Mayen" 748 "Swaziland" 752 "Sweden"  756 "Switzerland"  760 "Syrian Arab Republic"  158 "Taiwan" 762 "Tajikistan" 834 "Tanzania" 764 "Thailand"   768 "Togo" 772 "Tokelau" 776 "Tonga" 780 "Trinidad and Tobago" 788 "Tunesia"  792 "Turkey" 795 "Turkmenistan" 796 "Turks and Caicos Islands" 798 "Tuvalu" 800 "Uganda" 804 "Ukraine" 784 "United Arab Emirates" 826 "United Kingdom" 840 "United States" 581 "United States Minor Outlying Islands" 858 "Uruguay" 860 "Uzbekistan" 876 "Wallis and Futuna" 548 "Vanuatu" 862 "Venezuela" 732 "Western Sahara"  704 "Vietnam" 92 "Virgin Islands, British" 850 "Virgin Islands, U.S." 887 "Yemen" 894 "Zambia" 716 "Zimbabwe" 248 "Aland Islands" 999 "missing", replace 
label values country country

gen region=0
replace region=1 if country==246 
replace region=2 if country==643 
replace region=3 if country==233 
replace region=4 if country==752 | country==248 
replace region=5 if country==208 | country==352 | country==578 | country==234 | country==304 
replace region=6 if country==70 | country==191 | country==807 | country==499 | country==688 | country==705 
replace region=7 if country==112 | country==51 | country==804 | country==100 | country==203 | country==348 | country==268 | country==398 | country==417 | country==498 | country==616  | country==642 | country==704 | country==762 | country==795 | country==860 | country==804 
replace region=8 if country==12 | country==232 | country==231 | country==504 | country==706 | country==788 
replace region=9 if country==404 | country==566 | country==562| country==686 
replace region=10 if country==660 | country==32 | country==84 | country==76 | country==152 | country==170 | country==188 | country==218 | country==222 | country==320 | country==340 | country==591 | country==484 | country==600  | country==604 | country==630 
replace region=11 if country==36 | country==124 | country==840 | country==554 
replace region=12 if country==40 | country==56 | country==250 | country==276 | country==300 | country==336 | country==528 | country== 724 | country== 756 | country==620 | country==380 | country==440 | country==442 | country==438 
replace region=13 if country==156 | country==344 | country==524 | country==764 | country==356 | country== 392 | country== 408 | country==410
replace region=14 if country==364 | country==368 | country==4 | country==376 | country==400 | country==422 | country==204 | country==586 | country==275 | country==634 | country==682 | country==760 | country==887 | country==792 
replace region=999 if country==999 

label define region 0 "Not yet coded" 1 "Finland" 2 "Russia" 3 "Estonia" 4 "Sweden" 5 "Other Nordics" 6 "Ex-Yugoslavia" 7 "Soviet (satelite)" 8 "North Africa" 9 "Other Africa" 10 "Latin America" 11 "Australia, US" 12 "Europe" 13 "Asia" 14 "Middle East" 999 "missing", replace 
label values region region

*------------------------------------------------------------------------------*
* Region focusing on four categories 
*------------------------------------------------------------------------------*

recode region (1=0) (4=1) (5=2) (0 2 6 7 8 9 10 11 12 13 14 999=3) (3=4) , into (region_4cat)
label define region_4cat  0 "Finland" 1 "Sweden" 2 "Other Nordics" 3 "Rest of the World" 4 "Estonia", replace 
label values region_4cat region_4cat

save "path to data \migration.dta", replace

*------------------------------------------------------------------------------*
*																			   *
* Migrations per person    										               *
*																			   *
*------------------------------------------------------------------------------*

use "path to data \migration.dta, clear

drop countryh muuttolaji lahtomaakoodi tulomaakoodi country_movefrom country_moveto  
destring _all, replace 

bysort shnro migyear migmonth migday: gen index=_n
bysort shnro migyear migmonth migday: gen mindex=_N

********************************************************************************
gen ind_multmoves_day=0
replace ind_multmoves_day=1 if mindex>1 
********************************************************************************

drop if index==1 & mindex==2 

*------------------------------------------------------------------------------*
* Multiple moves in a month                                                    *
*------------------------------------------------------------------------------*

sort shnro migyear migmonth migday
bysort shnro: gen indicator=_n
bysort shnro: gen tot_moves=_N

gen migyear1=migyear if indicator==1 
gen migyear2=migyear if indicator==2 & tot_moves>1 

gen mig_indicator1=mig_indicator if indicator==1 
gen mig_indicator2=mig_indicator if indicator==2 & tot_moves>1 

gen migmonth1=migmonth if indicator==1 
gen migmonth2=migmonth if indicator==2 & tot_moves>1 

gen migday1=migday if indicator==1 
gen migday2=migday if indicator==2 & tot_moves>1 

gen country1=country if indicator==1 
gen country2=country if indicator==2 & tot_moves>1 

gen region1=region if indicator==1 
gen region2=region if indicator==2 & tot_moves>1 

gen region_4cat1=region_4cat if indicator==1 
gen region_4cat2=region_4cat if indicator==2 & tot_moves>1 

********************************************************************************

replace mig_indicator1=0 if mig_indicator1==. 
bysort shnro: egen mig_ind1=max(mig_indicator1)
replace mig_indicator2=0 if mig_indicator2==. 
bysort shnro: egen mig_ind2=max(mig_indicator2)

replace migyear1=0 if migyear1==. 
bysort shnro: egen migy1=max(migyear1)
replace migyear2=0 if migyear2==. 
bysort shnro: egen migy2=max(migyear2)

sort shnro migyear migmonth migday

********************************************************************************
gen indicator_dir=0
replace indicator_dir=1 if mig_ind2==0 & mig_ind1==0 & indicator==2 & migy1>1986
bysort shnro: egen ind_dir=max(indicator_dir)
********************************************************************************

replace migmonth1=0 if migmonth1==. 
bysort shnro: egen migm1=max(migmonth1)
replace migmonth2=0 if migmonth2==. 
bysort shnro: egen migm2=max(migmonth2)

*********************************************************************************
gen ind_multmoves_month=0
replace ind_multmoves_month=1 if migm2==migm1 & migy2==migy1 & mig_ind1==0 & indicator==2 & migy1>1986
bysort shnro: egen ind_m_month=max(ind_multmoves_month)
********************************************************************************

replace migday1=0 if migday1==. 
bysort shnro: egen migd1=max(migday1)
replace migday2=0 if migday2==. 
bysort shnro: egen migd2=max(migday2)

replace country1=0 if country1==. 
bysort shnro: egen c1=max(country1)
replace country2=0 if country2==. 
bysort shnro: egen c2=max(country2)

replace region1=0 if region1==. 
bysort shnro: egen r1=max(region1)
replace region2=0 if region2==. 
bysort shnro: egen r2=max(region2)

replace region_4cat1=0 if region_4cat1==. 
bysort shnro: egen r_4c1=max(region_4cat1)
replace region_4cat2=0 if region_4cat2==. 
bysort shnro: egen r_4c2=max(region_4cat2)

********************************************************************************

drop migyear1 migyear2 migmonth1 migmonth2 mig_indicator1 mig_indicator2 migday1 migday2 country1 country2 region1 region2 region_4cat1 region_4cat2 indicator_dir ind_multmoves_month

rename migy1 migyear1
rename migy2 migyear2
rename migm1 migmonth1 
rename migm2 migmonth2
rename mig_ind1 mig_indicator1 
rename mig_ind2 mig_indicator2 
rename migd1 migday1
rename migd2 migday2 
rename r1 region1
rename r2 region2
rename c1 country1
rename c2 country2
rename r_4c1 region_4cat1
rename r_4c2 region_4cat2
rename ind_dir indicator_dir
rename ind_m_month ind_multmoves_month

drop index mindex 
bysort shnro: gen index=_n
bysort shnro: gen mindex=_N
********************************************************************************
keep if index==1 
********************************************************************************

drop indicator tot_moves migyear migmonth migday mig_indicator country region region_4cat mig_date

sort shnro
 
save "path to data \migration_masterfile_wide.dta", replace 

*------------------------------------------------------------------------------*
*																		       *
* Merging files                                                          	   *
*																		       *
*------------------------------------------------------------------------------*

use "path to data \syntyma_kuolema.dta", clear

drop tpks m1 m2 m3 m4 m5 
destring _all, replace 
sort shnro
rename syntyv byear
rename syntykk bmonth
rename kuolv dyear
rename kuolkk dmonth 

save "path to data \syntyma_kuolema_masterfile.dta", replace 

import sas using "path to data \lapsi_suhde_s_uusi_al3.sas7bdat.dta", clear 

drop  aidinisan_* isanisan_* isanaidin_* aidinaidin_*

gen info_mom=0
replace info_mom=1 if aidin_shnro!=""
gen info_dad=0
replace info_dad=1 if isan_shnro!=""

gen info_mom_dad=0
replace info_mom_dad=1 if info_mom==1 
replace info_mom_dad=1 if info_dad==1 

drop suhde_aiti suhde_isa
sort shnro
save "path to data \lapsi_suhde_1.dta", replace 

use "path to data \syntyma_kuolema_masterfile.dta", clear 
merge 1:1 shnro using "path to data \lapsi_suhde_1.dta" 
drop _m
save "path to data \masterfile_parents.dta", replace 

use "path to data \masterfile_parents.dta", clear 
merge 1:1 shnro using "path to data \migration_masterfile_wide.dta" 
drop _m 
save "path to data \masterfile_parents_mig.dta", replace 

use "path to data \folkperus_all_19872020.dta", clear 

rename yotutk matric_exam
rename ututku_aste educ_level 
rename ututku_al educ_field
rename klaji_k2 educ_type
rename suorv year_finish_educ
rename ptoim1 employm_status
rename ammattikoodi_k occupation
rename pety family_type
rename palk_k wages_salaries
rename tyotu_k total_earned_inc
rename tyrtuo_k entrepeneurial_inc

gen female=0 
replace female=1 if sukup=="2"

gen age= vuosi-syntyv

rename vuosi statistical_year 
rename syntyv byear 
rename kuolv dyear 

save "path to data \folkperus_all_19872020_info.dta", replace  

use "path to data \folkperus_all_19872020_info.dta", clear 

drop smkunta skunta svaltio_k kansa1_k syntyp2 ika kuntaryhm kunta31_12 kuntaryhm31_12 maka taajama_k2 /*
*/ amas1 optuki tyke tyokk akoko_k asty hape hulu taty vata penulaika *lkm_k pekoko_k vela tkela tyela mela osela pela /*
*/ yvela kturaha_k velaty_k lvar_k svatva_k auto_k

*------------------------------------------------------------------------------*
* Municipality at age 17                                 	   
*------------------------------------------------------------------------------*

destring kunta, replace 
gen e_kunta_a17=kunta if age==17
bysort shnro: egen kunta_a17=max(e_kunta_a17)
drop e_kunta_a17

label define kunta_at_age_17 001 "Ahlainen" 002 "Aitolahti" 003	"Akaa" 020 "Akaa" 004 "Alahärmä" 005	"Alajärvi" 006 "Alastaro" 007 "Alatornio" 008 "Alaveteli" 009 "Alavieska" 010 "Alavus" 011 "Angelniemi" 012"Anjala" 754	"Anjalankoski" 013 "Antrea" 014	"Anttola" 015 "Artjärvi" 016 "Asikkala" 017	"Askainen" 018"Askola" 019 "Aura" 032 "Bergö" 033 "Björköby" 034 "Bromarv" 035 "Brändö" 039	"Degerby" 040 "Dragsfjärd" 043"Eckerö" 044 "Elimäki" 045 "Eno" 046 "Enonkoski" 047 "Enontekiö" 048 "Eräjärvi" 049 "Espoo" 050 "Eura" 051"Eurajoki" 052 "Evijärvi" 060 "Finström" 061 "Forssa" 062 "Föglö" 065 "Geta" 068 "Haaga" 069 "Haapajärvi" 070 "Haapasaari" 071 "Haapavesi" 072 "Hailuoto" 073 "Halikko" 074	"Halsua" 075 "Hamina" 076 "Hammarland" 077"Hankasalmi" 078 "Hanko" 079	"Harjavalta" 080 "Harlu" 081 "Hartola" 082 "Hattula" 083 "Hauho" 084 "Haukipudas" 085 "Haukivuori" 086 "Hausjärvi" 087 "Heinjoki" 088 "Heinola" 111	"Heinola" 089 "Heinolan mlk" 090 "Heinävesi" 091 "Helsinki" 093	"Hiitola" 094 "Hiittinen" 095 "Himanka" 096	"Hinnerjoki" 097 "Hirvensalmi" 098 "Hollola" 099 "Honkajoki" 100 "Honkilahti" 101 "Houtskari" 102 "Huittinen" 103 "Humppila" 104	"Huopalahti" 105 "Hyrynsalmi" 106 "Hyvinkää" 107 "Hyvinkään mlk" 283 "Hämeenkoski" 108 "Hämeenkyrö" 109 "Hämeenlinna" 110 "Hämeenlinnan mlk" 139 "Ii" 140 "Iisalmi" 141	"Iisalmen mlk" 142 "Iitti" 144 "Ikaalinen" 143"Ikaalinen" 145 "Ilmajoki" 146 "Ilomantsi" 153 "Imatra" 147 "Impilahti" 148 "Inari" 150 "Iniö" 149 "Inkoo" 151 "Isojoki" 152 "Isokyrö" 162 "Jaakkima" 163	"Jaala" 164	"Jalasjärvi" 165 "Janakkala" 166 "Jepua" 167 "Joensuu"168 "Johannes" 169 "Jokioinen" 170 "Jomala" 171 "Joroinen" 172 "Joutsa" 173 "Joutseno" 174 "Juankoski" 175 "Jurva" 176 "Juuka" 177 "Juupajoki" 178 "Juva" 179	"Jyväskylä" 180	"Jyväskylän mlk" 181 "Jämijärvi" 182 "Jämsä" 183 "Jämsänkoski" 184 "Jäppilä" 186 "Järvenpää" 185 "Jääski" 202 "Kaarina" 203	"Kaarlela" 204	"Kaavi"205 "Kajaani" 206 "Kajaanin mlk" 207	"Kakskerta" 208	"Kalajoki" 209 "Kalanti" 210 "Kalvola" 211 "Kangasala" 212 "Kangaslampi" 213 "Kangasniemi" 214 "Kankaanpää" 215 "Kanneljärvi" 216 "Kannonkoski" 217 "Kannus" 201 "Karhula" 218 "Karijoki" 219 "Karinainen" 220 "Karjaa" 221 "Karjaan mlk" 222 "Karjala" 223 "Karjalohja" 224 "Karkkila" 225 "Karkku" 226 "Karstula" 227 "Karttula" 228 "Karuna" 229 "Karunki" 230 "Karvia" 231 "Kaskinen" 232 "Kauhajoki" 233 "Kauhava" 234 "Kaukola" 235 "Kauniainen" 236 "Kaustinen" 237 "Kauvatsa" 238 "Keikyä" 239 "Keitele" 240 "Kemi" 242 "Kemijärven mlk" 320 "Kemijärvi" 241 "Keminmaa" 243 "Kemiö" 322 "Kemiönsaari" 244 "Kempele" 245	"Kerava" 246 "Kerimäki" 247	"Kestilä" 248 "Kesälahti" 249 "Keuruu" 250 "Kihniö" 251	"Kiihtelysvaara" 252 "Kiikala" 253 "Kiikka" 254	"Kiikoinen" 255	"Kiiminki" 256 "Kinnula" 257 "Kirkkonummi" 258 "Kirvu" 259 "Kisko" 260 "Kitee" 261 "Kittilä" 262 "Kiukainen" 263 "Kiuruvesi" 264 "Kivennapa" 265 "Kivijärvi" 266 "Kodisjoki" 267 "Koijärvi" 268 "Koivisto" 269 "Koiviston mlk" 270	"Koivulahti" 271 "Kokemäki"272 "Kokkola" 273 "Kolari" 274 "Konginkangas" 275 "Konnevesi" 276 "Kontiolahti" 277 "Korpilahti" 278 "Korpiselkä" 279 "Korppoo" 280 "Korsnäs" 281 "Kortesjärvi" 282 "Koskenpää" 284 "Koski Tl" 285"Kotka" 286 "Kouvola" 287 "Kristiinankaupunki" 288	"Kruunupyy" 289	"Kuhmalahti" 290 "Kuhmo" 291 "Kuhmoinen" 292 "Kuivaniemi" 293 "Kullaa" 294 "Kulosaaren huvilak." 295 "Kumlinge" 296	"Kuolemajärvi" 297 "Kuopio" 298	"Kuopion mlk" 299 "Kuorevesi" 300 "Kuortane" 301 "Kurikka" 302 "Kurkijoki" 303 "Kuru" 304 "Kustavi" 305	"Kuusamo" 306	"Kuusankoski" 307 "Kuusisto" 308 "Kuusjoki" 310	"Kylmäkoski" 311 "Kymi" 312	"Kyyjärvi" 321 "Kyyrölä" 313	"Käkisalmi" 314	"Käkisalmen mlk" 315 "Kälviä" 316 "Kärkölä" 317	"Kärsämäki" 318	"Kökar" 319	"Köyliö" 397	"Lahdenpohja" 398 "Lahti" 399 "Laihia" 400 "Laitila" 401 "Lammi" 407 "Lapinjärvi" 402 "Lapinlahti" 403	"Lappajärvi" 404 "Lappee" 405 "Lappeenranta" 406 "Lappi" 408 "Lapua" 409 "Lapväärtti" 410 "Laukaa" 411	"Lauritsala" 412 "Lavansaari" 413 "Lavia" 414 "Lehtimäki" 415 "Leivonmäki" 416 "Lemi" 417 "Lemland" 418	"Lempäälä" 419 "Lemu" 420 "Leppävirta" 421 "Lestijärvi" 422 "Lieksa" 423 "Lieto" 424 "Liljendal" 425	"Liminka" 426 "Liperi" 427 "Lohja" 444 "Lohja" 428 "Lohjan kunta" 429 "Lohtaja" 430	"Loimaa" 431 "Loimaan kunta"432	"Lokalahti" 433	"Loppi" 434	"Loviisa" 435 "Luhanka" 436	"Lumijoki" 437 "Lumivaara" 438 "Lumparland" 439"Luopioinen" 440	"Luoto" 441	"Luumäki" 442 "Luvia" 443 "Längelmäki" 445 "Länsi-Turunmaa" 475	"Maalahti" 476	"Maaninka" 477 "Maaria" 478	"Maarianhamina - Mariehamn" 479	"Maksamaa" 480 "Marttila" 481 "Masku" 482 "Mellilä"483 "Merijärvi" 484 "Merikarvia" 485	"Merimasku" 486	"Messukylä" 487	"Metsämaa" 488 "Metsäpirtti" 489	"Miehikkälä" 490 "Mietoinen" 491 "Mikkeli" 492 "Mikkelin mlk" 493 "Mouhijärvi" 494 "Muhos" 495 "Multia" 496	"Munsala" 497 "Muolaa" 498 "Muonio" 499	"Mustasaari" 500 "Muurame" 501 "Muurla" 502	"Muuruvesi" 503	"Mynämäki"504 "Myrskylä" 505 "Mäntsälä" 506	"Mänttä" 508 "Mänttä-Vilppula" 507 "Mäntyharju" 529	"Naantali" 530 "Naantalin mlk" 531 "Nakkila" 532 "Nastola" 533 "Nauvo" 534 "Nilsiä" 535	"Nivala" 536 "Nokia" 537 "Noormarkku" 538 "Nousiainen" 539 "Nuijamaa" 540 "Nummi-Pusula" 542 "Nurmeksen mlk" 541 "Nurmes" 543 "Nurmijärvi" 544 "Nurmo"545 "Närpiö" 559 "Oravainen" 560 "Orimattila" 561 "Oripää" 562 "Orivesi" 563 "Oulainen" 564 "Oulu" 565 "Oulujoki"566 "Oulunkylä" 567 "Oulunsalo" 309 "Outokumpu" 574 "Paattinen" 575 "Paavola" 576 "Padasjoki" 577 "Paimio" 578	"Paltamo" 573 "Parainen" 579 "Paraisten mlk" 580 "Parikkala" 581 "Parkano" 582 "Pattijoki" 599 "Pedersören kunta" 583 "Pelkosenniemi" 854 "Pello" 584 "Perho" 585 "Pernaja" 586	"Perniö" 587 "Pertteli" 588	"Pertunmaa" 589"Peräseinäjoki" 590 "Petolahti" 591 "Petsamo" 592 "Petäjävesi" 594 "Pieksämäen mlk" 593 "Pieksämäki" 640"Pieksänmaa" 595	"Pielavesi" 596	"Pielisensuu" 597 "Pielisjärvi" 598	"Pietarsaari" 600 "Pihlajavesi" 601	"Pihtipudas" 602 "Piikkiö" 603 "Piippola" 604 "Pirkkala" 994 "Pirkkala" 605	"Pirttikylä" 606 "Pohja" 637"Pohjaslahti" 607 "Polvijärvi" 608 "Pomarkku" 609 "Pori" 610 "Porin mlk" 611 "Pornainen" 612 "Porvoo" 638"Porvoo" 613 "Porvoon mlk" 614	"Posio" 615	"Pudasjärvi" 616 "Pukkila" 617 "Pulkkila" 618 "Punkaharju" 619"Punkalaidun" 620	"Puolanka" 621 "Purmo" 622 "Pusula" 623	"Puumala" 624 "Pyhtää" 625 "Pyhäjoki" 627	"Pyhäjärvi Ul" 628 "Pyhäjärvi Vi" 629 "Pyhämaa" 630	"Pyhäntä" 631 "Pyhäranta" 626 "Pyhäjärvi" 632 "Pyhäselkä"633 "Pylkönmäki" 634 "Pälkjärvi" 635 "Pälkäne" 636	"Pöytyä" 678 "Raahe" 710 "Raasepori" 679 "Raippaluoto" 680"Raisio" 681 "Rantasalmi" 682	"Rantsila" 683 "Ranua" 684 "Rauma" 685 "Rauman mlk" 686	"Rautalampi" 687	"Rautavaara" 688 "Rautio" 689 "Rautjärvi" 690 "Rautu" 691 "Reisjärvi" 692 "Renko" 693 "Revonlahti" 694	"Riihimäki" 695	"Riistavesi" 696 "Ristiina" 697	"Ristijärvi" 699 "Rovaniemen mlk" 698 "Rovaniemi" 700	"Ruokolahti" 701 "Ruotsinpyhtää" 702 "Ruovesi" 703 "Ruskeala" 704 "Rusko" 708 "Ruukki" 705 "Rymättylä" 706	"Räisälä" 707 "Rääkkylä" 728 "Saari" 729 "Saarijärvi" 730 "Sahalahti" 731 "Sakkola" 732	"Salla" 733 "Salmi" 734	"Salo" 735 "Saloinen" 736 "Saltvik" 737	"Sammatti" 790 "Sastamala" 738 "Sauvo" 739 "Savitaipale" 740	"Savonlinna" 741 "Savonranta" 742 "Savukoski" 743 "Seinäjoki" 744 "Seinäjoen mlk" 745 "Seiskari" 746 "Sievi" 747 "Siikainen" 748 "Siikajoki" 791 "Siikalatva" 749 "Siilinjärvi" 750	"Siipyy" 751 "Simo" 752	"Simpele" 753	"Sipoo" 755	"Siuntio" 756 "Snappertuna" 757	"Soanlahti" 758	"Sodankylä" 759	"Soini" 760	"Somerniemi" 761 "Somero" 762 "Sonkajärvi" 763 "Sortavala" 764 "Sortavalan mlk" 765	"Sotkamo" 766 "Sottunga" 767 "Suistamo" 768"Sulkava" 769 "Sulva" 770 "Sumiainen" 771 "Sund" 772	"Suodenniemi" 773 "Suojärvi" 774 "Suolahti" 775"Suomenniemi" 776 "Suomusjärvi" 777 "Suomussalmi" 778 "Suonenjoki" 779 "Suoniemi" 780 "Suursaari" 781 "Sysmä" 782 "Säkkijärvi" 783 "Säkylä" 784 "Särkisalo" 786 "Säyneinen" 787 "Säynätsalo" 788	"Sääksmäki" 789	"Sääminki"831 "Taipalsaari" 832	"Taivalkoski" 833 "Taivassalo" 834 "Tammela" 836 "Tammisaaren mlk" 835 "Tammisaari" 837"Tampere" 838 "Tarvasjoki" 839 "Teerijärvi" 840 "Teisko" 841 "Temmes" 842 "Tenhola" 843 "Terijoki" 844 "Tervo"845 "Tervola" 846	"Teuva" 847	"Tiukka" 848 "Tohmajärvi" 849 "Toholampi" 864 "Toijala" 850	"Toivakka" 851	"Tornio" 852 "Tottijärvi" 853 "Turku" 855 "Tuulos" 856 "Tuupovaara" 857	"Tuusniemi" 858 "Tuusula" 859	"Tyrnävä" 860 "Tyrväntö" 861 "Tyrvää" 862 "Tytärsaari" 863 "Töysä" 885 "Ullava" 886	"Ulvila" 887 "Urjala" 888	"Uskela" 889 "Utajärvi" 890	"Utsjoki" 894 "Uudenkaarlepyyn mlk" 891	"Uukuniemi" 892	"Uurainen" 893	"Uusikaarlepyy" 895	"Uusikaupunki" 896 "Uudenkaupungin mlk" 897	"Uusikirkko" 785 "Vaala" 905 "Vaasa" 906 "Vahto"907	"Vahviala" 908 "Valkeakoski" 909 "Valkeala" 910	"Valkjärvi" 911	"Valtimo" 912 "Vammala" 913	"Vampula" 914	"Vanaja" 092 "Vantaa" 915 "Varkaus" 916	"Varpaisjärvi" 917 "Vehkalahti" 918	"Vehmaa" 919 "Vehmersalmi" 920	"Velkua" 921 "Vesanto" 922 "Vesilahti" 924 "Veteli" 925	"Vieremä" 926 "Vihanti" 927	"Vihti" 928	"Viiala" 929	"Viipuri" 930 "Viipurin mlk" 931 "Viitasaari" 932 "Viljakkala" 933 "Vilppula" 934 "Vimpeli" 935	"Virolahti" 936	"Virrat" 937 "Virtasalmi" 938 "Vuoksela"939	"Vuoksenranta" 940 "Vuolijoki" 941 "Vårdö" 942 "Vähäkyrö" 943	"Värtsilä" 923 "Västanfjärd" 944 "Vöyri" 945 "Vöyri-Maksamaa" 946 "Vöyri" 972 "Yli-Ii" 971 "Ylihärmä" 973	"Ylikiiminki" 974 "Ylimarkku" 975 "Ylistaro" 976 "Ylitornio" 977 "Ylivieska" 978 "Ylämaa" 979 "Yläne" 980	"Ylöjärvi" 981 "Ypäjä" 988 "Äetsä" 989 "Ähtäri" 990	"Ähtävä" 991 "Äyräpää" 992 "Äänekoski" 993 "Äänekosken mlk" 997	"Öja" 998	"Luovutetulla alueella" 199	"Tuntematon kunta Suomessa" 200	"Ulkomaat" 999 "Tuntematon"
label values kunta_a17 kunta_at_age_17

*------------------------------------------------------------------------------*
* Individuals' education level and matriculation examination at age 19              
*------------------------------------------------------------------------------*

destring educ_level matric_exam, replace 
gen educ_level_a19=educ_level if age==19
replace educ_level_a19=0 if educ_level_a19==. & age==19 
bysort shnro: egen educ_lev_a19=max(educ_level_a19)
recode educ_lev_a19 (0=1 "Primary educ." ) (3/4=2 "Secondary educ.") (5/8=3 "Tertiary educ."), into (educ_a19)
drop educ_level_a19 

gen matric_exam_a19=0
replace matric_exam_a19=1 if matric_exam>0 & age==19 
bysort shnro: egen matric_ex_a19=max(matric_exam_a19)
drop matric_exam_a19

save "path to data \folkperus_all_19872020_info2.dta", replace  

*------------------------------------------------------------------------------*
* Reduce to one line (age 19) and bring in rest of information           	  
*------------------------------------------------------------------------------*
 
use "path to data \folkperus_all_19872020_info2.dta", clear 

keep shnro byear dyear educ_a19 matric_ex_a19 kunta_a17 age female kieli_k /*
*/ matric_exam educ_level educ_field educ_type year_finish_educ employm_status occupation family_type wages_salaries /*
*/ total_earned_inc entrepeneurial_inc 

********************************************************************************
keep if age==19  
********************************************************************************
 
drop age 

merge 1:1 shnro using "path to data \masterfile_parents_mig.dta"
keep if _m==3 
drop _m
sort shnro
save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info.dta", replace 

*------------------------------------------------------------------------------*
*															     			   *
* Parental information							    
*															     			   *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Mother                                                                	   *
*------------------------------------------------------------------------------*

use "path to data \folkperus_all_19872020_info.dta", clear 

drop smkunta skunta svaltio_k kansa1_k syntyp2 ika kuntaryhm kunta31_12 kuntaryhm31_12 maka taajama_k2 /*
*/ amas1 optuki tyke tyokk akoko_k asty hape hulu taty vata penulaika *lkm_k pekoko_k vela tkela tyela mela osela pela /*
*/ yvela kturaha_k velaty_k lvar_k svatva_k auto_k
 
keep if sukup=="2"

gen help_mom=0
replace help_mom=1 if age==35
bysort shnro: egen help_mom2=sum(help_mom)
replace help_mom=1 if statistical_year==1987 & help_mom2==0 

gen age_mom=age 
replace help_mom=0 if age_mom<25 & help_mom==1 
replace help_mom=0 if age_mom>65 & help_mom==1 
drop help_mom2 
bysort shnro: egen help_mom2=sum(help_mom)
replace help_mom=1 if statistical_year==1987 & help_mom2==0
drop help_mom2 
bysort shnro: egen help_mom2=sum(help_mom)
replace help_mom=1 if statistical_year==2000 & help_mom2==0 & age_mom>24 & age_mom<66
drop help_mom2 

keep if help_mom==1 

destring educ_level,replace  
recode educ_level (.=1 "Primary educ.") (0=1 "Primary educ.") (3/4=2 "Secondary educ.") (5/8=3 "Tertiary educ."), into (educ_mom)

gen matric_exam_mom=0
replace matric_exam_mom=1 if matric_exam=="4" 

gen employed_mom=0
replace employed_mom=1 if employm_status=="11"

gen inc_mom=0
replace inc_mom=total_earned_inc 
 
destring family_type, replace 
gen family_type_mom=family_type 
gen single_mom=0
replace single_mom=1 if family_type==3 
 
keep shnro educ_mom matric_exam_mom employed_mom inc_mom family_type_mom single_mom age_mom

save "path to data \info_mom_help.dta", replace 

use "path to data \status_1970to2020.dta", clear
destring _all, replace 
sort shnro
save "path to data \kunta_1970to2020.dta", replace 

use "path to data \kunta_1970to2020.dta", clear 

keep shnro mtongue 

sort shnro 
merge 1:1  shnro using "path to data \info_mom_help.dta"

rename mtongue mtongue_mom
rename shnro aidin_shnro

keep aidin_shnro educ_mom matric_exam_mom employed_mom inc_mom family_type_mom single_mom mtongue_mom age_mom

save "path to data \info_mom.dta", replace 

use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info.dta", clear 
sort aidin_shnro 
merge n:1 aidin_shnro using "path to data \info_mom.dta"
drop if _m==2
drop _m
save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents1.dta", replace 

*------------------------------------------------------------------------------*
* Father	                                             	  
*------------------------------------------------------------------------------*

use "path to data \folkperus_all_19872020_info.dta", clear 

drop smkunta skunta svaltio_k kansa1_k syntyp2 ika kuntaryhm kunta31_12 kuntaryhm31_12 maka taajama_k2 /*
*/ amas1 optuki tyke tyokk akoko_k asty hape hulu taty vata penulaika *lkm_k pekoko_k vela tkela tyela mela osela pela /*
*/ yvela kturaha_k velaty_k lvar_k svatva_k auto_k
 
keep if sukup=="1"

gen help_dad=0
replace help_dad=1 if age==35
bysort shnro: egen help_dad2=sum(help_dad)
replace help_dad=1 if statistical_year==1987 & help_dad2==0  
drop help_dad2
bysort shnro: egen help_dad2=sum(help_dad)
drop help_dad2
gen age_dad=age 
replace help_dad=0 if age_dad<25 & help_dad==1 
replace help_dad=0 if age_dad>65 & help_dad==1 
bysort shnro: egen help_dad2=sum(help_dad)
replace help_dad=1 if statistical_year==2000 & help_dad2==0 & age_dad>24 & age_dad<66
drop help_dad2 
keep if help_dad==1 

destring educ_level,replace  
recode educ_level (.=1 "Primary educ.") (0=1 "Primary educ.") (3/4=2 "Secondary educ.") (5/8=3 "Tertiary educ."), into (educ_dad)

gen matric_exam_dad=0
replace matric_exam_dad=1 if matric_exam=="4" 

gen employed_dad=0
replace employed_dad=1 if employm_status=="11"

gen inc_dad=0
replace inc_dad=total_earned_inc 

destring family_type, replace 
gen family_type_dad=family_type 
gen single_dad=0
replace single_dad=1 if family_type==4 

keep shnro educ_dad matric_exam_dad employed_dad inc_dad family_type_dad single_dad age_dad
sort shnro 
save "path to data \info_dad_help.dta", replace 
 
use "path to data \kunta_1970to2020.dta", clear 

keep shnro mtongue 

sort shnro 
merge 1:1  shnro using "path to data \info_dad_help.dta"
rename mtongue mtongue_dad
rename shnro isan_shnro
drop _m
sort isan_shnro
save "path to data \info_dad.dta", replace 

use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents1.dta", clear 
sort isan_shnro 
merge n:1 isan_shnro using "path to data \info_dad.dta"
drop if _m==2
drop _m 
sort shnro 
save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parent2.dta", replace 

use "path to data \kunta_1970to2020.dta", clear
sort shnro 
merge 1:1 shnro using "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parent2.dta" 
keep if _m==3 
drop _m
save "path to data \syntyma_kuolema_mig_laspisuhde_info_parent2_statuskunta.dta", replace

*------------------------------------------------------------------------------*
* Ethnolinguistic background                        	   
*------------------------------------------------------------------------------*

use "path to data \syntyma_kuolema_mig_laspisuhde_info_parent2_statuskunta.dta",clear 

gen endogamous_sw=0
replace endogamous_sw=1 if mtongue==2 & mtongue_mom==2 & mtongue_dad==2 
gen endogamous_fi=0
replace endogamous_fi=1 if mtongue==1 & mtongue_mom==1 & mtongue_dad==1
gen exogamous_sw=0
replace exogamous_sw=1 if mtongue==2 & mtongue_mom==2 & mtongue_dad==1
replace exogamous_sw=1 if mtongue==2 & mtongue_mom==1 & mtongue_dad==2
gen exogamous_fi=0
replace exogamous_fi=1 if mtongue==1 & mtongue_mom==2 & mtongue_dad==1
replace exogamous_fi=1 if mtongue==1 & mtongue_mom==1 & mtongue_dad==2
gen other_sw=0 
replace other_sw=1 if mtongue==2 & mtongue_mom==3 & mtongue_dad!=.
replace other_sw=1 if mtongue==2 & mtongue_dad==3 & mtongue_mom!=.
gen other_fi=0 
replace other_fi=1 if mtongue==1 & mtongue_mom==3 & mtongue_dad!=.
replace other_fi=1 if mtongue==1 & mtongue_dad==3 & mtongue_mom!=. 
gen other=0
replace other=1 if mtongue==3 & mtongue_dad!=. & mtongue_mom!=.

gen background=. 
replace background=1 if endogamous_fi==1 
replace background=2 if endogamous_sw==1
replace background=3 if exogamous_sw==1 
replace background=4 if exogamous_fi==1
replace background=5 if other_sw==1
replace background=6 if other_fi==1
replace background=7 if other==1

label define background 1 "Finnish uniform backgr." 2 "Swedish uniform backgr."  3 "Swedish mixed backgr." 4 "Finnish mixed backgr." 5 "Swedish other backgr."   6 "Finnish other backgr." 7 "Other" , replace 
label values background background

*------------------------------------------------------------------------------*
* First set of restrictions                            
*------------------------------------------------------------------------------*

keep if byear>1969 & byear<2002
drop if skunta==200
drop if background>4
drop if background==. 

save "path to data \syntyma_kuolema_mig_laspisuhde_info_parent2_statuskunta_2.dta", replace

*------------------------------------------------------------------------------*
*															 			       *
* Share swedish speakers in municipality at age 17				   			   *                        
*																		       *
*------------------------------------------------------------------------------*

foreach year in 1987 1988 1989 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018 {

use "path to data \status_1970to2020.dta", clear 
keep shnro mtongue kunta_`year'

gen year=`year' 
gen swedish=0
replace swedish=1 if mtongue==2 
rename kunta_`year' kunta
destring kunta, replace 

drop if kunta==. 
gen index=_n
drop shnro

bysort kunta: gen kindex=_n
bysort kunta: gen kmindex=_N

bysort kunta: gen population_kunta=_N
bysort kunta: egen sw=sum(swedish)

gen sw_pop=((sw*100)/population_kunta)
keep if kindex==1 

rename kunta kunta_a17
gen kunta_`year'=kunta_a17
rename sw_pop sw_pop_`year'
keep year kunta_`year' kunta_a17 sw_pop_`year'
save "path to data \kunta_swpop`year'.dta", replace 
}

foreach year in 19 {

use "path to data \kunta_swpop`year'87.dta" ,clear
append using  "path to data \kunta_swpop`year'88.dta"
append using  "path to data \kunta_swpop`year'89.dta"
append using  "path to data \kunta_swpop`year'90.dta"
append using  "path to data \kunta_swpop`year'91.dta"
append using  "path to data \kunta_swpop`year'92.dta"
append using  "path to data \kunta_swpop`year'93.dta"
append using  "path to data \kunta_swpop`year'94.dta"
append using  "path to data \kunta_swpop`year'95.dta"
append using  "path to data \kunta_swpop`year'96.dta"
append using  "path to data \kunta_swpop`year'97.dta"
append using  "path to data \kunta_swpop`year'98.dta"
append using  "path to data \kunta_swpop`year'99.dta"

save  "path to data \kunta_swpop_years_p1.dta",replace 
}

foreach year in 20 {
	
use  "path to data \kunta_swpop`year'00.dta", clear 
append using  "path to data \kunta_swpop`year'01.dta"
append using  "path to data \kunta_swpop`year'02.dta"
append using  "path to data \kunta_swpop`year'03.dta"
append using  "path to data \kunta_swpop`year'04.dta"
append using  "path to data \kunta_swpop`year'05.dta"
append using  "path to data \kunta_swpop`year'06.dta"
append using  "path to data \kunta_swpop`year'07.dta"
append using  "path to data \kunta_swpop`year'08.dta"
append using  "path to data \kunta_swpop`year'09.dta"
append using  "path to data \kunta_swpop`year'10.dta"
append using  "path to data \kunta_swpop`year'11.dta"
append using  "path to data \kunta_swpop`year'12.dta"
append using  "path to data \kunta_swpop`year'13.dta"
append using  "path to data \kunta_swpop`year'14.dta"
append using  "path to data \kunta_swpop`year'15.dta"
append using  "path to data \kunta_swpop`year'16.dta"
append using  "path to data \kunta_swpop`year'17.dta"
append using  "path to data \kunta_swpop`year'18.dta"
sort kunta_a17 year
save  "path to data \kunta_swpop_years_p2.dta",replace 
}

use "path to data \kunta_swpop_years_p1.dta",clear 
append using "path to data \kunta_swpop_years_p2.dta" 
sort kunta_a17 year
keep year kunta_a17 sw_pop*
save  "path to data \kunta_swpop_years.dta",replace 

use  "path to data \syntyma_kuolema_mig_laspisuhde_info_parent2_statuskunta_2.dta", clear 

gen year=0
replace year = 1987 if byear==1970
replace year = 1988 if byear==1971
replace year = 1989 if byear==1972
replace year = 1990 if byear==1973
replace year = 1991 if byear==1974
replace year = 1992 if byear==1975
replace year = 1993 if byear==1976
replace year = 1994 if byear==1977
replace year = 1995 if byear==1978
replace year = 1996 if byear==1979
replace year = 1997 if byear==1980
replace year = 1998 if byear==1981
replace year = 1999 if byear==1982
replace year = 2000 if byear==1983
replace year = 2001 if byear==1984
replace year = 2002 if byear==1985
replace year = 2003 if byear==1986
replace year = 2004 if byear==1987
replace year = 2005 if byear==1988
replace year = 2006 if byear==1989
replace year = 2007 if byear==1990
replace year = 2008 if byear==1991
replace year = 2009 if byear==1992 
replace year = 2010 if byear==1993
replace year = 2011 if byear==1994
replace year = 2012 if byear==1995
replace year = 2013 if byear==1996
replace year = 2014 if byear==1997
replace year = 2015 if byear==1998
replace year = 2016 if byear==1999
replace year = 2017 if byear==2000
replace year = 2018 if byear==2001

sort kunta_a17 year 
merge n:1 kunta_a17 year using  "path to data \kunta_swpop_years.dta"
keep if _m==3 
drop _m 

gen sw_pop_a17=0
replace sw_pop_a17=sw_pop_1987 if byear==1970
replace sw_pop_a17=sw_pop_1988 if byear==1971
replace sw_pop_a17=sw_pop_1989 if byear==1972
replace sw_pop_a17=sw_pop_1990 if byear==1973
replace sw_pop_a17=sw_pop_1991 if byear==1974
replace sw_pop_a17=sw_pop_1992 if byear==1975
replace sw_pop_a17=sw_pop_1993 if byear==1976
replace sw_pop_a17=sw_pop_1994 if byear==1977
replace sw_pop_a17=sw_pop_1995 if byear==1978
replace sw_pop_a17=sw_pop_1996 if byear==1979
replace sw_pop_a17=sw_pop_1997 if byear==1980
replace sw_pop_a17=sw_pop_1998 if byear==1981
replace sw_pop_a17=sw_pop_1999 if byear==1982
replace sw_pop_a17=sw_pop_2000 if byear==1983
replace sw_pop_a17=sw_pop_2001 if byear==1984
replace sw_pop_a17=sw_pop_2002 if byear==1985
replace sw_pop_a17=sw_pop_2003 if byear==1986
replace sw_pop_a17=sw_pop_2004 if byear==1987
replace sw_pop_a17=sw_pop_2005 if byear==1988
replace sw_pop_a17=sw_pop_2006 if byear==1989
replace sw_pop_a17=sw_pop_2007 if byear==1990
replace sw_pop_a17=sw_pop_2008 if byear==1991
replace sw_pop_a17=sw_pop_2009 if byear==1992
replace sw_pop_a17=sw_pop_2010 if byear==1993
replace sw_pop_a17=sw_pop_2011 if byear==1994
replace sw_pop_a17=sw_pop_2012 if byear==1995
replace sw_pop_a17=sw_pop_2013 if byear==1996
replace sw_pop_a17=sw_pop_2014 if byear==1997
replace sw_pop_a17=sw_pop_2015 if byear==1998
replace sw_pop_a17=sw_pop_2016 if byear==1999
replace sw_pop_a17=sw_pop_2017 if byear==2000
replace sw_pop_a17=sw_pop_2018 if byear==2001
drop sw_pop_19* sw_pop_20*

save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop.dta", replace  
 
use  "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop.dta", clear

generate mkunta_a17 = .

replace mkunta_a17 = 1 if kunta_a17 ==	91	
replace mkunta_a17 = 1 if kunta_a17 ==	49	
replace mkunta_a17 = 1 if kunta_a17 ==	92	
replace mkunta_a17 = 1 if kunta_a17 ==	235	
replace mkunta_a17 = 2 if kunta_a17 ==	18	
replace mkunta_a17 = 2 if kunta_a17 ==	34	
replace mkunta_a17 = 2 if kunta_a17 ==	39	
replace mkunta_a17 = 2 if kunta_a17 ==	68	
replace mkunta_a17 = 2 if kunta_a17 ==	78	
replace mkunta_a17 = 2 if kunta_a17 ==	104	
replace mkunta_a17 = 2 if kunta_a17 ==	106	
replace mkunta_a17 = 2 if kunta_a17 ==	107	
replace mkunta_a17 = 2 if kunta_a17 ==	149	
replace mkunta_a17 = 2 if kunta_a17 ==	186	
replace mkunta_a17 = 2 if kunta_a17 ==	220	
replace mkunta_a17 = 2 if kunta_a17 ==	221	
replace mkunta_a17 = 2 if kunta_a17 ==	223	
replace mkunta_a17 = 2 if kunta_a17 ==	224	
replace mkunta_a17 = 2 if kunta_a17 ==	245	
replace mkunta_a17 = 2 if kunta_a17 ==	257	
replace mkunta_a17 = 2 if kunta_a17 ==	294	
replace mkunta_a17 = 2 if kunta_a17 ==	407	
replace mkunta_a17 = 2 if kunta_a17 ==	424	
replace mkunta_a17 = 2 if kunta_a17 ==	427	
replace mkunta_a17 = 2 if kunta_a17 ==	428	
replace mkunta_a17 = 2 if kunta_a17 ==	434	
replace mkunta_a17 = 2 if kunta_a17 ==	444	
replace mkunta_a17 = 2 if kunta_a17 ==	504	
replace mkunta_a17 = 2 if kunta_a17 ==	505	
replace mkunta_a17 = 2 if kunta_a17 ==	540	
replace mkunta_a17 = 2 if kunta_a17 ==	543	
replace mkunta_a17 = 2 if kunta_a17 ==	566	
replace mkunta_a17 = 2 if kunta_a17 ==	585	
replace mkunta_a17 = 2 if kunta_a17 ==	606	
replace mkunta_a17 = 2 if kunta_a17 ==	611	
replace mkunta_a17 = 2 if kunta_a17 ==	612	
replace mkunta_a17 = 2 if kunta_a17 ==	613	
replace mkunta_a17 = 2 if kunta_a17 ==	616	
replace mkunta_a17 = 2 if kunta_a17 ==	622	
replace mkunta_a17 = 2 if kunta_a17 ==	627	
replace mkunta_a17 = 2 if kunta_a17 ==	638	
replace mkunta_a17 = 2 if kunta_a17 ==	701	
replace mkunta_a17 = 2 if kunta_a17 ==	710	
replace mkunta_a17 = 2 if kunta_a17 ==	737	
replace mkunta_a17 = 2 if kunta_a17 ==	753	
replace mkunta_a17 = 2 if kunta_a17 ==	755	
replace mkunta_a17 = 2 if kunta_a17 ==	756	
replace mkunta_a17 = 2 if kunta_a17 ==	835	
replace mkunta_a17 = 2 if kunta_a17 ==	836	
replace mkunta_a17 = 2 if kunta_a17 ==	842	
replace mkunta_a17 = 2 if kunta_a17 ==	858	
replace mkunta_a17 = 2 if kunta_a17 ==	927	
replace mkunta_a17 = 3 if kunta_a17 ==	6	
replace mkunta_a17 = 3 if kunta_a17 ==	11	
replace mkunta_a17 = 3 if kunta_a17 ==	17	
replace mkunta_a17 = 3 if kunta_a17 ==	19	
replace mkunta_a17 = 3 if kunta_a17 ==	40	
replace mkunta_a17 = 3 if kunta_a17 ==	73	
replace mkunta_a17 = 3 if kunta_a17 ==	94	
replace mkunta_a17 = 3 if kunta_a17 ==	101	
replace mkunta_a17 = 3 if kunta_a17 ==	150	
replace mkunta_a17 = 3 if kunta_a17 ==	202	
replace mkunta_a17 = 3 if kunta_a17 ==	207	
replace mkunta_a17 = 3 if kunta_a17 ==	209	
replace mkunta_a17 = 3 if kunta_a17 ==	219	
replace mkunta_a17 = 3 if kunta_a17 ==	222	
replace mkunta_a17 = 3 if kunta_a17 ==	228	
replace mkunta_a17 = 3 if kunta_a17 ==	243	
replace mkunta_a17 = 3 if kunta_a17 ==	252	
replace mkunta_a17 = 3 if kunta_a17 ==	259	
replace mkunta_a17 = 3 if kunta_a17 ==	279	
replace mkunta_a17 = 3 if kunta_a17 ==	284	
replace mkunta_a17 = 3 if kunta_a17 ==	304	
replace mkunta_a17 = 3 if kunta_a17 ==	307	
replace mkunta_a17 = 3 if kunta_a17 ==	308	
replace mkunta_a17 = 3 if kunta_a17 ==	322	
replace mkunta_a17 = 3 if kunta_a17 ==	400	
replace mkunta_a17 = 3 if kunta_a17 ==	419	
replace mkunta_a17 = 3 if kunta_a17 ==	423	
replace mkunta_a17 = 3 if kunta_a17 ==	430	
replace mkunta_a17 = 3 if kunta_a17 ==	431	
replace mkunta_a17 = 3 if kunta_a17 ==	432	
replace mkunta_a17 = 3 if kunta_a17 ==	445	
replace mkunta_a17 = 3 if kunta_a17 ==	477	
replace mkunta_a17 = 3 if kunta_a17 ==	480	
replace mkunta_a17 = 3 if kunta_a17 ==	481	
replace mkunta_a17 = 3 if kunta_a17 ==	482	
replace mkunta_a17 = 3 if kunta_a17 ==	485	
replace mkunta_a17 = 3 if kunta_a17 ==	487	
replace mkunta_a17 = 3 if kunta_a17 ==	490	
replace mkunta_a17 = 3 if kunta_a17 ==	501	
replace mkunta_a17 = 3 if kunta_a17 ==	503	
replace mkunta_a17 = 3 if kunta_a17 ==	529	
replace mkunta_a17 = 3 if kunta_a17 ==	530	
replace mkunta_a17 = 3 if kunta_a17 ==	533	
replace mkunta_a17 = 3 if kunta_a17 ==	538	
replace mkunta_a17 = 3 if kunta_a17 ==	561	
replace mkunta_a17 = 3 if kunta_a17 ==	573	
replace mkunta_a17 = 3 if kunta_a17 ==	574	
replace mkunta_a17 = 3 if kunta_a17 ==	577	
replace mkunta_a17 = 3 if kunta_a17 ==	579	
replace mkunta_a17 = 3 if kunta_a17 ==	586	
replace mkunta_a17 = 3 if kunta_a17 ==	587	
replace mkunta_a17 = 3 if kunta_a17 ==	602	
replace mkunta_a17 = 3 if kunta_a17 ==	629	
replace mkunta_a17 = 3 if kunta_a17 ==	631	
replace mkunta_a17 = 3 if kunta_a17 ==	636	
replace mkunta_a17 = 3 if kunta_a17 ==	680	
replace mkunta_a17 = 3 if kunta_a17 ==	704	
replace mkunta_a17 = 3 if kunta_a17 ==	705	
replace mkunta_a17 = 3 if kunta_a17 ==	734	
replace mkunta_a17 = 3 if kunta_a17 ==	738	
replace mkunta_a17 = 3 if kunta_a17 ==	760	
replace mkunta_a17 = 3 if kunta_a17 ==	761	
replace mkunta_a17 = 3 if kunta_a17 ==	776	
replace mkunta_a17 = 3 if kunta_a17 ==	784	
replace mkunta_a17 = 3 if kunta_a17 ==	833	
replace mkunta_a17 = 3 if kunta_a17 ==	838	
replace mkunta_a17 = 3 if kunta_a17 ==	853	
replace mkunta_a17 = 3 if kunta_a17 ==	888	
replace mkunta_a17 = 3 if kunta_a17 ==	895	
replace mkunta_a17 = 3 if kunta_a17 ==	896	
replace mkunta_a17 = 3 if kunta_a17 ==	906	
replace mkunta_a17 = 3 if kunta_a17 ==	918	
replace mkunta_a17 = 3 if kunta_a17 ==	920	
replace mkunta_a17 = 3 if kunta_a17 ==	923	
replace mkunta_a17 = 3 if kunta_a17 ==	979	
replace mkunta_a17 = 5 if kunta_a17 ==	1	
replace mkunta_a17 = 5 if kunta_a17 ==	50	
replace mkunta_a17 = 5 if kunta_a17 ==	51	
replace mkunta_a17 = 5 if kunta_a17 ==	79	
replace mkunta_a17 = 5 if kunta_a17 ==	96	
replace mkunta_a17 = 5 if kunta_a17 ==	99	
replace mkunta_a17 = 5 if kunta_a17 ==	100	
replace mkunta_a17 = 5 if kunta_a17 ==	102	
replace mkunta_a17 = 5 if kunta_a17 ==	181	
replace mkunta_a17 = 5 if kunta_a17 ==	214	
replace mkunta_a17 = 5 if kunta_a17 ==	230	
replace mkunta_a17 = 5 if kunta_a17 ==	237	
replace mkunta_a17 = 5 if kunta_a17 ==	262	
replace mkunta_a17 = 5 if kunta_a17 ==	266	
replace mkunta_a17 = 5 if kunta_a17 ==	271	
replace mkunta_a17 = 5 if kunta_a17 ==	293	
replace mkunta_a17 = 5 if kunta_a17 ==	319	
replace mkunta_a17 = 5 if kunta_a17 ==	406	
replace mkunta_a17 = 5 if kunta_a17 ==	413	
replace mkunta_a17 = 5 if kunta_a17 ==	442	
replace mkunta_a17 = 5 if kunta_a17 ==	484	
replace mkunta_a17 = 5 if kunta_a17 ==	531	
replace mkunta_a17 = 5 if kunta_a17 ==	537	
replace mkunta_a17 = 5 if kunta_a17 ==	608	
replace mkunta_a17 = 5 if kunta_a17 ==	609	
replace mkunta_a17 = 5 if kunta_a17 ==	610	
replace mkunta_a17 = 5 if kunta_a17 ==	684	
replace mkunta_a17 = 5 if kunta_a17 ==	685	
replace mkunta_a17 = 5 if kunta_a17 ==	747	
replace mkunta_a17 = 5 if kunta_a17 ==	783	
replace mkunta_a17 = 5 if kunta_a17 ==	886	
replace mkunta_a17 = 5 if kunta_a17 ==	913	
replace mkunta_a17 = 6 if kunta_a17 ==	61	
replace mkunta_a17 = 6 if kunta_a17 ==	82	
replace mkunta_a17 = 6 if kunta_a17 ==	83	
replace mkunta_a17 = 6 if kunta_a17 ==	86	
replace mkunta_a17 = 6 if kunta_a17 ==	103	
replace mkunta_a17 = 6 if kunta_a17 ==	109	
replace mkunta_a17 = 6 if kunta_a17 ==	110	
replace mkunta_a17 = 6 if kunta_a17 ==	165	
replace mkunta_a17 = 6 if kunta_a17 ==	169	
replace mkunta_a17 = 6 if kunta_a17 ==	210	
replace mkunta_a17 = 6 if kunta_a17 ==	267	
replace mkunta_a17 = 6 if kunta_a17 ==	401	
replace mkunta_a17 = 6 if kunta_a17 ==	433	
replace mkunta_a17 = 6 if kunta_a17 ==	692	
replace mkunta_a17 = 6 if kunta_a17 ==	694	
replace mkunta_a17 = 6 if kunta_a17 ==	834	
replace mkunta_a17 = 6 if kunta_a17 ==	855	
replace mkunta_a17 = 6 if kunta_a17 ==	860	
replace mkunta_a17 = 6 if kunta_a17 ==	914	
replace mkunta_a17 = 6 if kunta_a17 ==	981	
replace mkunta_a17 = 7 if kunta_a17 ==	2	
replace mkunta_a17 = 7 if kunta_a17 ==	3	
replace mkunta_a17 = 7 if kunta_a17 ==	20	
replace mkunta_a17 = 7 if kunta_a17 ==	48	
replace mkunta_a17 = 7 if kunta_a17 ==	108	
replace mkunta_a17 = 7 if kunta_a17 ==	143	
replace mkunta_a17 = 7 if kunta_a17 ==	144	
replace mkunta_a17 = 7 if kunta_a17 ==	177	
replace mkunta_a17 = 7 if kunta_a17 ==	211	
replace mkunta_a17 = 7 if kunta_a17 ==	225	
replace mkunta_a17 = 7 if kunta_a17 ==	238	
replace mkunta_a17 = 7 if kunta_a17 ==	250	
replace mkunta_a17 = 7 if kunta_a17 ==	253	
replace mkunta_a17 = 7 if kunta_a17 ==	254	
replace mkunta_a17 = 7 if kunta_a17 ==	289	
replace mkunta_a17 = 7 if kunta_a17 ==	303	
replace mkunta_a17 = 7 if kunta_a17 ==	310	
replace mkunta_a17 = 7 if kunta_a17 ==	418	
replace mkunta_a17 = 7 if kunta_a17 ==	439	
replace mkunta_a17 = 7 if kunta_a17 ==	486	
replace mkunta_a17 = 7 if kunta_a17 ==	493	
replace mkunta_a17 = 7 if kunta_a17 ==	506	
replace mkunta_a17 = 7 if kunta_a17 ==	508	
replace mkunta_a17 = 7 if kunta_a17 ==	536	
replace mkunta_a17 = 7 if kunta_a17 ==	562	
replace mkunta_a17 = 7 if kunta_a17 ==	581	
replace mkunta_a17 = 7 if kunta_a17 ==	604	
replace mkunta_a17 = 7 if kunta_a17 ==	619	
replace mkunta_a17 = 7 if kunta_a17 ==	635	
replace mkunta_a17 = 7 if kunta_a17 ==	637	
replace mkunta_a17 = 7 if kunta_a17 ==	702	
replace mkunta_a17 = 7 if kunta_a17 ==	730	
replace mkunta_a17 = 7 if kunta_a17 ==	772	
replace mkunta_a17 = 7 if kunta_a17 ==	779	
replace mkunta_a17 = 7 if kunta_a17 ==	788	
replace mkunta_a17 = 7 if kunta_a17 ==	790	
replace mkunta_a17 = 7 if kunta_a17 ==	837	
replace mkunta_a17 = 7 if kunta_a17 ==	840	
replace mkunta_a17 = 7 if kunta_a17 ==	852	
replace mkunta_a17 = 7 if kunta_a17 ==	861	
replace mkunta_a17 = 7 if kunta_a17 ==	864	
replace mkunta_a17 = 7 if kunta_a17 ==	887	
replace mkunta_a17 = 7 if kunta_a17 ==	908	
replace mkunta_a17 = 7 if kunta_a17 ==	912	
replace mkunta_a17 = 7 if kunta_a17 ==	922	
replace mkunta_a17 = 7 if kunta_a17 ==	928	
replace mkunta_a17 = 7 if kunta_a17 ==	932	
replace mkunta_a17 = 7 if kunta_a17 ==	933	
replace mkunta_a17 = 7 if kunta_a17 ==	936	
replace mkunta_a17 = 7 if kunta_a17 ==	980	
replace mkunta_a17 = 7 if kunta_a17 ==	988	
replace mkunta_a17 = 7 if kunta_a17 ==	994	
replace mkunta_a17 = 8 if kunta_a17 ==	15	
replace mkunta_a17 = 8 if kunta_a17 ==	16	
replace mkunta_a17 = 8 if kunta_a17 ==	81	
replace mkunta_a17 = 8 if kunta_a17 ==	88	
replace mkunta_a17 = 8 if kunta_a17 ==	89	
replace mkunta_a17 = 8 if kunta_a17 ==	98	
replace mkunta_a17 = 8 if kunta_a17 ==	111	
replace mkunta_a17 = 8 if kunta_a17 ==	283	
replace mkunta_a17 = 8 if kunta_a17 ==	316	
replace mkunta_a17 = 8 if kunta_a17 ==	398	
replace mkunta_a17 = 8 if kunta_a17 ==	532	
replace mkunta_a17 = 8 if kunta_a17 ==	560	
replace mkunta_a17 = 8 if kunta_a17 ==	576	
replace mkunta_a17 = 8 if kunta_a17 ==	781	
replace mkunta_a17 = 9 if kunta_a17 ==	12	
replace mkunta_a17 = 9 if kunta_a17 ==	44	
replace mkunta_a17 = 9 if kunta_a17 ==	70	
replace mkunta_a17 = 9 if kunta_a17 ==	75	
replace mkunta_a17 = 9 if kunta_a17 ==	142	
replace mkunta_a17 = 9 if kunta_a17 ==	163	
replace mkunta_a17 = 9 if kunta_a17 ==	201	
replace mkunta_a17 = 9 if kunta_a17 ==	285	
replace mkunta_a17 = 9 if kunta_a17 ==	286	
replace mkunta_a17 = 9 if kunta_a17 ==	306	
replace mkunta_a17 = 9 if kunta_a17 ==	311	
replace mkunta_a17 = 9 if kunta_a17 ==	489	
replace mkunta_a17 = 9 if kunta_a17 ==	624	
replace mkunta_a17 = 9 if kunta_a17 ==	754	
replace mkunta_a17 = 9 if kunta_a17 ==	909	
replace mkunta_a17 = 9 if kunta_a17 ==	917	
replace mkunta_a17 = 9 if kunta_a17 ==	935	
replace mkunta_a17 = 10 if kunta_a17 ==	153	
replace mkunta_a17 = 10 if kunta_a17 ==	173	
replace mkunta_a17 = 10 if kunta_a17 ==	185	
replace mkunta_a17 = 10 if kunta_a17 ==	404	
replace mkunta_a17 = 10 if kunta_a17 ==	405	
replace mkunta_a17 = 10 if kunta_a17 ==	411	
replace mkunta_a17 = 10 if kunta_a17 ==	416	
replace mkunta_a17 = 10 if kunta_a17 ==	441	
replace mkunta_a17 = 10 if kunta_a17 ==	539	
replace mkunta_a17 = 10 if kunta_a17 ==	580	
replace mkunta_a17 = 10 if kunta_a17 ==	689	
replace mkunta_a17 = 10 if kunta_a17 ==	700	
replace mkunta_a17 = 10 if kunta_a17 ==	728	
replace mkunta_a17 = 10 if kunta_a17 ==	739	
replace mkunta_a17 = 10 if kunta_a17 ==	752	
replace mkunta_a17 = 10 if kunta_a17 ==	782	
replace mkunta_a17 = 10 if kunta_a17 ==	831	
replace mkunta_a17 = 10 if kunta_a17 ==	891	
replace mkunta_a17 = 10 if kunta_a17 ==	907	
replace mkunta_a17 = 10 if kunta_a17 ==	978	
replace mkunta_a17 = 11 if kunta_a17 ==	14	
replace mkunta_a17 = 11 if kunta_a17 ==	46	
replace mkunta_a17 = 11 if kunta_a17 ==	85	
replace mkunta_a17 = 11 if kunta_a17 ==	90	
replace mkunta_a17 = 11 if kunta_a17 ==	97	
replace mkunta_a17 = 11 if kunta_a17 ==	171	
replace mkunta_a17 = 11 if kunta_a17 ==	178	
replace mkunta_a17 = 11 if kunta_a17 ==	184	
replace mkunta_a17 = 11 if kunta_a17 ==	213	
replace mkunta_a17 = 11 if kunta_a17 ==	246	
replace mkunta_a17 = 11 if kunta_a17 ==	491	
replace mkunta_a17 = 11 if kunta_a17 ==	492	
replace mkunta_a17 = 11 if kunta_a17 ==	507	
replace mkunta_a17 = 11 if kunta_a17 ==	588	
replace mkunta_a17 = 11 if kunta_a17 ==	593	
replace mkunta_a17 = 11 if kunta_a17 ==	594	
replace mkunta_a17 = 11 if kunta_a17 ==	618	
replace mkunta_a17 = 11 if kunta_a17 ==	623	
replace mkunta_a17 = 11 if kunta_a17 ==	640	
replace mkunta_a17 = 11 if kunta_a17 ==	681	
replace mkunta_a17 = 11 if kunta_a17 ==	696	
replace mkunta_a17 = 11 if kunta_a17 ==	740	
replace mkunta_a17 = 11 if kunta_a17 ==	741	
replace mkunta_a17 = 11 if kunta_a17 ==	768	
replace mkunta_a17 = 11 if kunta_a17 ==	775	
replace mkunta_a17 = 11 if kunta_a17 ==	789	
replace mkunta_a17 = 11 if kunta_a17 ==	937	
replace mkunta_a17 = 12 if kunta_a17 ==	140	
replace mkunta_a17 = 12 if kunta_a17 ==	141	
replace mkunta_a17 = 12 if kunta_a17 ==	174	
replace mkunta_a17 = 12 if kunta_a17 ==	204	
replace mkunta_a17 = 12 if kunta_a17 ==	212	
replace mkunta_a17 = 12 if kunta_a17 ==	227	
replace mkunta_a17 = 12 if kunta_a17 ==	239	
replace mkunta_a17 = 12 if kunta_a17 ==	263	
replace mkunta_a17 = 12 if kunta_a17 ==	297	
replace mkunta_a17 = 12 if kunta_a17 ==	298	
replace mkunta_a17 = 12 if kunta_a17 ==	402	
replace mkunta_a17 = 12 if kunta_a17 ==	420	
replace mkunta_a17 = 12 if kunta_a17 ==	476	
replace mkunta_a17 = 12 if kunta_a17 ==	502	
replace mkunta_a17 = 12 if kunta_a17 ==	534	
replace mkunta_a17 = 12 if kunta_a17 ==	595	
replace mkunta_a17 = 12 if kunta_a17 ==	686	
replace mkunta_a17 = 12 if kunta_a17 ==	687	
replace mkunta_a17 = 12 if kunta_a17 ==	695	
replace mkunta_a17 = 12 if kunta_a17 ==	749	
replace mkunta_a17 = 12 if kunta_a17 ==	762	
replace mkunta_a17 = 12 if kunta_a17 ==	778	
replace mkunta_a17 = 12 if kunta_a17 ==	786	
replace mkunta_a17 = 12 if kunta_a17 ==	844	
replace mkunta_a17 = 12 if kunta_a17 ==	857	
replace mkunta_a17 = 12 if kunta_a17 ==	915	
replace mkunta_a17 = 12 if kunta_a17 ==	916	
replace mkunta_a17 = 12 if kunta_a17 ==	919	
replace mkunta_a17 = 12 if kunta_a17 ==	921	
replace mkunta_a17 = 12 if kunta_a17 ==	925	
replace mkunta_a17 = 13 if kunta_a17 ==	45	
replace mkunta_a17 = 13 if kunta_a17 ==	146	
replace mkunta_a17 = 13 if kunta_a17 ==	167	
replace mkunta_a17 = 13 if kunta_a17 ==	176	
replace mkunta_a17 = 13 if kunta_a17 ==	248	
replace mkunta_a17 = 13 if kunta_a17 ==	251	
replace mkunta_a17 = 13 if kunta_a17 ==	260	
replace mkunta_a17 = 13 if kunta_a17 ==	276	
replace mkunta_a17 = 13 if kunta_a17 ==	278	
replace mkunta_a17 = 13 if kunta_a17 ==	309	
replace mkunta_a17 = 13 if kunta_a17 ==	422	
replace mkunta_a17 = 13 if kunta_a17 ==	426	
replace mkunta_a17 = 13 if kunta_a17 ==	541	
replace mkunta_a17 = 13 if kunta_a17 ==	542	
replace mkunta_a17 = 13 if kunta_a17 ==	596	
replace mkunta_a17 = 13 if kunta_a17 ==	597	
replace mkunta_a17 = 13 if kunta_a17 ==	607	
replace mkunta_a17 = 13 if kunta_a17 ==	632	
replace mkunta_a17 = 13 if kunta_a17 ==	634	
replace mkunta_a17 = 13 if kunta_a17 ==	707	
replace mkunta_a17 = 13 if kunta_a17 ==	848	
replace mkunta_a17 = 13 if kunta_a17 ==	856	
replace mkunta_a17 = 13 if kunta_a17 ==	911	
replace mkunta_a17 = 13 if kunta_a17 ==	943	
replace mkunta_a17 = 14 if kunta_a17 ==	77	
replace mkunta_a17 = 14 if kunta_a17 ==	172	
replace mkunta_a17 = 14 if kunta_a17 ==	179	
replace mkunta_a17 = 14 if kunta_a17 ==	180	
replace mkunta_a17 = 14 if kunta_a17 ==	182	
replace mkunta_a17 = 14 if kunta_a17 ==	183	
replace mkunta_a17 = 14 if kunta_a17 ==	216	
replace mkunta_a17 = 14 if kunta_a17 ==	226	
replace mkunta_a17 = 14 if kunta_a17 ==	249	
replace mkunta_a17 = 14 if kunta_a17 ==	256	
replace mkunta_a17 = 14 if kunta_a17 ==	265	
replace mkunta_a17 = 14 if kunta_a17 ==	274	
replace mkunta_a17 = 14 if kunta_a17 ==	275	
replace mkunta_a17 = 14 if kunta_a17 ==	277	
replace mkunta_a17 = 14 if kunta_a17 ==	282	
replace mkunta_a17 = 14 if kunta_a17 ==	291	
replace mkunta_a17 = 14 if kunta_a17 ==	299	
replace mkunta_a17 = 14 if kunta_a17 ==	312	
replace mkunta_a17 = 14 if kunta_a17 ==	410	
replace mkunta_a17 = 14 if kunta_a17 ==	415	
replace mkunta_a17 = 14 if kunta_a17 ==	435	
replace mkunta_a17 = 14 if kunta_a17 ==	443	
replace mkunta_a17 = 14 if kunta_a17 ==	495	
replace mkunta_a17 = 14 if kunta_a17 ==	500	
replace mkunta_a17 = 14 if kunta_a17 ==	592	
replace mkunta_a17 = 14 if kunta_a17 ==	600	
replace mkunta_a17 = 14 if kunta_a17 ==	601	
replace mkunta_a17 = 14 if kunta_a17 ==	633	
replace mkunta_a17 = 14 if kunta_a17 ==	729	
replace mkunta_a17 = 14 if kunta_a17 ==	770	
replace mkunta_a17 = 14 if kunta_a17 ==	774	
replace mkunta_a17 = 14 if kunta_a17 ==	787	
replace mkunta_a17 = 14 if kunta_a17 ==	850	
replace mkunta_a17 = 14 if kunta_a17 ==	892	
replace mkunta_a17 = 14 if kunta_a17 ==	931	
replace mkunta_a17 = 14 if kunta_a17 ==	992	
replace mkunta_a17 = 14 if kunta_a17 ==	993	
replace mkunta_a17 = 15 if kunta_a17 ==	4	
replace mkunta_a17 = 15 if kunta_a17 ==	5	
replace mkunta_a17 = 15 if kunta_a17 ==	10	
replace mkunta_a17 = 15 if kunta_a17 ==	52	
replace mkunta_a17 = 15 if kunta_a17 ==	145	
replace mkunta_a17 = 15 if kunta_a17 ==	151	
replace mkunta_a17 = 15 if kunta_a17 ==	164	
replace mkunta_a17 = 15 if kunta_a17 ==	175	
replace mkunta_a17 = 15 if kunta_a17 ==	218	
replace mkunta_a17 = 15 if kunta_a17 ==	232	
replace mkunta_a17 = 15 if kunta_a17 ==	233	
replace mkunta_a17 = 15 if kunta_a17 ==	281	
replace mkunta_a17 = 15 if kunta_a17 ==	300	
replace mkunta_a17 = 15 if kunta_a17 ==	301	
replace mkunta_a17 = 15 if kunta_a17 ==	403	
replace mkunta_a17 = 15 if kunta_a17 ==	408	
replace mkunta_a17 = 15 if kunta_a17 ==	414	
replace mkunta_a17 = 15 if kunta_a17 ==	544	
replace mkunta_a17 = 15 if kunta_a17 ==	589	
replace mkunta_a17 = 15 if kunta_a17 ==	743	
replace mkunta_a17 = 15 if kunta_a17 ==	744	
replace mkunta_a17 = 15 if kunta_a17 ==	759	
replace mkunta_a17 = 15 if kunta_a17 ==	846	
replace mkunta_a17 = 15 if kunta_a17 ==	863	
replace mkunta_a17 = 15 if kunta_a17 ==	934	
replace mkunta_a17 = 15 if kunta_a17 ==	971	
replace mkunta_a17 = 15 if kunta_a17 ==	975	
replace mkunta_a17 = 15 if kunta_a17 ==	989	
replace mkunta_a17 = 16 if kunta_a17 ==	8	
replace mkunta_a17 = 16 if kunta_a17 ==	32	
replace mkunta_a17 = 16 if kunta_a17 ==	33	
replace mkunta_a17 = 16 if kunta_a17 ==	152	
replace mkunta_a17 = 16 if kunta_a17 ==	166	
replace mkunta_a17 = 16 if kunta_a17 ==	231	
replace mkunta_a17 = 16 if kunta_a17 ==	270	
replace mkunta_a17 = 16 if kunta_a17 ==	280	
replace mkunta_a17 = 16 if kunta_a17 ==	287	
replace mkunta_a17 = 16 if kunta_a17 ==	288	
replace mkunta_a17 = 16 if kunta_a17 ==	399	
replace mkunta_a17 = 16 if kunta_a17 ==	409	
replace mkunta_a17 = 16 if kunta_a17 ==	440	
replace mkunta_a17 = 16 if kunta_a17 ==	475	
replace mkunta_a17 = 16 if kunta_a17 ==	479	
replace mkunta_a17 = 16 if kunta_a17 ==	496	
replace mkunta_a17 = 16 if kunta_a17 ==	499	
replace mkunta_a17 = 16 if kunta_a17 ==	545	
replace mkunta_a17 = 16 if kunta_a17 ==	559	
replace mkunta_a17 = 16 if kunta_a17 ==	590	
replace mkunta_a17 = 16 if kunta_a17 ==	598	
replace mkunta_a17 = 16 if kunta_a17 ==	599	
replace mkunta_a17 = 16 if kunta_a17 ==	605	
replace mkunta_a17 = 16 if kunta_a17 ==	621	
replace mkunta_a17 = 16 if kunta_a17 ==	679	
replace mkunta_a17 = 16 if kunta_a17 ==	750	
replace mkunta_a17 = 16 if kunta_a17 ==	769	
replace mkunta_a17 = 16 if kunta_a17 ==	839	
replace mkunta_a17 = 16 if kunta_a17 ==	847	
replace mkunta_a17 = 16 if kunta_a17 ==	893	
replace mkunta_a17 = 16 if kunta_a17 ==	894	
replace mkunta_a17 = 16 if kunta_a17 ==	905	
replace mkunta_a17 = 16 if kunta_a17 ==	942	
replace mkunta_a17 = 16 if kunta_a17 ==	944	
replace mkunta_a17 = 16 if kunta_a17 ==	945	
replace mkunta_a17 = 16 if kunta_a17 ==	946	
replace mkunta_a17 = 16 if kunta_a17 ==	974	
replace mkunta_a17 = 16 if kunta_a17 ==	990	
replace mkunta_a17 = 17 if kunta_a17 ==	74	
replace mkunta_a17 = 17 if kunta_a17 ==	203	
replace mkunta_a17 = 17 if kunta_a17 ==	217	
replace mkunta_a17 = 17 if kunta_a17 ==	236	
replace mkunta_a17 = 17 if kunta_a17 ==	272	
replace mkunta_a17 = 17 if kunta_a17 ==	315	
replace mkunta_a17 = 17 if kunta_a17 ==	421	
replace mkunta_a17 = 17 if kunta_a17 ==	429	
replace mkunta_a17 = 17 if kunta_a17 ==	584	
replace mkunta_a17 = 17 if kunta_a17 ==	849	
replace mkunta_a17 = 17 if kunta_a17 ==	885	
replace mkunta_a17 = 17 if kunta_a17 ==	924	
replace mkunta_a17 = 17 if kunta_a17 ==	997	
replace mkunta_a17 = 18 if kunta_a17 ==	9	
replace mkunta_a17 = 18 if kunta_a17 ==	69	
replace mkunta_a17 = 18 if kunta_a17 ==	71	
replace mkunta_a17 = 18 if kunta_a17 ==	72	
replace mkunta_a17 = 18 if kunta_a17 ==	84	
replace mkunta_a17 = 18 if kunta_a17 ==	95	
replace mkunta_a17 = 18 if kunta_a17 ==	139	
replace mkunta_a17 = 18 if kunta_a17 ==	208	
replace mkunta_a17 = 18 if kunta_a17 ==	244	
replace mkunta_a17 = 18 if kunta_a17 ==	247	
replace mkunta_a17 = 18 if kunta_a17 ==	255	
replace mkunta_a17 = 18 if kunta_a17 ==	292	
replace mkunta_a17 = 18 if kunta_a17 ==	305	
replace mkunta_a17 = 18 if kunta_a17 ==	317	
replace mkunta_a17 = 18 if kunta_a17 ==	425	
replace mkunta_a17 = 18 if kunta_a17 ==	436	
replace mkunta_a17 = 18 if kunta_a17 ==	483	
replace mkunta_a17 = 18 if kunta_a17 ==	494	
replace mkunta_a17 = 18 if kunta_a17 ==	535	
replace mkunta_a17 = 18 if kunta_a17 ==	563	
replace mkunta_a17 = 18 if kunta_a17 ==	564	
replace mkunta_a17 = 18 if kunta_a17 ==	565	
replace mkunta_a17 = 18 if kunta_a17 ==	567	
replace mkunta_a17 = 18 if kunta_a17 ==	575	
replace mkunta_a17 = 18 if kunta_a17 ==	582	
replace mkunta_a17 = 18 if kunta_a17 ==	603	
replace mkunta_a17 = 18 if kunta_a17 ==	615	
replace mkunta_a17 = 18 if kunta_a17 ==	617	
replace mkunta_a17 = 18 if kunta_a17 ==	625	
replace mkunta_a17 = 18 if kunta_a17 ==	626	
replace mkunta_a17 = 18 if kunta_a17 ==	630	
replace mkunta_a17 = 18 if kunta_a17 ==	678	
replace mkunta_a17 = 18 if kunta_a17 ==	682	
replace mkunta_a17 = 18 if kunta_a17 ==	688	
replace mkunta_a17 = 18 if kunta_a17 ==	691	
replace mkunta_a17 = 18 if kunta_a17 ==	693	
replace mkunta_a17 = 18 if kunta_a17 ==	708	
replace mkunta_a17 = 18 if kunta_a17 ==	735	
replace mkunta_a17 = 18 if kunta_a17 ==	746	
replace mkunta_a17 = 18 if kunta_a17 ==	748	
replace mkunta_a17 = 18 if kunta_a17 ==	785	
replace mkunta_a17 = 18 if kunta_a17 ==	791	
replace mkunta_a17 = 18 if kunta_a17 ==	832	
replace mkunta_a17 = 18 if kunta_a17 ==	841	
replace mkunta_a17 = 18 if kunta_a17 ==	859	
replace mkunta_a17 = 18 if kunta_a17 ==	889	
replace mkunta_a17 = 18 if kunta_a17 ==	926	
replace mkunta_a17 = 18 if kunta_a17 ==	972	
replace mkunta_a17 = 18 if kunta_a17 ==	973	
replace mkunta_a17 = 18 if kunta_a17 ==	977	
replace mkunta_a17 = 19 if kunta_a17 ==	105	
replace mkunta_a17 = 19 if kunta_a17 ==	205	
replace mkunta_a17 = 19 if kunta_a17 ==	206	
replace mkunta_a17 = 19 if kunta_a17 ==	290	
replace mkunta_a17 = 19 if kunta_a17 ==	578	
replace mkunta_a17 = 19 if kunta_a17 ==	620	
replace mkunta_a17 = 19 if kunta_a17 ==	697	
replace mkunta_a17 = 19 if kunta_a17 ==	765	
replace mkunta_a17 = 19 if kunta_a17 ==	777	
replace mkunta_a17 = 19 if kunta_a17 ==	940	
replace mkunta_a17 = 20 if kunta_a17 ==	7	
replace mkunta_a17 = 20 if kunta_a17 ==	47	
replace mkunta_a17 = 20 if kunta_a17 ==	148	
replace mkunta_a17 = 20 if kunta_a17 ==	229	
replace mkunta_a17 = 20 if kunta_a17 ==	240	
replace mkunta_a17 = 20 if kunta_a17 ==	241	
replace mkunta_a17 = 20 if kunta_a17 ==	242	
replace mkunta_a17 = 20 if kunta_a17 ==	261	
replace mkunta_a17 = 20 if kunta_a17 ==	273	
replace mkunta_a17 = 20 if kunta_a17 ==	320	
replace mkunta_a17 = 20 if kunta_a17 ==	498	
replace mkunta_a17 = 20 if kunta_a17 ==	583	
replace mkunta_a17 = 20 if kunta_a17 ==	614	
replace mkunta_a17 = 20 if kunta_a17 ==	683	
replace mkunta_a17 = 20 if kunta_a17 ==	698	
replace mkunta_a17 = 20 if kunta_a17 ==	699	
replace mkunta_a17 = 20 if kunta_a17 ==	732	
replace mkunta_a17 = 20 if kunta_a17 ==	742	
replace mkunta_a17 = 20 if kunta_a17 ==	751	
replace mkunta_a17 = 20 if kunta_a17 ==	758	
replace mkunta_a17 = 20 if kunta_a17 ==	845	
replace mkunta_a17 = 20 if kunta_a17 ==	851	
replace mkunta_a17 = 20 if kunta_a17 ==	854	
replace mkunta_a17 = 20 if kunta_a17 ==	890	
replace mkunta_a17 = 20 if kunta_a17 ==	976	
replace mkunta_a17 = 22 if kunta_a17 ==	35	
replace mkunta_a17 = 22 if kunta_a17 ==	43	
replace mkunta_a17 = 22 if kunta_a17 ==	60	
replace mkunta_a17 = 22 if kunta_a17 ==	62	
replace mkunta_a17 = 22 if kunta_a17 ==	65	
replace mkunta_a17 = 22 if kunta_a17 ==	76	
replace mkunta_a17 = 22 if kunta_a17 ==	170	
replace mkunta_a17 = 22 if kunta_a17 ==	295	
replace mkunta_a17 = 22 if kunta_a17 ==	318	
replace mkunta_a17 = 22 if kunta_a17 ==	417	
replace mkunta_a17 = 22 if kunta_a17 ==	438	
replace mkunta_a17 = 22 if kunta_a17 ==	478	
replace mkunta_a17 = 22 if kunta_a17 ==	736	
replace mkunta_a17 = 22 if kunta_a17 ==	766	
replace mkunta_a17 = 22 if kunta_a17 ==	771	
replace mkunta_a17 = 22 if kunta_a17 ==	941	
replace mkunta_a17 = 200 if kunta_a17 == 200
replace mkunta_a17 = 999 if kunta_a17 == 999

label variable mkunta_a17 "numeric ego maakunta at age 17"

label define maakunta_age17 1 "Helsinki, Espoo, Vantaa, Kauniainen" 2 "Uusimaa" 3 "Varsinais-Suomi" 5 "Satakunta" 6 "Kanta-Häme" 7 "Pirkanmaa" 8 "Päijät-Häme" 9 "Kymenlaakso" 10 "Etelä-Karjala" 11 "Etelä-Savo" 12 "Pohjois-Savo" 13 "Pohjois-Karjala" 14 "Keski-Suomi" 15 "Etelä-Pohjanmaa" 16 "Pohjanmaa" 17 "Keski-Pohjanmaa" 18 "Pohjois-Pohjanmaa" 19 "Kainuu" 20 "Lappi" 22 "Ahvenanmaa" 23 "Ceded Areas" 200 "Abroad" 999 "Unknown"
label values mkunta_a17 maakunta_age17

save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop2.dta", replace  

*------------------------------------------------------------------------------*
* Second set of restrictions                                    	   
*------------------------------------------------------------------------------*
 
use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop2.dta", clear

gen age=year-byear

drop if  migyear1<1987 & migyear1!=.
drop if mig_indicator1==1
drop if mig_indicator2==0  & migyear2!=0

save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop3.dta", replace

*------------------------------------------------------------------------------*
*																			   *
* Variables                          		   
*																			   *
*------------------------------------------------------------------------------*

use "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop3.dta", clear

*------------------------------------------------------------------------------*
* Female                                       	   
*------------------------------------------------------------------------------*
 
label define female 0 "Male" 1 "Female", replace 
label values female female

*------------------------------------------------------------------------------*
* Educational attainment at age 19       
*------------------------------------------------------------------------------*

gen educ_19=0
replace educ_19=1 if educ_a19==1 
replace educ_19=2 if educ_a19==2 & matric_ex_a19==0
replace educ_19=3 if educ_a19==2 & matric_ex_a19==1
replace educ_19=3 if educ_a19==3

label define educ_19 1 "Primary educ. w/o matric.exam." 2 "Secondary educ. w/o matric.exam."  3 "Secondary educ. with matric.exam.", replace 
label values educ_19 educ_19

*------------------------------------------------------------------------------*
* Parental education level                                   	   
*------------------------------------------------------------------------------*

gen educ_parents=0
replace educ_parents=1 if educ_mom==1 & educ_dad==1 
replace educ_parents=1 if educ_mom==1 & educ_dad==. 
replace educ_parents=1 if educ_mom==. & educ_dad==1  

replace educ_parents=2 if educ_mom==2 & educ_dad<2 & educ_dad!=. 
replace educ_parents=2 if educ_dad==2 & educ_mom<2 & educ_mom!=. 

replace educ_parents=3 if educ_mom==2 & educ_dad==2 
replace educ_parents=3 if educ_mom==2 & educ_dad==. 
replace educ_parents=3 if educ_mom==. & educ_dad==2 

replace educ_parents=4 if educ_mom==3 & educ_dad<3 & educ_dad!=. 
replace educ_parents=4 if educ_dad==3 & educ_mom<3 & educ_mom!=. 

replace educ_parents=5 if educ_mom==3 & educ_dad==3 
replace educ_parents=5 if educ_mom==3 & educ_dad==.
replace educ_parents=5 if educ_mom==. & educ_dad==3 

replace educ_parents=9 if educ_mom==. & educ_dad==. 

label define educ_parents  1 "Both have primary educ."  2 "One has secondary educ." 3 "Both have secondary educ." 4 "One has tertiary educ." 5 "Both have tertiary educ." 9 "Both missing", replace 
label values educ_parents educ_parents 

*------------------------------------------------------------------------------*
* Parental employment                                  	  
*------------------------------------------------------------------------------*

gen employed_parents=0 
replace employed_parents=1 if employed_mom==0 & employed_dad==0
replace employed_parents=1 if employed_mom==0 & employed_dad==.
replace employed_parents=1 if employed_mom==. & employed_dad==0

replace employed_parents=2 if employed_mom==1 & employed_dad==0 
replace employed_parents=2 if employed_mom==0 & employed_dad==1 

replace employed_parents=3 if employed_mom==1  & employed_dad==1
replace employed_parents=3 if employed_mom==1 & employed_dad==.  
replace employed_parents=3 if employed_mom==. & employed_dad==1 

replace employed_parents=9 if employed_mom==. & employed_dad==. 

label define employed_parents  1 "Neither is employed"  2 "One is employed" 3 "Both are employed" 9 "Both missing" , replace 
label values employed_parents employed_parents 

*------------------------------------------------------------------------------*
* Parental income                                     	   
*------------------------------------------------------------------------------*

gen inc_mom2=inc_mom
replace inc_mom2=0 if inc_mom==. 
gen inc_dad2=inc_dad
replace inc_dad2=0 if inc_dad==. 

gen inc_parents=((inc_mom2 + inc_dad2)/2)  if employed_mom!=. & employed_dad!=. 
replace inc_parents=(inc_mom2) if  employed_dad==. & employed_mom!=. 
replace inc_parents=(inc_dad2)  if  employed_mom==. & employed_dad!=.  

xtile quarinc_parents=inc_parents, nq(4)
label define quarinc_parents  1 "Quartile 1 (bottom)"  2 "Quartile 2" 3 "Quartile 3" 4 "Quartile 4 (top)"  , replace 
label values quarinc_parents quarinc_parents 

*------------------------------------------------------------------------------*
* Single parent                                      	               
*------------------------------------------------------------------------------*

gen single_parent=0
replace single_parent=1 if single_mom==1 
replace single_parent=1 if single_dad==1 
label define single_parent 0 "Not single parent" 1 "Single parent"  , replace 
label values single_parent single_parent 

*------------------------------------------------------------------------------*
* Share swedes in municipality at age 17                   
*------------------------------------------------------------------------------*

gen dummy_sw_pop=.
replace dummy_sw_pop=0 if sw_pop_a17<50
replace dummy_sw_pop=1 if sw_pop_a17>=50

label define  dummy_sw_pop  0 "below 50% Swedish-speakers" 1 "50% and above Swedish-speakers" ,replace 
label values  dummy_sw_pop  dummy_sw_pop 

*------------------------------------------------------------------------------*
* Region at age 17                                                             *
*------------------------------------------------------------------------------*

recode mkunta_a17 (22=1 "Aland") (15/16=2 "Osterbotten/Nara Osterbotten") (4=3 "Egentliga Finland") (1/2=4 "Nyland") (3=7), into(geo_region)
replace geo_region=5 if geo_region>4
label def geo_region 1 "Aland" 2 "Osterbotten" 3 "Aboland" 4 "Nyland" 5 "Rest of Finland", replace 
label values geo_region geo_region

*------------------------------------------------------------------------------*
* Cohort categorical variable                                                  *
*------------------------------------------------------------------------------*

recode byear (1970/1974=1 "1970-74") (1975/1979=2 "1975-79") (1980/1984=3 "1980-84") (1985/1989=4 "1985-89") (1990/1994=5 "1990-94")(1995/2001=6 "1995-2001"), into (cohort)

*------------------------------------------------------------------------------*
*																		   	   *
* Event history variables for migration	             	                       *
*																			   *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* Ym_origin = year month birth+19                       
*------------------------------------------------------------------------------*

gen ORIGIN=byear+19

gen ym_origin=ym(ORIGIN, bmonth)
format ym_origin %tm

*------------------------------------------------------------------------------*
* Ym_kuolv = year month death if not missing                
*------------------------------------------------------------------------------*

gen ym_kuolv=ym(dyear, dmonth) if dyear!=.
format ym_kuolv %tm

*------------------------------------------------------------------------------*
*  Ym_emig = year month emig                              
*------------------------------------------------------------------------------*

gen ym_emig=ym(migyear1, migmonth1) if migyear1!=. 
format ym_emig %tm

save "path to data \syntyma_kuolema_mig_statuskunta_laspisuhde_info_parents_swpop4.dta", replace

*end do-file*
