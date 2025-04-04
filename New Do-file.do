
 
 
 
 ********** EXTERNAL ESS DATATSET ************
 
 
 
 
 
 *maybe improve synthetic control by adding more donor units. for example, use combined ESS dataset for data on regions in France and Germany. create a common variable to indicate the average level of support for extremist parties for each region and for each year. keep also variables related to austerity measures (if they were enacted during that period in DE and FR) and variables that are very similar to the predictors used for UK. finally combine the datasets and unify the variable names and compute the synthetic control analysis
 
 *note that the regions in the ESS dataset are comparable to the regions in the Fetzer UK dataset, since the ESS uses NUTS (an EU geocode standard) for its regions, and the Fetzer regions correspond roughly to the UK's NUTS regions.
 


* Download the ZIP file from the internet and save it locally as "ESS.dta.zip"
copy "https://www.dropbox.com/scl/fi/g98b5spe5deb5zib27li5/ESS.dta.zip?rlkey=s5dgxychbal0nbpjf9ue9zf83&st=w16j1ic6&dl=1" "ESS.dta.zip", replace

* Unzip the file (this extracts ESS.dta into the current working directory)
unzipfile "ESS.dta.zip", replace

* Load the unzipped Stata dataset
use "Combined dataset.dta", clear


keep if cntry=="BE" | cntry =="FR"
 
*we need to see whether the interviews always ended in the same year as they started. 
pwcorr inwyye inwyys
*it turns out they are perfectly correlated and inwyye inwyr are interchangeable. So we can use inwyr to fill in missing values in inwyye

*one data set, so that the regression for years work
replace inwyye=inwyr if inwyr<=2005

* renaming to year for convenience
rename inwyye year

drop if missing(year)

***** FOR GERMANY *******




			* Convert the numeric variable regionde (which has a value label) to a string variable
			capture decode regionde, gen(regiondename)


			* Now update the missing NUTS‑1 codes for pre‑2010 German observations using regiondename
			capture replace region = "DE1" if year < 2010 & region == "" & regiondename == "Baden-Württemberg"
			capture replace region = "DE2" if year < 2010 & region == "" & regiondename == "Bayern"
			capture replace region = "DE3" if year < 2010 & region == "" & regiondename == "Berlin"
			capture replace region = "DE4" if year < 2010 & region == "" & regiondename == "Brandenburg"
			capture replace region = "DE5" if year < 2010 & region == "" & regiondename == "Bremen"
			capture replace region = "DE6" if year < 2010 & region == "" & regiondename == "Hamburg"
			capture replace region = "DE7" if year < 2010 & region == "" & regiondename == "Hessen"
			capture replace region = "DE8" if year < 2010 & region == "" & regiondename == "Mecklenburg-Vorpommern"
			capture replace region = "DE9" if year < 2010 & region == "" & regiondename == "Niedersachsen"
			capture replace region = "DEA" if year < 2010 & region == "" & regiondename == "Nordrhein-Westfalen"
			capture replace region = "DEB" if year < 2010 & region == "" & regiondename == "Rheinland-Pfalz"
			capture replace region = "DEC" if year < 2010 & region == "" & regiondename == "Saarland"
			capture replace region = "DED" if year < 2010 & region == "" & regiondename == "Sachsen"
			capture replace region = "DEE" if year < 2010 & region == "" & regiondename == "Sachsen-Anhalt"
			capture replace region = "DEF" if year < 2010 & region == "" & regiondename == "Schleswig-Holstein"
			capture replace region = "DEG" if year < 2010 & region == "" & regiondename == "Thüringen"



			
			

			
******** FOR BELGIUM *********


* Convert the numeric variable regionde (with value labels) to a string variable
decode regionbe, gen(regionbename)

* Ensure region is a string variable so that you can assign codes like "DE1"
capture tostring region, replace

