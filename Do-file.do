
* List 10 highest values
gsort -totalimpact_finlosswapyr
list Local_Authority totalimpact_finlosswapyr in 1/160

*blackpool is most affected local authority

* List 10 lowest values
gsort totalimpact_finlosswapyr
list Local_Authority totalimpact_finlosswapyr in 1/160 

*least affected: City of London, Hart, Cambridge, Wokingham, South Oxfordshire, Rutland, South Northamptonshire, Guildford, South Bucks, Chiltern, Winchester


preserve 

*keep only most and least affected Local_Authorities
keep if inlist(Local_Authority, "Hart", "Cambridge", "Wokingham", "South Oxfordshire", "Rutland", "South Northamptonshire", ///
"Guildford", "South Bucks", "Chiltern") ///
    | Local_Authority == "Blackpool" | Local_Authority == "Winchester"

*re-index the time variable
egen time_index = group(year) if !missing(UKIPPct)


* Make the dataset a proper panel dataset
encode Local_Authority, gen(unit_id)
tsset unit_id time_index


* Install synth package
ssc install synth 

* blackpool is unit 1
synth UKIPPct AgeAbove60UKshare DManufAll_sh FConstrAll_sh AAgricultureAll_sh QUAL_ALL_lvl4_plus_sh, trunit(1) trperiod(2) fig
