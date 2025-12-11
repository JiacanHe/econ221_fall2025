//////////////////////////////Analysis12.1
///////Analysis//////

//unified id

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1130.dta", clear

keep city_std
duplicates drop
sort city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_crosswalk000.dta", replace



//Macro First Stage Z on X
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1130.dta", clear

merge m:1 city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_crosswalk000.dta", gen(_m1)
tab _m1   // all 3

order fid10 year prov_std city_std citycode labor_force lnCity_HP unemp_rate slack_prov exposure_inv exposure_inv_share post rugged_z 市城镇私营和个体从业人员数人 市年末城镇登记失业人员数人 市城镇非私营单位就业人员数万人 employed_numbers unemployed_numbers 农林牧渔业从业人员数万人 采掘业从业人员数万人 制造业从业人员数万人 第一产业从业人员比重 第二产业从业人员比重 第三产业从业人员比重 电力煤气及水生产供应业从业人员数万人 建筑业从业人员数万人 交通仓储邮电业从业人员数万人 信息传输计算机服务和软件业从业人员数万人 批发零售贸易业从业人员数万人 住宿餐饮业从业人员数万人 金融业从业人员数万人 房地产业从业人员数万人 租赁和商业服务业从业人员数万人 科研技术服务和地质勘查业从业人员数万人 水利环境和公共设施管理业从业人员数万人 居民服务和其他服务业从业人员数万人 教育业从业人员数万人 卫生社会保险和社会福利业从业人员数万人 文化体育和娱乐业从业人员数万人 公共管理和社会组织从业人员数万人

destring 市城镇私营和个体从业人员数人, replace force
destring 市年末城镇登记失业人员数人, replace force
destring 市城镇非私营单位就业人员数万人, replace force



*gen nation HP changing index & shock iv
collapse (mean) lnCity_HP lnGDP urbanization lnpopdens slack_prov unemp_rate labor_force post exposure_inv exposure_inv_share exposure_inv_share_Avg rugged_z ///
房地产开发投资完成额万元 地区生产总值万元 市城镇私营和个体从业人员数人 ///
市年末城镇登记失业人员数人 市城镇非私营单位就业人员数万人 ///
employed_numbers unemployed_numbers 农林牧渔业从业人员数万人 ///
采掘业从业人员数万人 制造业从业人员数万人 第一产业从业人员比重 ///
第二产业从业人员比重 第三产业从业人员比重 电力煤气及水生产供应业从业人员数万人 ///
建筑业从业人员数万人 交通仓储邮电业从业人员数万人 信息传输计算机服务和软件业从业人员数万人 ///
批发零售贸易业从业人员数万人 住宿餐饮业从业人员数万人 金融业从业人员数万人 ///
房地产业从业人员数万人 租赁和商业服务业从业人员数万人 ///
科研技术服务和地质勘查业从业人员数万人 水利环境和公共设施管理业从业人员数万人 ///
居民服务和其他服务业从业人员数万人 教育业从业人员数万人 ///
卫生社会保险和社会福利业从业人员数万人 文化体育和娱乐业从业人员数万人 ///
公共管理和社会组织从业人员数万人 , ///
by(city_std year)


*merge with city_vacancies(collapsed)
merge 1:1 city_std year using"C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_year_vacancies.dta"

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_panel_clean.dta", replace

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_panel_clean.dta", clear

**set panel & gen nation HP index  & IV shock
encode city_std, gen(city_id)
destring year, replace
xtset city_id year
sort year city_id
by year: egen nat_hp = mean(lnCity_HP)

sort city_id year      
gen d_nat_hp = nat_hp - L.nat_hp
label var d_nat_hp "Nationwide HP change"

gen d_nat_hp_neg = -d_nat_hp

*****************controls
bys city_id: egen GDP_pre_raw     = mean(lnGDP)        if inrange(year,2016,2019)
bys city_id: egen Urban_pre_raw   = mean(urbanization) if inrange(year,2016,2019)
bys city_id: egen Popdens_pre_raw = mean(lnpopdens)    if inrange(year,2016,2019)

