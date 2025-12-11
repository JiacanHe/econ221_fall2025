*Merge with county name

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\顺序码匹配.dta", clear
*change city names to new names
replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"
save, replace


*standardize provname cityname

gen strL prov_std = provname
tostring prov_std, replace force
replace prov_std = ustrregexra(prov_std, "省$|市$", "")
replace prov_std = ustrregexra(prov_std, "(省|市|自治区|特别行政区)$", "")
replace prov_std = ustrregexra(prov_std, "(壮族)?(回族)?(维吾尔)?自治区$", "")
replace prov_std = ustrregexra(prov_std, "特别行政区$", "")
replace prov_std = "北京" if strpos(provname,"北京")
replace prov_std = "上海" if strpos(provname,"上海")
replace prov_std = "天津" if strpos(provname,"天津")
replace prov_std = "重庆" if strpos(provname,"重庆")
replace prov_std = "广西" if strpos(provname,"广西")
replace prov_std = "内蒙古" if strpos(provname,"内蒙古")
replace prov_std = "宁夏" if strpos(provname,"宁夏")
replace prov_std = "新疆" if strpos(provname,"新疆")
replace prov_std = "西藏" if strpos(provname,"西藏")
replace prov_std = "香港" if strpos(provname,"香港")
replace prov_std = "澳门" if strpos(provname,"澳门")

gen strL city_std = cityname
replace city_std = ustrnormalize(city_std, "nfc")
replace city_std = ustrregexra(city_std, "\s+", "")
replace city_std = ustrregexra(city_std, "(市|区|县|地区|盟|自治州|自治县|旗|林区|市辖区|新区)$", "")
replace city_std = trim(ustrlower(city_std))

save, replace
***CFPS
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\2010-2022CFPS平衡面板数据.dta", clear

*standardize cityname and provname
replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL prov_std = provname
tostring prov_std, replace force
replace prov_std = ustrregexra(prov_std, "省$|市$", "")
replace prov_std = ustrregexra(prov_std, "(省|市|自治区|特别行政区)$", "")
replace prov_std = ustrregexra(prov_std, "(壮族)?(回族)?(维吾尔)?自治区$", "")
replace prov_std = ustrregexra(prov_std, "特别行政区$", "")
replace prov_std = "北京" if strpos(provname,"北京")
replace prov_std = "上海" if strpos(provname,"上海")
replace prov_std = "天津" if strpos(provname,"天津")
replace prov_std = "重庆" if strpos(provname,"重庆")
replace prov_std = "广西" if strpos(provname,"广西")
replace prov_std = "内蒙古" if strpos(provname,"内蒙古")
replace prov_std = "宁夏" if strpos(provname,"宁夏")
replace prov_std = "新疆" if strpos(provname,"新疆")
replace prov_std = "西藏" if strpos(provname,"西藏")
replace prov_std = "香港" if strpos(provname,"香港")
replace prov_std = "澳门" if strpos(provname,"澳门")

gen strL city_std = cityname
replace city_std = ustrnormalize(city_std, "nfc")
replace city_std = ustrregexra(city_std, "\s+", "")
replace city_std = ustrregexra(city_std, "(市|区|县|地区|盟|自治州|自治县|旗|林区|市辖区|新区)$", "")
replace city_std = trim(ustrlower(city_std))

**merge
merge m:1 countyid using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\顺序码匹配.dta"

drop _merge

gen str80 prov_key = prov_std
gen str80 city_key = city_std

drop prov_std
rename prov_key prov_std

drop city_std
rename city_key city_std
**saved as panel_data_merged1024
save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1024.dta", replace


//////////////////////Housing price data
import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\price_city.xlsx", sheet("面板数据") firstrow clear


rename 城市 cityname
rename 年份 year
rename 省份 provname
rename 单价元每平方米 Price
drop F G H I

keep if year >= 2010 & year <= 2022

replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL prov_std = provname
tostring prov_std, replace force
replace prov_std = ustrregexra(prov_std, "省$|市$", "")
replace prov_std = ustrregexra(prov_std, "(省|市|自治区|特别行政区)$", "")
replace prov_std = ustrregexra(prov_std, "(壮族)?(回族)?(维吾尔)?自治区$", "")
replace prov_std = ustrregexra(prov_std, "特别行政区$", "")
replace prov_std = "北京" if strpos(provname,"北京")
replace prov_std = "上海" if strpos(provname,"上海")
replace prov_std = "天津" if strpos(provname,"天津")
replace prov_std = "重庆" if strpos(provname,"重庆")
replace prov_std = "广西" if strpos(provname,"广西")
replace prov_std = "内蒙古" if strpos(provname,"内蒙古")
replace prov_std = "宁夏" if strpos(provname,"宁夏")
replace prov_std = "新疆" if strpos(provname,"新疆")
replace prov_std = "西藏" if strpos(provname,"西藏")
replace prov_std = "香港" if strpos(provname,"香港")
replace prov_std = "澳门" if strpos(provname,"澳门")

