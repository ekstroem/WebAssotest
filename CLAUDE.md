# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Web-Assotest is a single-file R Shiny/flexdashboard application (`webassotest.Rmd`) for genetic association analysis. Users enter genotype counts in a 3×2 table (WT/Het/Hom × Cases/Controls); the tool fits four genetic models and displays results as a model-comparison diagram.

## Running locally

```r
rmarkdown::run("webassotest.Rmd")
```

Required packages: `flexdashboard`, `rhandsontable`, `shinyscreenshot`, `logistf`

## Deploying

```r
library(rsconnect)
rsconnect::deployApp(appFiles = "webassotest.Rmd")
```

## Architecture

Everything lives in `webassotest.Rmd`. The file is structured as a flexdashboard with `runtime: shiny`, so R chunks contain both UI definitions and server-side reactive logic — there is no separate `ui.R`/`server.R`.

Key reactive flow:
- `modified_table` — reads the `rhandsontable` widget input and rounds values
- `ca_co` — extracts case/control vectors from the table
- `hwe_reactive` — computes HWE p-values reactively (used by both the HWE panel and CSV download)

Key pure functions (defined in the setup chunk):
- `SNPHWE()` — exact HWE test (Wigginton et al. 2005)
- `hwe_pvalues()` — wraps chi-square and exact HWE for cases, controls, and both combined
- `maf()` — computes minor allele frequency from a length-3 count vector
- `gtm()` — fits all five logistic regression models (`nul`, `gen`, `dom`, `cod` = additive, `rec`), draws the model-comparison diagram using base R graphics, and returns `list(models, tests)` invisibly (ORs/CIs/AIC and all LRTs); supports optional Firth's penalized regression via `firth = TRUE` (`logistf` package)
- `allelic_tests()` — Cochran-Armitage trend test and allelic 2×2 test with allelic OR
- `fmt_p()`, `p_lab()`, `fmt_ci()`, `fisher_or()` — formatting and Fisher-fallback helpers
- `check_data_validity()` — guards against degenerate inputs before any computation
- `ci.mat()` — helper for Wald 95% CI matrix multiplication on log-OR scale

## Statistical details

- Default: models fitted as `glm(cbind(ca, co) ~ ..., family = binomial)` on the 3-element genotype count vectors
- Optional Firth mode (`input$use_firth`): uses `logistf` on expanded individual-level binary data; profile-likelihood CIs; no Fisher fallback needed
- Likelihood-ratio tests use `anova(..., test = "Chisq")` (standard) or manual deviance difference (Firth)
- Lines in the diagram are drawn at `lwd = 8` when the simpler model cannot be rejected (p ≥ 0.05), `lwd = 2` otherwise
- When any cell is zero (standard mode only), Fisher's exact test replaces the logistic-regression OR/CI for the affected contrast
- HWE table shows MAF per group; "Both" combined p-value uses Fisher's method (chi-sq with 4 df for exact; sum of chi-sq statistics with 2 df for chi-square method)

## Tests

`Rscript tests/check.R` evaluates the pure functions from the setup chunk and checks them against direct glm/Fisher/stats results.

## `webassotest-old.Rmd`

Previous version of the app kept for reference. Not deployed.
