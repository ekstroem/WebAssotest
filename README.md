# Web-Assotest

[![check](https://github.com/ekstroem/WebAssotest/actions/workflows/check.yaml/badge.svg)](https://github.com/ekstroem/WebAssotest/actions/workflows/check.yaml)

**Web-Assotest** is a browser-based tool for analysing the association between a genetic variant and a binary outcome (cases vs. controls). Users enter observed genotype counts as a 3×2 table and the tool simultaneously fits four standard genetic models, displaying odds ratios, confidence intervals, and likelihood-ratio test statistics for each, together with the Cochran-Armitage trend test, the allelic test, and a Hardy-Weinberg equilibrium check.

A live version of the tool is available at <http://ekstroem.com:3838/webassotest/>.

Current version: 0.99

---

## Features

- Interactive 3×2 genotype count table (WT / Het / Hom × Cases / Controls)
- Simultaneous fitting of four genetic models: **dominant**, **recessive**, **additive**, and **genotype**
- Optional **Firth's penalized logistic regression** (via `logistf`) for robust handling of complete separation
- Visual model comparison diagram with likelihood-ratio test statistics on each path; line width indicates which model transitions are statistically compatible with the data (p ≥ 0.05), explained by a legend on the diagram
- Model-fit (AIC) comparison table shown alongside the diagram, covering all five models, with ΔAIC and all models within 2 AIC units of the best highlighted (lowest in bold)
- Result panel heading shows which regression method (standard logistic vs. Firth's) produced the current output
- Customizable genotype labels (defaults to WT/Het/Hom) shown on the diagram, with a warning if two labels collide
- Analysis options (Firth's regression toggle, HWE test method) grouped in their own panel next to the data-entry table
- Hardy-Weinberg equilibrium test for cases, controls, and both combined — reports minor allele frequency (MAF) and choice of **chi-square** or **exact test** (Wigginton et al., 2005)
- Automatic fallback to Fisher's exact test for odds ratios when cells contain zeros (standard mode only)
- Cochran-Armitage trend test and allelic test (with allelic OR) shown beside the AIC table
- Row percentages under the data table
- Small p-values shown in scientific notation rather than rounded to 0.000
- Screenshot export, PDF download of the diagram, and CSV download that records the input counts, settings (method, labels, app version, date) and all results (ORs, every likelihood-ratio test, trend/allelic tests, HWE)
- Fully browser-based; no software installation required for end users

---

## Genetic models

The tool tests the following hierarchy of models, all fitted as logistic regression with genotype counts as the outcome:

| Model | Contrast |
|---|---|
| Genotype | Het vs. WT and Hom vs. WT (2 df) |
| Dominant | Het+Hom vs. WT (1 df) |
| Additive | Log-additive (multiplicative): equal OR per allele copy (1 df) |
| Recessive | Hom vs. WT+Het (1 df) |
| Null | No association (OR = 1) |

Likelihood-ratio tests compare each pair of nested models. Lines in the diagram are drawn with quadruple width when the simpler model cannot be rejected (p ≥ 0.05), making it straightforward to identify which models are consistent with the data.

---

## Running the tool locally

### Requirements

- R (≥ 4.0)
- The following R packages:

```r
install.packages(c("flexdashboard", "rhandsontable", "shinyscreenshot", "logistf"))
```

### Launch

```r
rmarkdown::run("webassotest.Rmd")
```

This will open the dashboard in your default browser via a local Shiny server.

---

## Deploying

The application is a single file, so any Shiny Server can host it. 

To deploy to shinyapps.io instead:

```r
library(rsconnect)
rsconnect::deployApp(appFiles = "webassotest.Rmd")
```

---

## Testing

The statistical functions are checked against direct `glm`, `fisher.test`, and `prop.trend.test` results, including edge cases (zero cells, separation, monomorphic groups, very small p-values):

```sh
Rscript tests/check.R
```

---

## Repository structure

```
WebAssotest/
├── webassotest.Rmd   # Main application source
├── paper/            # JOSS manuscript (paper.md, citations.bib, figure.png)
├── tests/check.R     # Self-checks of the statistical functions
├── CITATION.cff      # Citation metadata (used by GitHub and Zenodo)
├── CONTRIBUTING.md   # How to report issues, get support, and contribute
├── NEWS.md           # Changelog
├── LICENCE           # MIT licence
└── README.md         # This file
```

---

## Contributing

Bug reports, questions, and contributions are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Changes between versions are listed in [NEWS.md](NEWS.md).

---

## Citation

If you use Web-Assotest in a publication, please cite:

> Ekstrøm CT (2026). Web-Assotest: a browser-based tool for genetic association analysis under multiple inheritance models. *Journal of Open Source Software*. (submitted)

Citation metadata is also available via GitHub's *Cite this repository* button (from `CITATION.cff`).

---

## References

Armitage P (1955). Tests for linear trends in proportions and frequencies. *Biometrics*, 11(3):375–386.

Cochran WG (1954). Some methods for strengthening the common χ² tests. *Biometrics*, 10(4):417–451.

Firth D (1993). Bias reduction of maximum likelihood estimates. *Biometrika*, 80(1):27–38.

Ploner M, Dunkler D, Southworth H, Heinze G (2023). logistf: Firth's Bias-Reduced Logistic Regression. R package.

Sasieni PD (1997). From genotypes to genes: doubling the sample size. *Biometrics*, 53(4):1253–1261.

Wigginton JE, Cutler DJ, Abecasis GR (2005). A Note on Exact Tests of Hardy-Weinberg Equilibrium. *American Journal of Human Genetics*, 76(5):887–893. https://doi.org/10.1086/429864

---

## Author

**Claus Thorn Ekstrøm** ([ORCID 0000-0003-1191-373X](https://orcid.org/0000-0003-1191-373X))  
Section of Biostatistics, Department of Public Health, University of Copenhagen  

---

## Licence

MIT — see [LICENCE](LICENCE). Copyright (c) 2004-2026 Claus Thorn Ekstrøm.