gen strL city_std = cityname
replace city_std = ustrnormalize(city_std, "nfc")
replace city_std = ustrregexra(city_std, "\s+", "")
replace city_std = ustrregexra(city_std, "(市|区|县|地区|盟|自治州|自治县|旗|林区|市辖区|新区)$", "")
replace city_std = trim(ustrlower(city_std))

gen str80 prov_key = prov_std
gen str80 city_key = city_std

drop prov_std
rename prov_key prov_std

drop city_std
rename city_key city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\price_city2010-2022.dta", replace

*Merge with HP
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1024.dta", clear

merge m:1 year prov_std city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\price_city2010-2022.dta"

gen lnCity_HP = ln(Price)
hist Price
hist lnCity_HP

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1025.dta", replace

//////////////////////////city employment $ unemployment numbers
**merge with city employment numbers

import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\城镇就业失业2000-2023reginputed.xlsx", ///
    sheet("Sheet1") firstrow clear
*already new city names

destring year, replace
destring citycode, replace

gen strL prov_std = provname
tostring prov_std, replace force
replace prov_std = ustrregexra(prov_std, "省$|市$", "")
replace prov_std = ustrregexra(prov_std, "(省|市|自治区|特别行政区)$", "")
replace prov_std = ustrregexra(prov_std, "(壮族)?(回族)?(维吾尔)?自治区$", "")
replace prov_std = ustrregexra(prov_std, "特别行政区$", "")
replace prov_std = "北京" if strpos(provname,"北京")
replace prov_std = "上海" if strpos(provname,"上海")
replace prov_std = "天津" if strpos(provname,"天津")
replace prov_std = "重庆" if strpos(provname,"重庆")
replace prov_std = "广西" if strpos(provname,"广西")
replace prov_std = "内蒙古" if strpos(provname,"内蒙古")
replace prov_std = "宁夏" if strpos(provname,"宁夏")
replace prov_std = "新疆" if strpos(provname,"新疆")
replace prov_std = "西藏" if strpos(provname,"西藏")
replace prov_std = "香港" if strpos(provname,"香港")
replace prov_std = "澳门" if strpos(provname,"澳门")

gen strL city_std = cityname
replace city_std = ustrnormalize(city_std, "nfc")
replace city_std = ustrregexra(city_std, "\s+", "")
replace city_std = ustrregexra(city_std, "(市|区|县|地区|盟|自治州|自治县|旗|林区|市辖区|新区)$", "")
replace city_std = trim(ustrlower(city_std))

gen str80 prov_key = prov_std
gen str80 city_key = city_std

drop prov_std
rename prov_key prov_std

drop city_std
rename city_key city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_emp.dta", replace

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1025.dta", clear

drop _merge
merge m:1 year city_std prov_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_emp.dta"

destring unemployed_numbers employed_numbers, replace ignore(",")
gen labor_force=unemployed_numbers+employed_numbers
gen unemp_rate=unemployed_numbers/labor_force
save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1027.dta", replace

*****///////////////////////////shock IV

///exposure--City Ruggedness
import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\全国各城市-地形起伏度.xlsx",firstrow clear

rename 地区 cityname
rename 所属省份 provname
rename 地形起伏度 ruggedness
rename 行政区划代码 citycode

drop I
*standardize ruggedness
summ ruggedness
gen rugged_z = (ruggedness - r(mean)) / r(sd)

drop if citycode==.
*drop old city name(expired and changed to new names)
drop if strpos(cityname, "淮阴") | strpos(cityname, "襄樊") | strpos(cityname, "沙市") | strpos(cityname, "思茅")


gen strL prov_std = provname
tostring prov_std, replace force
replace prov_std = ustrregexra(prov_std, "省$|市$", "")
replace prov_std = ustrregexra(prov_std, "(省|市|自治区|特别行政区)$", "")
replace prov_std = ustrregexra(prov_std, "(壮族)?(回族)?(维吾尔)?自治区$", "")
replace prov_std = ustrregexra(prov_std, "特别行政区$", "")
replace prov_std = "北京" if strpos(provname,"北京")
replace prov_std = "上海" if strpos(provname,"上海")
replace prov_std = "天津" if strpos(provname,"天津")
replace prov_std = "重庆" if strpos(provname,"重庆")
replace prov_std = "广西" if strpos(provname,"广西")
replace prov_std = "内蒙古" if strpos(provname,"内蒙古")
replace prov_std = "宁夏" if strpos(provname,"宁夏")
replace prov_std = "新疆" if strpos(provname,"新疆")
replace prov_std = "西藏" if strpos(provname,"西藏")
replace prov_std = "香港" if strpos(provname,"香港")
replace prov_std = "澳门" if strpos(provname,"澳门")

