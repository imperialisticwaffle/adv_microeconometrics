
*alternatively consider broad regions e.g. North England and see how welfare impacted its gdp (or UKIP vote share)

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



* Collapse the data so that each observation represents a Region in a given year.
* Here we aggregate by computing the mean for each numeric variable.
collapse (mean) totalimpact_finlosswapyr pct_votes_UKIP, by(Region year)

* Make the dataset a proper panel dataset
encode Region, gen(unit_id)
tsset unit_id year

*drop regions with too much missing election data: London, Scotland and Wales
drop if unit_id==3 | unit_id ==6 | unit_id== 9

preserve 

*(controversial) drop region with second highest austerity: North West; keep only regions with mid- to low-austerity
drop if unit_id==5

*fill in data in regions with just one missing observation
replace pct_votes_UKIP=0 if missing(pct_votes_UKIP)


synth pct_votes_UKIP pct_votes_UKIP(2000) pct_votes_UKIP(2001) pct_votes_UKIP(2002) pct_votes_UKIP(2003) ///
 pct_votes_UKIP(2004) pct_votes_UKIP(2005) pct_votes_UKIP(2006) pct_votes_UKIP(2007) ///
 pct_votes_UKIP(2008) pct_votes_UKIP(2009) pct_votes_UKIP(2010) pct_votes_UKIP(2011), trunit(4) trperiod(2012) fig
