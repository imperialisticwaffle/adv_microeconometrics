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
/* gen tr_and_donor = ("Blackpool", "City of London", "Hart", "Cambridge", "Wokingham", "South Oxfordshire", "Rutland" "South Northamptonshire", "Guildford", "South Bucks", "Chiltern", "Winchester", "South Cambridgeshire", "Mole Valley", "Surrey Heath", "Harborough", "Horsham", "Cotswold", "Waverley", "East Hampshire", "Mid Sussex") */

gen flag_keep = 0
replace flag_keep = 1 if Local_Authority == "Blackpool"
replace flag_keep = 1 if Local_Authority == "City of London"
replace flag_keep = 1 if Local_Authority == "Hart"
replace flag_keep = 1 if Local_Authority == "Cambridge"
replace flag_keep = 1 if Local_Authority == "Wokingham"
replace flag_keep = 1 if Local_Authority == "South Oxfordshire"
replace flag_keep = 1 if Local_Authority == "Rutland"
replace flag_keep = 1 if Local_Authority == "South Northamptonshire"
replace flag_keep = 1 if Local_Authority == "Guildford"
replace flag_keep = 1 if Local_Authority == "South Bucks"
replace flag_keep = 1 if Local_Authority == "Chiltern"
replace flag_keep = 1 if Local_Authority == "Winchester"
replace flag_keep = 1 if Local_Authority == "South Cambridgeshire"
replace flag_keep = 1 if Local_Authority == "Mole Valley"
replace flag_keep = 1 if Local_Authority == "Surrey Heath"
replace flag_keep = 1 if Local_Authority == "Harborough"
replace flag_keep = 1 if Local_Authority == "Horsham"
replace flag_keep = 1 if Local_Authority == "Cotswold"
replace flag_keep = 1 if Local_Authority == "Waverley"
replace flag_keep = 1 if Local_Authority == "East Hampshire"
replace flag_keep = 1 if Local_Authority == "Mid Sussex"

keep if flag_keep == 1

*re-index the time variable; creating a year index for all currently kept boroughs based on year of EU parliament election
egen time_index = group(year) if !missing(UKIPPct)
replace time_index = 2004 if time_index == 1
replace time_index = 2009 if time_index == 2
replace time_index = 2014 if time_index == 3


* Make the dataset a proper panel dataset
encode Local_Authority, gen(unit_id)
tsset unit_id time_index




* Install synth package
ssc install synth 

* blackpool is unit 1
* predictors as % share above 60, % working in manufacturing (flatlined from 2001), % working in construction, % working in agriculture (flatlined from 2001)
* this is effectively saying the treatment period is 2009 not 2010
synth UKIPPct AgeAbove60UKshare DManufAll_sh FConstrAll_sh AAgricultureAll_sh ///
QUAL_ALL_lvl4_plus_sh, trunit(1) trperiod(2009) fig

* list Local_Authority DManufAll_sh if Local_Authority == "City of London" 
* list Local_Authority FConstrAll_sh if Local_Authority == "City of London" 


* clear time index and panel dataset for setup in next synthetic control below
drop time_index unit_id
xtset, clear


preserve

* adjusting to include EP 1999 results
clear
input str28 Local_Authority double year double UKIPPct float DManufAll_sh float FConstrAll_sh
"Blackpool" 1999 7.74 .1166602  .0620799 
"Hart" 1999 9.8 .1082881 .0594519
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
"South Cambridgeshire" 1999 7.3 .1481203 .061524
"Mole Valley" 1999 9.5 .0880746 .0723698
"Surrey Heath" 1999 10.8 .1082661 .0572662
"Harborough" 1999 7.9 .186095 .0628187
"Horsham" 1999 11.3 .1174432 .0669446
"Cotswold" 1999 10.1 .1346418 .0713049
"Waverley" 1999 10.1 .0925098 .0687662
"East Hampshire" 1999 8.4 .1334797 .0691983
"Mid Sussex" 1999 10.2 .1026861 .064256
end

save temp_1999.dta, replace

restore

* adding to main dataset
append using temp_1999.dta

* sort by local authority to enable easier flatlining of chosen predictors
sort Local_Authority

*re-index the time variable; creating a year index for all currently kept boroughs based on year of EU parliament election
egen time_index = group(year) if !missing(UKIPPct)
replace time_index = 1999 if time_index == 1
replace time_index = 2004 if time_index == 2
replace time_index = 2009 if time_index == 3
replace time_index = 2014 if time_index == 4

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

* running synthetic control - blackpool as treatment unit
synth UKIPPct UKIPPct(2009) UKIPPct(2004) AgeAbove60UKshare DManufAll_sh FConstrAll_sh AAgricultureAll_sh ///
QUAL_ALL_lvl4_plus_sh, trunit(1) trperiod(2009) fig


* agriculture and level4+ qualification predictors are relatively inaccurate in the synthetic - experimenting below with different predictors

synth UKIPPct AgeBet30to60UKshare DManufAll_sh FConstrAll_sh  ///
QUAL_ALL_lvl3_sh QUAL_ALL_lvl2_sh QUAL_ALL_lvl1_sh, trunit(1) trperiod(2009) fig