gen strL city_std = cityname
replace city_std = ustrnormalize(city_std, "nfc")
replace city_std = ustrregexra(city_std, "\s+", "")
replace city_std = ustrregexra(city_std, "(市|区|县|地区|盟|自治州|自治县|旗|林区|市辖区|新区)$", "")
replace city_std = trim(ustrlower(city_std))

gen str80 prov_key = prov_std
gen str80 city_key = city_std

drop prov_std
rename prov_key prov_std

drop city_std
rename city_key city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\rugged_z.dta", replace

*gen GB6 citycode book
keep citycode city_std prov_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\GB6citycodefromruggedness.dta", replace


*merge GB6 citycode with main panel
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1027.dta", clear

drop _merge

order fid10 year prov_std city_std citycode countyname countycode


*merge with city_ruggedness
merge m:1 city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\rugged_z.dta" 

*generate shock
gen post = (year >= 2021)
label var post "Post-Three Red Lines policy (>=2021)"
gen shock = post*-rugged_z
label var shock "Post(>=2021)*(-rugged_z)"
label var rugged_z "Standardized ruggdeness"

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1028.dta", replace

**population

import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\pop_density_city.xlsx", firstrow clear
rename name cityname
rename 时间 year
rename 数值 popdens
rename 指标 calculation

destring year,replace
keep if year >= 2010 & year <= 2022

replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL city_std = cityname
replace city_std = ustrtrim(ustrnormalize(city_std, "nfc"))

replace city_std = ustrregexra(city_std, "(省|市|地区|盟|自治州|自治县|旗|林区|新区|市辖区)$", "")
replace city_std = ustrregexra(city_std, "\s+", "")   // 去空格

replace city_std = "北京" if strpos(cityname, "北京")
replace city_std = "上海" if strpos(cityname, "上海")
replace city_std = "天津" if strpos(cityname, "天津")
replace city_std = "重庆" if strpos(cityname, "重庆")
replace city_std = "广西" if strpos(cityname, "广西")
replace city_std = "香港" if strpos(cityname, "香港")
replace city_std = "澳门" if strpos(cityname, "澳门")

* ---- 下花园：张家口的区 ----
replace city_std = "张家口" if city_std=="下花园"

* ---- 巢湖：2011 撤销，保留2010以前，删除2011以后 ----
replace city_std = "巢湖" if city_std=="巢湖" & year<=2010
drop if city_std=="巢湖" & year>=2011

* ---- 莱芜：2019 合并入济南 ----
replace city_std = "莱芜" if city_std=="莱芜" & year<=2018
replace city_std = "济南" if city_std=="莱芜" & year>=2019

* === 广东：地级市无区县，密度表可能写成市名 ===
replace city_std = "东莞" if city_std=="东莞市"
replace city_std = "中山" if city_std=="中山市"



gen str80 city_key = city_std
drop city_std
rename city_key city_std
save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\pop_density_city.dta", replace

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1028.dta", clear

keep if year >= 2010 & year <= 2022


* ---- 下花园：张家口的区 ----
replace city_std = "张家口" if city_std=="下花园"

* ---- 巢湖：2011 撤销，保留2010以前，删除2011以后 ----
replace city_std = "巢湖" if city_std=="巢湖" & year<=2010
drop if city_std=="巢湖" & year>=2011

* ---- 莱芜：2019 合并入济南 ----
replace city_std = "莱芜" if city_std=="莱芜" & year<=2018
replace city_std = "济南" if city_std=="莱芜" & year>=2019


drop _merge
merge m:1 year city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\pop_density_city.dta"

gen lnpopdens = ln(popdens)


rename 城镇化水平 urbanization

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1104.dta", replace

///GDP citylevel

import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_GDP.xlsx", firstrow clear
rename 年份 year
rename 省份 provname
rename 城市 cityname

destring year,replace
keep if year >= 2010 & year <= 2022

replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL city_std = cityname
replace city_std = ustrtrim(ustrnormalize(city_std, "nfc"))

replace city_std = ustrregexra(city_std, "(省|市|地区|盟|自治州|自治县|旗|林区|新区|市辖区)$", "")
replace city_std = ustrregexra(city_std, "\s+", "")   // 去空格