* Update missing NUTS‑1 codes for pre‑2010 Belgian observations using regiondename
replace region = "BE2" if region == "" & regionbename == "Flemish region"
replace region = "BE1" if region == "" & regionbename == "Brussels region"
replace region = "BE3" if region == "" & regionbename == "Walloon region"



* Convert Belgian NUTS‑2 codes to the three Belgian NUTS‑1 codes

replace region = "BE1" if inlist(region, "BE10", "BE11")
replace region = "BE2" if inlist(region, "BE20", "BE21", "BE22", "BE23", "BE24", "BE25")
replace region = "BE3" if inlist(region, "BE30", "BE31", "BE32", "BE33", "BE34", "BE35")



******** FOR FRANCE ********


* Convert the numeric variable regionfr (which has a value label) to a string variable
decode regionfr, gen(regionfrname)


* Step 1: Change regionfr to "Bassin Parisien Est" under the specified condition.
replace regionfrname = "Bassin Parisien Est" if year < 2010 & regionfrname == "Bassin Parisien Ouest"

* Step 2: Rename the value "Bassin Parisien Est" to "Bassin Parisien".
replace regionfrname = "Bassin Parisien" if regionfrname == "Bassin Parisien Est"

*    mapping ESS2 regionfrname to the desired "FRx" codes
replace region = "FR1" if year < 2010 & region == "" & regionfrname == "Région parisienne"
replace region = "FR2" if year < 2010 & region == "" & regionfrname == "Bassin Parisien"
replace region = "FR3" if year < 2010 & region == "" & (regionfrname == "Nord - Pas-de-Calais" | regionfrname == "Nord")
replace region = "FR4" if year < 2010 & region == "" & regionfrname == "Est"
replace region = "FR5" if year < 2010 & region == "" & regionfrname == "Ouest"
replace region = "FR6" if year < 2010 & region == "" & regionfrname == "Sud Ouest"
replace region = "FR7" if year < 2010 & region == "" & (regionfrname == "Centre-Est" | regionfrname == "Sud Est")
replace region = "FR8" if year < 2010 & region == "" & regionfrname == "Méditerranée"




* Replace region with the specified new value if it has the specified old value
replace region = "FR24" if region == "FRB0"
replace region = "FR26" if region == "FRC1"
replace region = "FR43" if region == "FRC2"
replace region = "FR25" if region == "FRD1"
replace region = "FR23" if region == "FRD2"
replace region = "FR30" if region == "FRE1"
replace region = "FR22" if region == "FRE2"
replace region = "FR42" if region == "FRF1"
replace region = "FR21" if region == "FRF2"
replace region = "FR41" if region == "FRF3"
replace region = "FR51" if region == "FRG0"
replace region = "FR52" if region == "FRH0"
replace region = "FR61" if region == "FRI1"
replace region = "FR63" if region == "FRI2"
replace region = "FR53" if region == "FRI3"
replace region = "FR81" if region == "FRJ1"
replace region = "FR62" if region == "FRJ2"
replace region = "FR72" if region == "FRK1"
replace region = "FR71" if region == "FRK2"
replace region = "FR82" if region == "FRL0"
replace region = "FR83" if region == "FRM0"
replace region = "FRA1" if region == "FRY1"
replace region = "FRA2" if region == "FRY2"
replace region = "FRA3" if region == "FRY3"
replace region = "FRA4" if region == "FRY4"
replace region = "FRA5" if region == "FRY5"



*replace NUTS 2 code with NUTS 1 code
replace region = "FR1" if year >= 2010 & region == "FR10"
replace region = "FR2" if year >= 2010 & ( region == "FR20" | region == "FR21" | region == "FR22")
replace region = "FR2" if year >= 2010 & (region == "FR23" | region == "FR24" | region == "FR25" | region == "FR26")
replace region = "FR3" if year >= 2010 & (region == "FR30")
replace region = "FR4" if year >= 2010 & (region == "FR40" | region == "FR41" | region == "FR42" | region == "FR43")
replace region = "FR5" if year >= 2010 & (region == "FR50" | region == "FR51" | region == "FR52" | region == "FR53" | region == "FR54")
replace region = "FR6" if year >= 2010 & (region == "FR60" | region == "FR61" | region == "FR62" | region == "FR63")
replace region = "FR7" if year >= 2010 & (region == "FR70" | region == "FR71" | region == "FR72" | region == "FR73")
replace region = "FR8" if year >= 2010 & (region == "FR80" | region == "FR81" | region == "FR82" | region == "FR83")




