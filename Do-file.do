
 
 
 
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


			

			
******** FOR BELGIUM *********


* Convert the numeric variable regionde (with value labels) to a string variable
decode regionbe, gen(regionbename)

* Ensure region is a string variable so that you can assign codes like "DE1"
			tostring region, replace


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
replace region = "FR6" if year < 2010 & region == "" & (regionfrname == "Sud Ouest" | regionfrname == "Sud Est")
replace region = "FR7" if year < 2010 & region == "" & regionfrname == "Centre-Est"
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




*compute an average far-right party vote share for every region in each year. Plus, do the same for the average turnout for each region and year