replace city_std = "北京" if strpos(cityname, "北京")
replace city_std = "上海" if strpos(cityname, "上海")
replace city_std = "天津" if strpos(cityname, "天津")
replace city_std = "重庆" if strpos(cityname, "重庆")
replace city_std = "广西" if strpos(cityname, "广西")
replace city_std = "香港" if strpos(cityname, "香港")
replace city_std = "澳门" if strpos(cityname, "澳门")

* ---- 下花园：张家口的区 ----
replace city_std = "张家口" if city_std=="下花园"

* ---- 巢湖：2011 撤销，保留2010以前，删除2011以后 ----
replace city_std = "巢湖" if city_std=="巢湖" & year<=2010
drop if city_std=="巢湖" & year>=2011

* ---- 莱芜：2019 合并入济南 ----
replace city_std = "莱芜" if city_std=="莱芜" & year<=2018
replace city_std = "济南" if city_std=="莱芜" & year>=2019

* === 广东：地级市无区县，密度表可能写成市名 ===
replace city_std = "东莞" if city_std=="东莞市"
replace city_std = "中山" if city_std=="中山市"



gen str80 city_key = city_std
drop city_std
rename city_key city_std

drop cityname
order year city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_GDP.dta", replace

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1104.dta", clear

drop _merge
merge m:1 year city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_GDP.dta"

gen lnGDP = ln(人均GDP元)


save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1109.dta", replace






/////////////////////////new IV-Exposure_i × ΔNatHP_t////////////////Mian////////
//exposure
import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\中国城市数据库6.0版.xlsx", firstrow clear
rename 年份 year
rename 省份 provname
rename 城市 cityname

drop HF

destring year,replace
keep if year >= 2010 & year <= 2022

replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL city_std = cityname
replace city_std = ustrtrim(ustrnormalize(city_std, "nfc"))

replace city_std = ustrregexra(city_std, "(省|市|地区|盟|自治州|自治县|旗|林区|新区|市辖区)$", "")
replace city_std = ustrregexra(city_std, "\s+", "")   // 去空格

replace city_std = "北京" if strpos(cityname, "北京")
replace city_std = "上海" if strpos(cityname, "上海")
replace city_std = "天津" if strpos(cityname, "天津")
replace city_std = "重庆" if strpos(cityname, "重庆")
replace city_std = "广西" if strpos(cityname, "广西")
replace city_std = "香港" if strpos(cityname, "香港")
replace city_std = "澳门" if strpos(cityname, "澳门")

* ---- 下花园：张家口的区 ----
replace city_std = "张家口" if city_std=="下花园"

* ---- 巢湖：2011 撤销，保留2010以前，删除2011以后 ----
replace city_std = "巢湖" if city_std=="巢湖" & year<=2010
drop if city_std=="巢湖" & year>=2011

* ---- 莱芜：2019 合并入济南 ----
replace city_std = "莱芜" if city_std=="莱芜" & year<=2018
replace city_std = "济南" if city_std=="莱芜" & year>=2019

* === 广东：地级市无区县，密度表可能写成市名 ===
replace city_std = "东莞" if city_std=="东莞市"
replace city_std = "中山" if city_std=="中山市"



gen str80 city_key = city_std
drop city_std
rename city_key city_std

drop cityname
order year city_std

keep year provname city_std 地区生产总值万元 房地产开发投资完成额万元 固定资产投资总额万元 固定资产净值年平均余额万元

keep if inrange(year,2015,2019)

gen exposure_inv = ln(房地产开发投资完成额万元)
label var exposure_inv "ln(2019 房地产开发投资完成额万元)"

gen exposure_inv_share = 房地产开发投资完成额万元/地区生产总值万元
label var exposure_inv "2019 房地产开发投资完成额万元/地区生产总值万元"

bys city_std: egen REavg = mean(房地产开发投资完成额万元) if inrange(year,2015,2019)
bys city_std: egen GDPavg = mean(地区生产总值万元)    if inrange(year,2015,2019)

gen exposure_inv_share_Avg=REavg/GDPavg
replace exposure_inv_share_Avg = . if REavg<=0 | GDPavg<=0


duplicates tag city_std year, gen(tag)

drop if tag==1 & ( missing(房地产开发投资完成额万元) | missing(地区生产总值万元) )

drop tag


duplicates report city_std year   // confirm unique

keep provname city_std 地区生产总值万元 房地产开发投资完成额万元 固定资产投资总额万元 固定资产净值年平均余额万元 exposure_inv exposure_inv_share exposure_inv_share_Avg