* Extend baseline to all years (never creates missing incorrectly)
bys city_id: egen GDP_pre     = mean(GDP_pre_raw)
bys city_id: egen Urban_pre   = mean(Urban_pre_raw)
bys city_id: egen Popdens_pre = mean(Popdens_pre_raw)

drop GDP_pre_raw Urban_pre_raw Popdens_pre_raw


gen GDP_pre_Post = GDP_pre * post
gen Urban_pre_Post = Urban_pre * post
gen Popdens_pre_Post = Popdens_pre * post


gen GDP_pre_year = GDP_pre * year
gen Urban_pre_year = Urban_pre * year
gen Popdens_pre_year = Popdens_pre * year



*index
egen z_GDP     = std(GDP_pre)
egen z_Urban   = std(Urban_pre)
egen z_Popdens = std(Popdens_pre)
gen preIndex = z_GDP + z_Urban + z_Popdens

gen preIndex_Post = preIndex * post




*****************************outcomes
gen nonpriv_emp = 市城镇非私营单位就业人员数万人 * 10000
gen employ_total = 市城镇私营和个体从业人员数人 + nonpriv_emp
  
gen labor_proxy  = employ_total + 市年末城镇登记失业人员数人          
gen emp_rate     = employ_total / labor_proxy
gen slack_alt1   = 1 - emp_rate
gen tightness= vacancies/unemployed_numbers
gen slack_city= unemployed_numbers/vacancies


*dln_emp numbers
bys city_id (year): gen dln_emp = ln(employ_total / employ_total[_n-1])



*dunemp_rate
bys city_id (year): gen dunemp_rate = unemp_rate - unemp_rate[_n-1]

*d_emp_rate

bys city_id: gen d_emp_rate = emp_rate - emp_rate[_n-1]


**ΔlnCity_HP
bys city_id (year): gen dlnCity_HP = lnCity_HP - lnCity_HP[_n-1]

**industry emp
egen total_ind_emp = rowtotal(农林牧渔业从业人员数万人 采掘业从业人员数万人 制造业从业人员数万人 ///
    电力煤气及水生产供应业从业人员数万人 建筑业从业人员数万人 ///
    交通仓储邮电业从业人员数万人 信息传输计算机服务和软件业从业人员数万人 ///
    批发零售贸易业从业人员数万人 住宿餐饮业从业人员数万人 金融业从业人员数万人 ///
    房地产业从业人员数万人 租赁和商业服务业从业人员数万人 ///
    科研技术服务和地质勘查业从业人员数万人 水利环境和公共设施管理业从业人员数万人 ///
    居民服务和其他服务业从业人员数万人 教育业从业人员数万人 ///
    卫生社会保险和社会福利业从业人员数万人 文化体育和娱乐业从业人员数万人 ///
    公共管理和社会组织从业人员数万人)

local indlist 农林牧渔业从业人员数万人 采掘业从业人员数万人 制造业从业人员数万人 ///
    电力煤气及水生产供应业从业人员数万人 建筑业从业人员数万人 ///
    交通仓储邮电业从业人员数万人 信息传输计算机服务和软件业从业人员数万人 ///
    批发零售贸易业从业人员数万人 住宿餐饮业从业人员数万人 金融业从业人员数万人 ///
    房地产业从业人员数万人 租赁和商业服务业从业人员数万人 ///
    科研技术服务和地质勘查业从业人员数万人 水利环境和公共设施管理业从业人员数万人 ///
    居民服务和其他服务业从业人员数万人 教育业从业人员数万人 ///
    卫生社会保险和社会福利业从业人员数万人 文化体育和娱乐业从业人员数万人 ///
    公共管理和社会组织从业人员数万人

foreach v of local indlist {
    gen share_`v' = `v' / total_ind_emp
}


