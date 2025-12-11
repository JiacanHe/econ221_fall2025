Do Falling Housing Prices Influence Labor-Market Slack? — Code and Data



This repository contains all code and data used to produce the results in the research paper

“Do Falling Housing Prices Influence Labor-Market Slack? Evidence from the Household Side”, written by Jiacan He for the UCSC ECON research paper requirement.



The repository is designed so that the entire analysis can be reproduced with one command.

All raw data, cleaned data, estimation scripts, and figure-production scripts are included.



Paper



The paper (PDF) is available as:



final\_paper.pdf



Repository structure

├── README.md

├── final\_paper.pdf

├── code/

│   ├── 00\_Process.do

│   ├── 01\_macro\&micro analysis.do

├── raw/

├── cleaned/

├── figures/

├── results/



Usage



To reproduce the results:



Open Stata



Set working directory to the repo folder



Run:



do code/00\_Process.do



do code/01\_macro\&micro analysis.do

The script will produce all figures and tables used in the paper.





Software



The analysis was conducted in:



Stata/MP 17



With packages: reghdfe, ivreghdfe, esttab, coefplot, ftools



License



MIT License.

