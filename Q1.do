
* Download the file using a direct download link (change dl=0 to dl=1)
copy "https://www.dropbox.com/scl/fi/bgdq0bhp00ktdefn94e7d/UK_localauthorities_elections_austerity.dta?rlkey=bc4z8xeg9677n4g7rbmzygmo7&st=u24oby12&dl=1" "UK_localauthorities_elections_austerity.dta", replace

* Load the unzipped Stata dataset
use "UK_localauthorities_elections_austerity.dta", clear


* Preserve the original dataset
preserve

* Collapse the data to compute the mean of totalimpact_finlosswapyr by Region
collapse (mean) mean_totalimpact=totalimpact_finlosswapyr, by(Region)

* Sort the resulting dataset in ascending order by the mean_totalimpact
sort mean_totalimpact

* List the three regions with the lowest mean totalimpact_finlosswapyr
display "Three Regions with the Lowest Mean totalimpact_finlosswapyr:"
list Region mean_totalimpact in 1/3

* List the region with the highest mean totalimpact_finlosswapyr (last observation after sort)
display "Region with the Highest Mean totalimpact_finlosswapyr:"
list Region mean_totalimpact in -1

* Restore the original dataset
restore




* Preserve the original dataset so that you can restore it later if needed.
preserve

* Collapse the dataset by Region and year,
* calculating the mean of pct_votes_UKIP only for observations where pct_votes_UKIP > 0.
collapse (mean) mean_pct_votes_UKIP = pct_votes_UKIP if pct_votes_UKIP > 0, by(Region year)

* Sort the results by Region and year for clarity.
sort Region year

* Display the computed means.
list Region year mean_pct_votes_UKIP

* Restore the original dataset.
restore

gen level3orbelow = QUAL_ALL_lvl1_sh + QUAL_ALL_lvl2_sh + QUAL_ALL_lvl3_sh

* Collapse the data so that each observation represents a Region in a given year.
* Here we aggregate by computing the mean for each numeric variable.
collapse (mean) totalimpact_finlosswapyr pct_votes_UKIP CMiningAll_sh DManufAll_sh AAgricultureAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, by(Region year)

* Make the dataset a proper panel dataset
encode Region, gen(unit_id)
tsset unit_id year



*Drop regions with high austerity impact: North West, London, Scotland and Wales; keep only regions with mid- to low-austerity
drop if unit_id==5 | unit_id==3 | unit_id ==6 | unit_id== 9

*fill in data in regions with just one missing observation
sort Region year
by Region: replace pct_votes_UKIP = pct_votes_UKIP[_n-1] if missing(pct_votes_UKIP)

* Install synth package
ssc install synth 

synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(4) trperiod(2010) fig

gr_edit dta_file = ""
gr_edit .dta_date = ""
gr_edit .yaxis1.title.text = {}
gr_edit .yaxis1.title.text.Arrpush UKIP Vote Share
gr_edit .xaxis1.title.text = {}
gr_edit .xaxis1.title.text.Arrpush Year




	
************ PLACEBO TEST(S) *****************


*setting treatment year to 2005
synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(4) trperiod(2005) fig


 
*setting treated unit equal to South West (UK)
synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(8) trperiod(2009) fig



************ LEAVE ONE OUT TEST(S) *****************


* dropping Yorkshire from the donor pool to see if predictions were overly reliant on Yorkshire
preserve 

drop if unit_id==11

synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(4) trperiod(2009) fig

restore 


* dropping East Midlands from the donor pool to see if predictions were overly reliant on East Midlands
preserve 

drop if unit_id==2

synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(4) trperiod(2009) fig

restore


	
* dropping both East Midlands and Yorkshire from the donor pool to see if predictions were overly reliant on them
preserve 

drop if unit_id==2 | unit_id==11

synth pct_votes_UKIP  DManufAll_sh AAgricultureAll_sh CMiningAll_sh FConstrAll_sh level3orbelow QUAL_ALL_lvl4_plus_sh AgeAbove60UKshare, trunit(4) trperiod(2009) fig

restore