*compute an average far-right party vote share for every region in each year.


capture drop farright
capture drop avg_farright

* Create indicator variable for far-right vote (Vlaams Belang/Vlaams Blok or Front National)
gen farright = 0
replace farright = 1 if prtclbe == 8 | prtclabe == 8 | prtclbbe == 8 | ///
                        prtclcbe == 7 | prtcldbe == 7 | prtclebe == 6 | ///
                        prtclfr == 3 | prtclafr == 2 | prtclbfr == 2 | ///
                        prtclcfr == 1 | prtcldfr == 2 | prtclefr == 2 | ///
                        prtclffr == 11 

* Calculate the share of far-right votes by region and year
bysort region year: egen avg_farright = mean(farright)
replace avg_farright = avg_farright*100


* create an variable for the share of people with a level 4 or higher qualification per region



* Check the value label name attached to edulvlb
describe eisced

* If the attached value label has the same name (e.g., edulvlb), list its values and labels
label list eisced

* Create a binary variable equal to 1 if edulvlb is level 4 or above

gen level4plus = 0
replace level4plus = 1 if eisced==4 | eisced==5 | eisced==6 | eisced==7

* Optional: display the frequency table of the new variable
tab level4plus, missing


* Calculate the share of people with level 4 or higher qualifications by region and year
bysort region year: egen avg_level4plus = mean(level4plus)




* create an variable for the share of people with level 1 or 2 qualifications per region

gen level3orbelow = 0
replace level3orbelow = 1 if eisced==1 | eisced==2 | eisced==3
tab level3orbelow


* Calculate the share of people with level 1 or 2 qualifications by region and year
bysort region year: egen avg_level3orbelow = mean(level3orbelow)




* Create a binary variable equal to 1 if employed in manufacturing (nacer1 between 15 and 37)
gen manuf = 0
replace manuf = 1 if inrange(nacer1, 15, 36) | inrange(nacer11, 15, 36) | inrange(nacer2, 10, 32)

* Optional: check the frequency distribution of manuf
tab manuf, missing


* Calculate the share of people in manufacturing by region and year
bysort region year: egen avg_manuf = mean(manuf)





*Plus, do the same for the average turnout for each region and year

gen turnedup = 0 if vote!=3
replace turnedup = 1 if vote==1

bysort region year: egen turnout = mean(turnedup)
replace turnout = turnout*100





************* APPENDING THE UK DATASET ********************







* Download the file using a direct download link (change dl=0 to dl=1)
copy "https://www.dropbox.com/scl/fi/bgdq0bhp00ktdefn94e7d/UK_localauthorities_elections_austerity.dta?rlkey=bc4z8xeg9677n4g7rbmzygmo7&st=u24oby12&dl=1" "UK_localauthorities_elections_austerity.dta", replace

* Append the downloaded dataset to the current dataset
append using "UK_localauthorities_elections_austerity.dta"


*make sure the following commands don't fill any gaps in the ESS data. so check if ESS data has gaps
count if missing(avg_manuf) & (cntry=="BE" | cntry=="FR") 

* Update turnout variable
replace turnout = pct_turnout if missing(turnout)

* Update manufacturing variable
replace avg_manuf = DManufAll_sh if missing(avg_manuf)

* Update level4plus variable
replace avg_level4plus = QUAL_ALL_lvl4_plus_sh if missing(avg_level4plus)

* Update far-right variable
replace avg_farright = pct_votes_UKIP if missing(avg_farright)


* Update region variable
replace region = Region if missing(region)


