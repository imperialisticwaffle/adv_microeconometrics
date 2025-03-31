
preserve 

*keep only most and least affected Local_Authorities
keep if inlist(Local_Authority, "Hart", "Cambridge", "Wokingham", "South Oxfordshire", "Rutland", "South Northamptonshire", ///
"Guildford", "South Bucks", "Chiltern") ///
    | Local_Authority == "Blackpool" | Local_Authority == "Winchester"

*re-index the time variable
egen time_index = group(year)


* Make the dataset a proper panel dataset
encode Local_Authority, gen(unit_id)
tsset unit_id time_index


* Install synth package
ssc install synth 

* blackpool is unit 1
synth UKIPPct totalimpact_finlosswapyr, trunit(1) trperiod(2) fig