local indsharelist share_农林牧渔业从业人员数万人 share_采掘业从业人员数万人 share_制造业从业人员数万人 share_电力煤气及水生产供应业从业人员数万人 share_建筑业从业人员数万人 share_交通仓储邮电业从业人员数万人 share_信息传输计算机服务和软件业从业人员数万人 share_批发零售贸易业从业人员数万人 share_住宿餐饮业从业人员数万人 share_金融业从业人员数万人 share_房地产业从业人员数万人 share_租赁和商业服务业从业人员数万人 share_科研技术服务和地质勘查业从业人员数万人 share_水利环境和公共设施管理业从业人员数万人 share_居民服务和其他服务业从业人员数万人 share_教育业从业人员数万人 share_卫生社会保险和社会福利业从业人员数万人 share_文化体育和娱乐业从业人员数万人 share_公共管理和社会组织从业人员数万人

foreach v of local indsharelist {
    bys city_id (year): gen d_`v' = `v' - `v'[_n-1]
}


* Tradable = Agriculture + Mining + Manufacturing + IT
gen tradable_share = ///
    share_农林牧渔业从业人员数万人 + ///
    share_采掘业从业人员数万人 + ///
    share_制造业从业人员数万人 + ///
    share_信息传输计算机服务和软件业从业人员数万人

label var tradable_share "Tradable sector employment share"
bys city_id (year): gen d_tradable_share = tradable_share - tradable_share[_n-1]

* Nontradable = 本地服务业总和
gen nontradable_share = ///
    share_建筑业从业人员数万人 + ///
    share_交通仓储邮电业从业人员数万人 + ///
    share_批发零售贸易业从业人员数万人 + ///
    share_住宿餐饮业从业人员数万人 + ///
    share_金融业从业人员数万人 + ///
    share_房地产业从业人员数万人 + ///
    share_租赁和商业服务业从业人员数万人 + ///
    share_科研技术服务和地质勘查业从业人员数万人 + ///
    share_水利环境和公共设施管理业从业人员数万人 + ///
    share_居民服务和其他服务业从业人员数万人 + ///
    share_教育业从业人员数万人 + ///
    share_卫生社会保险和社会福利业从业人员数万人 + ///
    share_文化体育和娱乐业从业人员数万人 + ///
    share_公共管理和社会组织从业人员数万人

label var nontradable_share "Nontradable sector employment share"
bys city_id (year): gen d_nontradable_share = nontradable_share - nontradable_share[_n-1]



**************************IV ***********

*IV exposure_shareAvg * d_nat_hp_neg(national downwoard change)
gen IV_final = exposure_inv_share_Avg * d_nat_hp_neg
label var IV_final "Exposure × Δnational downturn"

gen IV_post = exposure_inv_share_Avg * post
label var IV_post "Exposure × post2021"


/////////////macro-fs	

**city year FE----Sig!!!!
reghdfe dlnCity_HP IV_final, absorb(city_id year) cluster(city_id)

	

//////////////Macro Second Stage
///outcome: slack_alt1 unemp_rate  dln_emp(number) d_emp_rate

***1.unemp_rate

ivreghdfe unemp_rate (dlnCity_HP = IV_final), absorb(city_id year) cluster(city_id)


***2.labor_force-insg

