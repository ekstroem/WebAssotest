# Web-Assotest 0.99

First open-source release of Web-Assotest.

## New features

* Fits the null, dominant, additive, recessive, and genotype models and shows the likelihood-ratio tests between them in a model-comparison diagram, with a legend explaining thick and thin lines.
* AIC table for all five models with ΔAIC; models within 2 units of the best (similar support) are highlighted.
* Cochran-Armitage trend test and allelic test (with allelic odds ratio) shown next to the AIC table.
* Optional Firth's penalized logistic regression (`logistf`) for zero cells and separation.
* Hardy-Weinberg equilibrium tests (chi-square or exact) for cases, controls, and both combined, with minor allele frequencies.
* Custom genotype labels, with a warning when two labels are the same.
* Row percentages shown under the data table.
* Diagram can be downloaded as a vector PDF.
* CSV export is a complete record of the analysis: settings (version, date, regression method, HWE test, labels), input counts, all odds ratios with confidence intervals, every likelihood-ratio test, trend and allelic tests, and HWE tests.
* Version number shown in the navbar.
* `tests/check.R` checks the statistical functions against direct `glm`, `fisher.test`, and `prop.trend.test` results.

## Changes

* The "co-dominant" model is now called "additive" (log-additive, equal OR per allele copy), since "co-dominant" is used for different models in the literature.

## Bug fixes

* The chi-square HWE test no longer returns `NaN` when a group is monomorphic.
* p-values are computed in the upper tail and shown in scientific notation, so very small p-values are no longer shown as `0.000`.
* The exact HWE test now treats floating-point ties correctly.

# Earlier history

Web-Assotest started as `Assotest`, a stand-alone Windows programme, and was later ported to a web application that has been used in published case-control studies since 2004. The source code was released on GitHub in 2026.
