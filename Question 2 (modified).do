* Download the file using a direct download link (change dl=0 to dl=1)
copy "https://www.dropbox.com/scl/fi/bgdq0bhp00ktdefn94e7d/UK_localauthorities_elections_austerity.dta?rlkey=bc4z8xeg9677n4g7rbmzygmo7&st=u24oby12&dl=1" "UK_localauthorities_elections_austerity.dta", replace

* Load the unzipped Stata dataset
use "UK_localauthorities_elections_austerity.dta", clear



* List 10 highest values
gsort -totalimpact_finlosswapyr
list Local_Authority totalimpact_finlosswapyr in 1/160

*blackpool is most affected local authority

* List 20 lowest values
gsort totalimpact_finlosswapyr
list Local_Authority totalimpact_finlosswapyr in 1/320 

*least affected (bottom 10): City of London, Hart, Cambridge, Wokingham, South Oxfordshire, Rutland, South Northamptonshire, Guildford, South Bucks, Chiltern, Winchester

*incl. up to bottom 20 most austere regions, we also have: South Cambridgeshire, Mole Valley, Surrey Heath, Harborough, Horsham, Cotswold, Waverley, East Hampshire, Mid Sussex


*keep only most and least affected Local_Authorities
/* gen tr_and_donor = ("Blackpool", "City of London", "Hart", "Cambridge", "Wokingham", "South Oxfordshire", "Rutland" "South Northamptonshire", "Guildford", "South Bucks", "Chiltern", "Winchester", "South Cambridgeshire", "Mole Valley", "Surrey Heath", "Harborough", "Horsham", "Cotswold", "Waverley", "East Hampshire", "Mid Sussex")

keep in inlist(Local_Authority, tr_and_donor) */

keep if inlist(Local_Authority, "Hart", "Cambridge", "Wokingham", "South Oxfordshire", "Rutland", "South Northamptonshire", ///
"Guildford", "South Bucks", "Chiltern") ///
    | Local_Authority == "Blackpool" | Local_Authority == "Winchester" | Local_Authority == "City of London"
	




* Install synth package
ssc install synth 

* blackpool is unit 1
* predictors as % share above 60, % working in manufacturing (flatlined from 2001), % working in construction, % working in agriculture (flatlined from 2001)
* this is effectively saying the treatment period is 2009 not 2010
*synth UKIPPct AgeAbove60UKshare DManufAll_sh FConstrAll_sh AAgricultureAll_sh ///
QUAL_ALL_lvl4_plus_sh, trunit(1) trperiod(2) fig

* list Local_Authority DManufAll_sh if Local_Authority == "City of London" 
* list Local_Authority FConstrAll_sh if Local_Authority == "City of London" 

preserve

* adjusting to include EP 1999 results
clear
input str28 Local_Authority double year double UKIPPct float DManufAll_sh float FConstrAll_sh
"Blackpool" 1999 7.74 .1166602  .0620799 
"City of London" 1999 4.1 .0535246 .0185774 
"Cambridge" 1999 5.2 .100392 .0401933
"Wokingham" 1999 7.8 .1093614 .0556957
"South Oxfordshire" 1999 8.7 .119632 .0669933
"Rutland" 1999 8.9 .1720664 .0579789
"South Northamptonshire" 1999 8.4 .1760053 .0675518
"Guildford" 1999 9.6 .0887346 .0637118
"South Bucks" 1999 10.9 .1307161 .0612597
"Chiltern" 1999 10.2 .1313977 .0561211
"Winchester" 1999 7.9 .0951934 .0626055
end

save temp_1999.dta, replace

restore

* adding to main dataset
append using temp_1999.dta

* sort by local authority to enable easier flatlining of chosen predictors
sort Local_Authority

*re-index the time variable; creating a year index for all currently kept boroughs based on year of EU parliament election
egen time_index = group(year) if !missing(UKIPPct)

* Make the dataset a proper panel dataset
encode Local_Authority, gen(unit_id)
tsset unit_id time_index

* flatlining
replace AgeAbove60UKshare = AgeAbove60UKshare[_n+1] if missing(AgeAbove60UKshare)
replace AAgricultureAll_sh = AAgricultureAll_sh[_n+1] if missing(AAgricultureAll_sh)
replace QUAL_ALL_lvl4_plus_sh = QUAL_ALL_lvl4_plus_sh[_n+1] if missing(QUAL_ALL_lvl4_plus_sh)
replace AgeBet30to60UKshare = AgeBet30to60UKshare[_n+1] if missing(AgeBet30to60UKshare)
replace RoutineOccUKShareWithin = RoutineOccUKShareWithin[_n+1] if missing(RoutineOccUKShareWithin)
replace QUAL_ALL_lvl1_sh = QUAL_ALL_lvl1_sh[_n+1] if missing(QUAL_ALL_lvl1_sh)
replace QUAL_ALL_lvl2_sh = QUAL_ALL_lvl2_sh[_n+1] if missing(QUAL_ALL_lvl2_sh)
replace QUAL_ALL_lvl3_sh = QUAL_ALL_lvl3_sh[_n+1] if missing(QUAL_ALL_lvl3_sh)

*remove the below command as soon as you have data on Hart and changed the input command above accordingly
drop if Local_Authority=="Hart"

* running synthetic control - blackpool as treatment unit is id 26
synth UKIPPct UKIPPct(3) UKIPPct(2) AgeAbove60UKshare DManufAll_sh FConstrAll_sh AAgricultureAll_sh ///
QUAL_ALL_lvl4_plus_sh, trunit(1) trperiod(3) fig


* agriculture and level4+ qualification predictors are relatively inaccurate in the synthetic - experimenting below with different predictors

 synth UKIPPct AgeBet30to60UKshare DManufAll_sh FConstrAll_sh RoutineOccUKShareWithin ///
QUAL_ALL_lvl3_sh QUAL_ALL_lvl2_sh QUAL_ALL_lvl1_sh, trunit(1) trperiod(3) fig
/* synth UKIPPct AgeBet30to60UKshare DManufAll_sh FConstrAll_sh RoutineOccUKShareWithin ///
QUAL_ALL_lvl3_sh QUAL_ALL_lvl2_sh QUAL_ALL_lvl1_sh, trunit(1) trperiod(2) fig */