ivreghdfe labor_force (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
***3.labor_proxy---significant + p 0.035!!!!!!!!!!!!!!!!!!!
gen labor_proxy1=市城镇私营和个体从业人员数人/10000+市城镇非私营单位就业人员数万人+市年末城镇登记失业人员数人/10000
ivreghdfe labor_proxy1 (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)	
	
gen dln_laborproxy = ln(labor_proxy / labor_proxy[_n-1])
ivreghdfe d_lnLabor_proxy (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)	
***4.slack_prov----significant - p 0.074 but incorrect to cluster at city
ivreghdfe slack_prov (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
***5.slack_alt1=u/e+u---insignificant
ivreghdfe slack_alt1 (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)

***5.登记失业人员数人--insignificant
ivreghdfe 市年末城镇登记失业人员数人 (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
ivreghdfe unemp_rate (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
***5.dln_emp--insignificant
ivreghdfe dln_emp (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
ivreghdfe emp_rate (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
****6.slack_city-----insignificant
ivreghdfe slack_city (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
gen log_slack = log(unemployed + 1) - log(vacancies + 1)
ivreghdfe log_slack (dlnCity_HP = IV_final), absorb(city_id year) cluster(city_id)

gen d_slack = slack_city - slack_city[_n-1]
ivreghdfe d_slack (dlnCity_HP = IV_final), absorb(city_id year) cluster(city_id)

	
****7.tightness---
*significant!!!!!but wrong direction????
ivreghdfe tightness (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)

gen dtightness = tightness-tightness[_n-1]
ivreghdfe dtightness (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)


gen log_tightness = log(vacancies) - log(unemployed)
ivreghdfe log_tightness (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
*insig
winsor2 vacancies, cuts(1 99)	
gen log_tightness1 = log(vacancies_w + 1) - log(市年末城镇登记失业人员数人)
ivreghdfe log_tightness (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)

	
*neg sig--wrong	
gen d_lnvacancies = log(vacancies) - log(vacancies[_n-1])

ivreghdfe d_lnvacancies (dlnCity_HP = IV_final) ///
    ,absorb(city_id year) cluster(city_id)
	
////predict dlnCity_HP_hat and use it as dlnCity_HP in micro 
predict dlnCity_HP_hat, xb
label var dlnCity_HP_hat "Predicted city-level house price change"


	
//possible mechanisms --industry share change
*1.tradable and non-tradable both insig..
ivreghdfe d_tradable_share (dlnCity_HP = IV_final), absorb(city_id year city_id#c.year) cluster(city_id)

ivreghdfe d_nontradable_share (dlnCity_HP = IV_final), absorb(city_id year city_id#c.year) cluster(city_id)


*2. industries
bys city_id (year): gen d_第一产业从业人员比重_share = 第一产业从业人员比重 - 第一产业从业人员比重[_n-1]
bys city_id (year): gen d_第二产业从业人员比重_share = 第二产业从业人员比重 - 第二产业从业人员比重[_n-1]
bys city_id (year): gen d_第三产业从业人员比重_share = 第三产业从业人员比重 - 第三产业从业人员比重[_n-1]

*sig -
ivreghdfe d_第一产业从业人员比重_share (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
*sig +	
ivreghdfe d_第二产业从业人员比重_share (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
*sig -	
ivreghdfe d_第三产业从业人员比重_share (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
	
*3. sub-sectors

*sig but +	
ivreghdfe d_share_建筑业从业人员数万人 (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)

*insig
ivreghdfe d_share_房地产业从业人员数万人 (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
	
*Sig and +	
ivreghdfe d_share_制造业从业人员数万人 (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)


ivreghdfe d_share_金融业从业人员数万人 (dlnCity_HP = IV_final) , ///
    absorb(city_id year) cluster(city_id)


ivreghdfe d_share_租赁和商业服务业从业人员数万人 (dlnCity_HP = IV_final) , ///
    absorb(city_id year) cluster(city_id)
*p<0.1
ivreghdfe d_share_公共管理和社会组织从业人员数万人 (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
	
ivreghdfe d_share_电力煤气及水生产供应业从业人员数万人 (dlnCity_HP = IV_final), ///
    absorb(city_id year) cluster(city_id)
	

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_macro_2SLS.dta", replace


***save city_panel_macro data
keep city_id year dlnCity_HP lnCity_HP d_nat_hp d_nat_hp_neg IV_final exposure_inv_share_Avg lnGDP lnpopdens urbanization post dlnCity_HP_hat slack_prov

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_panel_macro.dta", replace



	
	
	
	

/////////////////////////HH 
**process
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111.dta", clear

order fid10 year prov_std city_std citycode labor_force lnCity_HP unemp_rate exposure_inv exposure_inv_share post rugged_z debt_p mortage finc h_loan nhd

keep if year==2018

****gen Pre Debt variables
gen hd_ratio=house_debts/finc
label var hd_ratio "Total Housing debt / annual income (pre)"
gen mor_ratio= mortage/(finc/12)
label var mor_ratio "Mortgage payment / monthly income (pre)"

drop _merge
**collapse to HH level

keep fid10 debt_p mortage finc h_loan nhd debt_p hd_ratio mor_ratio hd_ratio 

* bys household
bys fid10: egen debt_p_pre     = mean(debt_p)
bys fid10: egen hd_ratio_pre   = mean(hd_ratio)
bys fid10: egen nhd_pre        = mean(nhd)
bys fid10: egen mor_ratio_pre  = mean(mor_ratio)
bys fid10: egen finc_pre       = mean(finc)

*  max dummy var
bys fid10: egen h_loan_pre     = max(h_loan)

keep fid10 debt_p_pre hd_ratio_pre nhd_pre h_loan_pre mor_ratio_pre finc_pre
duplicates drop fid10, force
save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\debt2018.dta", replace


use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111.dta", clear
drop _merge

merge m:1 fid10 using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\debt2018.dta"

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111_HH.dta", replace





* HH dlnCity_HP_hat from (macro-fs)
* HH mechanisms
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111_HH.dta", clear
drop _merge
merge m:1 city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_crosswalk.dta"


rename city_id_unified city_id

tab city_id   // 379


destring 市城镇私营和个体从业人员数人, replace
drop _merge
merge m:1 city_id year using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_panel_macro.dta"

************************************HH outcomes*************************
*employed and workhours
gen employed = (workhour > 0 & workhour != .)
label var employed "Employed (1/0)"

*********** Pure supply outcomes
*LFP
*Job_search
*Reservation wage
*Desired workhours
*Second job indicator
*Search duration
*private business??entrep


************gen debt interaction terms & HH SS
egen c_hd = std(hd_ratio_pre)   
gen inter_hd   = dlnCity_HP * c_hd
gen z_inter_hd = IV_final   * c_hd


***debt_p_pre

gen double inter_debt = dlnCity_HP_hat*debt_p_pre

xtile debt3 = debt_p_pre, nq(3)
gen debt_high = (debt3 == 3)
gen debt_mid  = (debt3 == 2)
gen debt_low  = (debt3 == 1)

gen inter_debt_high = dlnCity_HP_hat*debt_high
gen inter_debt_mid = dlnCity_HP_hat*debt_mid
gen inter_debt_low = dlnCity_HP_hat*debt_low

xtile debt4 = debt_p_pre, nq(4)
gen debt_Q1 = (debt4 == 1)
gen debt_Q2  = (debt4 == 2)
gen debt_Q3  = (debt4 == 3)
gen debt_Q4  = (debt4 == 4)

gen inter_debt_Q1 = dlnCity_HP_hat*debt_Q1
gen inter_debt_Q2 = dlnCity_HP_hat*debt_Q2
gen inter_debt_Q3 = dlnCity_HP_hat*debt_Q3
gen inter_debt_Q4 = dlnCity_HP_hat*debt_Q4

*use predicted dlnCity_HP

*controls
rename gen male

*restrict samples 18-60
keep if age >= 18 & age<=60

*baseline
*significant
reghdfe employed dlnCity_HP_hat age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
*insig
reghdfe workhour dlnCity_HP_hat age eduy mar male, ///
    absorb(city_id year) cluster(city_id)

	
****debt_p_pre  

**employed dlnCity_HP_hat sig +& inter significant +
reghdfe employed dlnCity_HP_hat debt_p_pre inter_debt age eduy mar male, ///
    absorb(city_id year) cluster(city_id)	
	
**workhour insig 
reghdfe workhour dlnCity_HP_hat debt_p_pre inter_debt age eduy mar male, ///
    absorb(city_id year) cluster(city_id)		
	
	
*debt-high
replace debt_high = . if missing(debt_p_pre)
replace inter_debt_high = . if missing(debt_p_pre)


**1. employed: inter significant 
reghdfe employed dlnCity_HP_hat debt_high inter_debt_high age eduy mar male, ///
    absorb(city_id year) cluster(city_id)

**2. work hours:insignificant
reghdfe workhour dlnCity_HP_hat debt_high inter_debt_high age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
	
**3. entrep: inter significant 
reghdfe entrep dlnCity_HP_hat debt_high inter_debt_high age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
		
	
	
	
	
*debt_mid & debt_low insignificant

	
*debt_Q1

reghdfe employed dlnCity_HP_hat debt_Q1 inter_debt_Q1 age eduy mar male, ///
    absorb(city_id year) cluster(city_id)

reghdfe workhour dlnCity_HP_hat debt_Q1 inter_debt_Q1 age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
	
*insig
ivreghdfe employed  ///
    ( dlnCity_HP inter_debt = IV_final z_inter_debt ) ///
    debt_p_pre ///
    , absorb(city_id year) vce(cluster city_id)
*insig	
ivreghdfe workhour  ///
    ( dlnCity_HP inter_debt = IV_final z_inter_debt ) ///
    debt_p_pre ///
    , absorb(city_id year) vce(cluster city_id)




	
	
***hd_ratio_pre
*insig
ivreghdfe employed ///
  (dlnCity_HP inter_hd = IV_final z_inter_hd) ///
  c_hd , absorb(city_id year) vce(cluster city_id)
  *insig
ivreghdfe workhour ///
  (dlnCity_HP inter_hd = IV_final z_inter_hd) ///
  c_hd , absorb(city_id year) vce(cluster city_id)
  
*housing debt significant!!!!!!!!!!!!!!!!!!!!!!!!!
gen inter_hd_ratio_pre=dlnCity_HP_hat*c_hd
reghdfe employed dlnCity_HP_hat c_hd inter_hd_ratio_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)

reghdfe workhour dlnCity_HP_hat c_hd inter_hd_ratio_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
  
***nhd_pre
*insig
ivreghdfe employed  ///
    ( dlnCity_HP inter_nhd = IV_final z_inter_nhd ) ///
    nhd_pre ///
    , absorb(city_id year) vce(cluster city_id)
*insig	
ivreghdfe workhour  ///
    ( dlnCity_HP inter_nhd = IV_final z_inter_nhd ) ///
    nhd_pre ///
    , absorb(city_id year) vce(cluster city_id)

*non-housing debt inter significant！！！！
gen inter_nhd_pre=dlnCity_HP_hat*nhd_pre
reghdfe employed dlnCity_HP_hat nhd_pre inter_nhd_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)

reghdfe workhour dlnCity_HP_hat nhd_pre inter_nhd_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
	
***mor_ratio_pre
*insig
ivreghdfe employed  ///
    ( dlnCity_HP inter_mor = IV_final z_inter_mor ) ///
    mor_ratio_pre ///
    , absorb(city_id year) vce(cluster city_id)
*insig	
ivreghdfe workhour  ///
    ( dlnCity_HP inter_mor = IV_final z_inter_mor ) ///
    mor_ratio_pre ///
    , absorb(city_id year) vce(cluster city_id)

*mor_ratio_pre inter significant！！！！
gen inter_mor_ratio_pre=dlnCity_HP_hat*mor_ratio_pre
reghdfe employed dlnCity_HP_hat mor_ratio_pre inter_mor_ratio_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)
	

reghdfe workhour dlnCity_HP_hat mor_ratio_pre inter_mor_ratio_pre age eduy mar male, ///
    absorb(city_id year) cluster(city_id)


	





///////////*********dynamic event study---only province level
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\province_year_merged2.dta",clear

gen rel = year - 2021
keep if inrange(rel, -6, 2)

tab rel
* pre-period
gen rel_m6 = (rel == -6)
gen rel_m5 = (rel == -5)
gen rel_m4 = (rel == -4)
gen rel_m3 = (rel == -3)
gen rel_m2 = (rel == -2)
gen rel_m1 = (rel == -1)

* policy year & post
gen rel0   = (rel == 0)
gen rel1   = (rel == 1)
gen rel2   = (rel == 2)

drop rel_m1



xtset prov_id year


reghdfe slack ///
    c.exposure#rel_m6  c.exposure#rel_m5 c.exposure#rel_m4 ///
    c.exposure#rel_m3  c.exposure#rel_m2                   ///
    c.exposure#rel0    c.exposure#rel1    c.exposure#rel2  ///
    , absorb(prov_id year) cluster(prov_id)



reghdfe slack i.rel, absorb(prov_id) cluster(prov_id)

gen post = (year >= 2021)
gen inter_exposure=exposure*post
reghdfe slack exposure post inter_exposure, absorb(prov_id year) cluster(prov_id)















