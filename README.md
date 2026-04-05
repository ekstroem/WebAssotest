# Web-Assotest

**Web-Assotest** is a browser-based tool for analysing the association between a genetic variant and a binary outcome (cases vs. controls). Users enter observed genotype counts as a 3×2 table and the tool simultaneously fits four standard genetic models, displaying odds ratios, confidence intervals, and likelihood-ratio test statistics for each.

A live version of the tool is available at [ekstroem.com](https://ekstroem.com) (update with deployed URL).

---

## Features

- Interactive 3×2 genotype count table (WT / Het / Hom × Cases / Controls)
- Simultaneous fitting of four genetic models: **dominant**, **recessive**, **co-dominant**, and **genotype**
- Visual model comparison diagram with likelihood-ratio test statistics on each path; line width indicates which model transitions are statistically compatible with the data (p ≥ 0.05)
- Hardy-Weinberg equilibrium test for cases, controls, and both combined — choice of **chi-square** or **exact test** (Wigginton et al., 2005)
- Automatic fallback to Fisher's exact test for odds ratios when cells contain zeros
- Screenshot export and CSV download of results
- Fully browser-based; no software installation required for end users

---

## Genetic models

The tool tests the following hierarchy of models, all fitted as logistic regression with genotype counts as the outcome:

| Model | Contrast |
|---|---|
| Genotype | Het vs. WT and Hom vs. WT (2 df) |
| Dominant | Het+Hom vs. WT (1 df) |
| Co-dominant | Multiplicative: equal OR per allele copy (1 df) |
| Recessive | Hom vs. WT+Het (1 df) |
| Null | No association (OR = 1) |

Likelihood-ratio tests compare each pair of nested models. Lines in the diagram are drawn with quadruple width when the simpler model cannot be rejected (p ≥ 0.05), making it straightforward to identify which models are consistent with the data.

---

## Running the tool locally

### Requirements

- R (≥ 4.0)
- The following R packages:

```r
install.packages(c("flexdashboard", "tidyverse", "rhandsontable", "shinyscreenshot"))
```

### Launch

```r
rmarkdown::run("webassotest.Rmd")
```

This will open the dashboard in your default browser via a local Shiny server.

---

## Deploying to shinyapps.io

```r
library(rsconnect)
rsconnect::deployApp(appFiles = "webassotest.Rmd")
```

---

## Repository structure

```
WebAssotest/
├── webassotest.Rmd   # Main application source
├── paper/
│   ├── paper.md      # JOSS manuscript
│   └── paper.bib     # References
└── README.md
```

---

## Citation

If you use Web-Assotest in a publication, please cite:

> Ekstrøm CT (2026). Web-Assotest: A browser-based tool for genetic association analysis under multiple models. *Journal of Open Source Software*. (submitted)

---

## References

Wigginton JE, Cutler DJ, Abecasis GR (2005). A Note on Exact Tests of Hardy-Weinberg Equilibrium. *American Journal of Human Genetics*, 76(5):887–893. https://doi.org/10.1086/429864

---

## Author

**Claus Thorn Ekstrøm**  
Department of Biostatistics, University of Copenhagen  

---

## Licence

MIT
