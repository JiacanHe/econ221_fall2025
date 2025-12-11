# Do Falling Housing Prices Influence Labor-Market Slack? — Code and Data

This repository contains all code and data used to produce the results in the research paper:

**“Do Falling Housing Prices Influence Labor-Market Slack? Evidence from the Household Side”**  
Written by *Jiacan He* for the UCSC ECON 221 research paper requirement.

The repository is fully reproducible: running the provided Stata scripts will generate all figures and tables used in the paper.

---

## 📄 Paper

The full paper (PDF) is available here:
 [**Final_PaperJHE.pdf**](Final_PaperJHE.pdf)





##Repository structure 
- [code/](code/)
  - [00_Process.do](code/00_Process.do)
  - [01_macro&micro analysis.do](code/01_macro&micro%20analysis.do)
- [raw/](raw/)
  - [metadata/](raw/metadata/)
- [cleaned/](cleaned/)
- [figures/](figures/)
  - [csv/](figures/csv/)
- [results/](results/)
  - [tables/](results/tables/)
- [Final_PaperJHE.pdf](Final_PaperJHE.pdf)
- [README.md](README.md)

**Note:** Some raw and cleaned datasets are too large to be hosted on GitHub.  
Researchers who wish to access these files may contact me directly at *jhe517@ucsc.edu*.

Usage



##To reproduce the results:



Open Stata



Set working directory to the repo folder


##Run the scripts in order

Step 1 — Prepare data
do code/00_Process.do

Step 2 — Run macro & micro regressions + produce figures
do code/01_macro&micro analysis.do


All figures and tables used in the paper will be saved automatically into:

figures/

results/tables/

🖥️ Software Environment

The analysis was conducted in Stata/MP 17.

Packages used include:

reghdfe

ivreghdfe

esttab

coefplot

ftools

All packages are freely available from SSC (e.g. ssc install reghdfe).

📬 Contact

For questions or replication issues, please contact:

Jiacan He
UCSC Economics Department