* collapse to city
sort city_std
bys city_std: keep if _n==1
duplicates report city_std


save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_HPexposure2015-19.dta", replace


* merge HPexposure
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1109.dta", clear
drop _merge
merge m:1 city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_HPexposure2015-19.dta"

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1110.dta", replace


////////////All industry employment data city*year
import excel "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\300城市一二三产业就业人员2000-2022年.xlsx", firstrow clear
rename 年份 year
rename 地区 cityname

destring year,replace
keep if year >= 2010 & year <= 2022

replace cityname = "淮安市" if cityname=="淮阴市"
replace cityname = "襄阳市" if cityname=="襄樊市"
replace cityname = "荆州市" if cityname=="沙市市"
replace cityname = "普洱市" if cityname=="思茅市"

gen strL city_std = cityname
replace city_std = ustrtrim(ustrnormalize(city_std, "nfc"))

replace city_std = ustrregexra(city_std, "(省|市|地区|盟|自治州|自治县|旗|林区|新区|市辖区)$", "")
replace city_std = ustrregexra(city_std, "\s+", "")   // 去空格

replace city_std = "北京" if strpos(cityname, "北京")
replace city_std = "上海" if strpos(cityname, "上海")
replace city_std = "天津" if strpos(cityname, "天津")
replace city_std = "重庆" if strpos(cityname, "重庆")
replace city_std = "广西" if strpos(cityname, "广西")
replace city_std = "香港" if strpos(cityname, "香港")
replace city_std = "澳门" if strpos(cityname, "澳门")

* ---- 下花园：张家口的区 ----
replace city_std = "张家口" if city_std=="下花园"

* ---- 巢湖：2011 撤销，保留2010以前，删除2011以后 ----
replace city_std = "巢湖" if city_std=="巢湖" & year<=2010
drop if city_std=="巢湖" & year>=2011

* ---- 莱芜：2019 合并入济南 ----
drop if city_std== "莱芜" & year>=2019

* === 广东：地级市无区县，密度表可能写成市名 ===
replace city_std = "东莞" if city_std=="东莞市"
replace city_std = "中山" if city_std=="中山市"

gen str80 city_key = city_std
drop city_std
rename city_key city_std

drop cityname
order year city_std

keep year city_std 行政区划代码 第一产业从业人员比重 第二产业从业人员比重 第三产业从业人员比重 农林牧渔业从业人员数万人 采掘业从业人员数万人 制造业从业人员数万人 电力煤气及水生产供应业从业人员数万人 建筑业从业人员数万人 交通仓储邮电业从业人员数万人 信息传输计算机服务和软件业从业人员数万人 批发零售贸易业从业人员数万人 住宿餐饮业从业人员数万人 金融业从业人员数万人 房地产业从业人员数万人 租赁和商业服务业从业人员数万人 科研技术服务和地质勘查业从业人员数万人 水利环境和公共设施管理业从业人员数万人 居民服务和其他服务业从业人员数万人 教育业从业人员数万人 卫生社会保险和社会福利业从业人员数万人 文化体育和娱乐业从业人员数万人 公共管理和社会组织从业人员数万人


save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_industry_emp.dta", replace


* merge industry_emp
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1110.dta", clear
drop _merge

merge m:1 city_std year using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_industry_emp.dta"

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111.dta", replace





***********Slack outcomes(province level)************
**unemp_rate
**labor_force
**v/u
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1111.dta", clear

encode prov_std, gen(prov_id)

drop _merge

merge m:1 prov_id year using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\province_year_slack.dta"


save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1130.dta", replace


***********Slack outcomes(city level)************
use 工作城市 招聘发布日期 招聘发布年份 招聘人数 初级分类 using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\智联招聘数据库2016-2025.7.dta", clear


rename 工作城市 city_std
rename 招聘发布年份 year
rename 招聘发布日期 date
rename 招聘人数 v

order city_std year date v

* 1. delete "人"
replace v = subinstr(v, "人", "", .)

* 2. delete " "
replace v = trim(v)

destring v, replace force

rename v vacancies
replace vacancies = . if vacancies == 0

destring year, replace force

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_year_vacancies000.dta", replace


**crosswalk

//unified id

use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\panel_data_merged1130.dta", clear

keep city_std
duplicates drop
sort city_std

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_crosswalk000.dta", replace

*merge vavancies 
use "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_year_vacancies000.dta",clear

merge m:1 city_std using "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_crosswalk000.dta"


*all to city level
collapse (sum) vacancies,by(city_std year)

drop if vacancies==0

save "C:\Users\jiaca\OneDrive\Desktop\Research paper_Slack\city_year_vacancies.dta", replace




**HH outcomes