* Update region variable
replace regionbename = regionfrname if missing(regionbename)
replace Region = regionbename if missing(Region)


* Update avg_level3orbelow variable with the sum of QUAL_ALL_lvl1_sh and QUAL_ALL_lvl2_sh if missing
replace avg_level3orbelow = (QUAL_ALL_lvl1_sh + QUAL_ALL_lvl2_sh + QUAL_ALL_lvl3_sh) if missing(avg_level3orbelow)










************* SYNTHETIC CONTROL FOR Q1 ***************






* Collapse the data so that each observation represents a region in a given year.
* Here we aggregate by computing the mean for each numeric variable.
collapse (mean) totalimpact_finlosswapyr avg_manuf avg_level3orbelow avg_level4plus avg_farright turnout, by(region year)

* Make the dataset a proper panel dataset
encode region, gen(unit_id)
tsset unit_id year

* Drop regions with too much missing election data: London, Scotland and Wales
drop if region=="London" | region=="Wales" | region=="Scotland"

*(controversial) Drop region with second highest austerity: North West; keep only regions with mid- to low-austerity
drop if region=="North West"

replace unit_id = 25 if region=="North East"
label define unit_id 25 "North East", modify
label values unit_id unit_id
* For "Région parisienne" (assumed to be coded as FR1)
replace unit_id = 30 if region == "FR1"
label define unit_id 30 "Région parisienne", modify
label values unit_id unit_id
* For "Bassin Parisien" (coded as FR2)
replace unit_id = 31 if region == "FR2"
label define unit_id 31 "Bassin Parisien", modify
* For "Nord - Pas-de-Calais / Nord" (coded as FR3)
replace unit_id = 32 if region == "FR3"
label define unit_id 32 "Nord", modify
* For "Est" (coded as FR4)
replace unit_id = 33 if region == "FR4"
label define unit_id 33 "Est", modify
* For "Ouest" (coded as FR5)
replace unit_id = 34 if region == "FR5"
label define unit_id 34 "Ouest", modify
* For "Sud Ouest / Sud Est" (coded as FR6)
replace unit_id = 35 if region == "FR6"
label define unit_id 35 "Sud Ouest", modify
* For "Centre-Est" (coded as FR7)
replace unit_id = 36 if region == "FR7"
label define unit_id 36 "Centre-Est", modify
* For "Méditerranée" (coded as FR8)
replace unit_id = 37 if region == "FR8"
label define unit_id 37 "Méditerranée", modify
replace unit_id = 40 if region == "BE2"
label define unit_id 40 "Flemish region", modify
replace unit_id = 41 if region == "BE1"
label define unit_id 41 "Brussels region", modify
replace unit_id = 42 if region == "BE3"
label define unit_id 42 "Walloon region", modify
label value unit_id unit_id


*drop Walloon region and Brussels region
drop if unit_id==42 | unit_id==41


* Fill in data in regions with just one missing observation
sort region year
replace avg_farright = avg_farright[_n-1] if missing(avg_farright)
by region: replace avg_farright = avg_farright[_n-1] if avg_farright==0
forvalues i = 1/2 {
    by region: replace avg_farright = avg_farright[_n+1] if missing(avg_farright)
}



drop if missing(unit_id)

synth avg_farright avg_farright(2004) avg_farright(2005) avg_farright(2006) avg_farright(2007) ///
      avg_farright(2008) avg_farright(2009) avg_farright(2010) avg_farright(2011) /// 
	  avg_manuf avg_level3orbelow avg_level4plus, trunit(25) trperiod(2012) fig


	  
	  
	  
**** stuff left to do: 
* - try applying lowess to every remaining variable (if it doesn't work, group the predictor variables by three and substitute each of their observation with the three-year mean)
* - create predictor variables also for % working agriculture and % working construction and % working mining 
* - create observations for France and Belgium in 2000 and 2001 and assign them the value of 2003
* - create an observation for France in 2012 and belgium in 2013
