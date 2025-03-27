
* Make the dataset a proper panel dataset
tsset code year

* For each district, compute the first year with UKIP participation (ukip_election==1)
bys code: egen first_ukip_year = min(cond(ukip_election==1, year, .))

* Create a new variable that equals 1 if this observation is the first year UKIP appears
gen first_ukip = (year == first_ukip_year) & (ukip_election == 1)


*see in what year UKIP started participating in the most constitutencies
tab first_ukip year

keep if first_ukip_year == 2003 | code == "E09000001"

drop if district_election_dummy == 0

drop if inlist(code, "N09000001", "N09000002", "N09000003", "N09000004", ///
                   "N09000005", "N09000006", "N09000007", "N09000008")
				   
drop if inlist(code, "N09000009", "N09000010", "N09000011")

drop if Region == "Scotland"

* Install synth package
ssc install synth 

synth pct_votes_Con ///
    pct_votes_Con ///
    JFinancialAll_sh ///
	LLTunemployedAll_sh ///
    QUAL_ALL_lvl4_plus_sh ///
    welfaresocialprotectionpercapitalpercapita, ///
    trunit(3) trperiod(2007) fig


# comment test
