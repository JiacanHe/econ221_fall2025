Do Falling Housing Prices Influence Labor-Market Slack? — Code and Data



This repository contains all code and data used to produce the results in the research paper

“Do Falling Housing Prices Influence Labor-Market Slack? Evidence from the Household Side”, written by Jiacan He for the UCSC ECON research paper requirement.



The repository is designed so that the entire analysis can be reproduced with one command.

All raw data, cleaned data, estimation scripts, and figure-production scripts are included.



Paper



The paper (PDF) is available as:



final\_paper.pdf



Repository structure
📁 Code

code/

00_Process.do

01_macro&micro analysis.do

📁 Raw data

raw/

metadata/

(all uploaded raw files appear here)

📁 Cleaned data

cleaned/

📁 Figures

figures/

csv/

📁 Results / Tables

results/

tables/

📁 Presentation

reading_presentations/

📁 Research paper

research_paper/

(your .tex sources go here if needed)

📄 Final paper (PDF)

Final_PaperJHE.pdf


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





