---
title: 'Web-Assotest: a browser-based tool for genetic association analysis under multiple inheritance models'
tags:
  - R
  - Shiny
  - genetics
  - genetic epidemiology
  - case-control studies
  - Hardy-Weinberg equilibrium
authors:
  - name: Claus Thorn Ekstrøm
    orcid: 0000-0003-1191-373X
    affiliation: 1
affiliations:
  - name: Department of Public Health, Section of Biostatistics, University of Copenhagen, Denmark
    index: 1
date: 07 October 2026
bibliography: citations.bib
output: pdf_document
---

# Summary

`Web-Assotest` is a browser-based tool for analysing various
associations between a genetic variant and a binary outcome (cases
vs. controls) from a $3\times2$ table of observed genotype counts (wild-type
/ heterozygote / homozygote, by case/control status).

The tool simultaneously fits a hierarchy of five nested
logistic-regression models --- null, dominant, additive (log-additive),
recessive, and genotypic --- and presents the resulting odds ratios, 95%
confidence intervals, and likelihood-ratio test statistics in a
model-comparison diagram, with AIC values in an accompanying table,
together with a Hardy-Weinberg
equilibrium (HWE) check for cases, controls, and the combined sample
[@wigginton2005note]. Two complementary one-degree-of-freedom tests are reported
alongside the model hierarchy: the Cochran--Armitage trend test
[@cochran1954some; @armitage1955tests], which is valid without
assuming HWE, and the allelic test with its allelic odds ratio, which
doubles the effective sample size but assumes HWE
[@sasieni1997genotypes]. Users can optionally fit the same model
hierarchy with Firth's penalized logistic regression [@firth1993bias;
@ploner2023logistf] to obtain stable estimates when a genotype count
is zero or the data are otherwise separated.

`Web-Assotest` is implemented in R as a single `flexdashboard`/Shiny
application [@rcoreteam2024; @chang2024shiny;
@iannone2024flexdashboard], runs entirely in the browser once
deployed, and requires no local software installation or programming
beyond entering the genotype counts into an editable table (see \autoref{fig:example}).

`Web-Assotest` started as a stand-alone Windows programme, `Assotest`,
was later ported to the web, and is now released as open-source
software with substantially extended functionality. This paper describes version 0.99. The source code is available at
<https://github.com/ekstroem/WebAssotest>, and users who do not want
to run the application locally can use it directly in a browser at
<http://ekstroem.com:3838/webassotest/>.


![The web-interface for Web-Assotest. Genotype counts and labels are entered in the top-left panel, analysis options are chosen in the next panel, and the HWE results are shown next to them. The model-comparison diagram, the AIC table, and the trend and allelic tests are shown below. Results can be saved as a screenshot, a PDF of the diagram, or a CSV file from the top-right panel.\label{fig:example}](figure.png)

# Statement of need

Testing whether a genetic variant is associated with a disease or
trait from a simple genotype-by-outcome count table is one of the most
common analyses in applied genetic epidemiology, and it is one that
many applied researchers (clinicians, wet-lab biologists, or students)
need to perform without necessarily writing R or Python code
themselves.

The statistical subtlety is that "the" genetic effect is not a single
quantity: the same data can be tested under a dominant, recessive,
additive, or fully genotypic model, and these choices are not
interchangeable. A variant that shows a strong dominant effect can
show a null recessive effect, and vice versa. We use "additive" for
the log-additive (per-allele) model and "genotypic" for the
two-degrees-of-freedom model, since "co-dominant" is used for either
in the literature.


Existing options for this analysis are either large, general-purpose
genetics toolchains aimed at genome-wide data (e.g., PLINK
[@purcell2007plink]) that are overkill and require command-line
fluency for a single $3\times2$ table, or R packages such as `SNPassoc`
[@gonzalez2007snpassoc] that require the user to already be working in R. `Web-Assotest` fills the
gap between these: a lightweight, model-comprehensive, point-and-click
tool for the single-marker case, so that the choice of genetic model
is made visible and testable rather than assumed.

The exact HWE test of @wigginton2005note is bundled so that
genotyping-quality checks and the full set of association tests and
their extensions are easily available in one place.

The tool has been used as teaching material for case-control study
design and has been applied by researchers in several independent
groups in their applied genetics research (see Research impact statement below).

# State of the field

Users who need to analyse a single genotype-by-outcome table have
three main kinds of alternatives. Whole-genome toolchains such as
PLINK are powerful for genome-wide data, but require installation,
input files in specific formats, and command-line fluency, and
specification of the different genetic inheritance models, which is a
heavy burden for a single marker. R packages for candidate-gene
association, such as `SNPassoc`, fit the same
family of genetic models and are flexible, but require the user to
program in R, which excludes many clinical and laboratory
collaborators. Finally, standalone online calculators (e.g., HWE
calculators) typically provide either an HWE test or a single allelic
or trend test, not a comparison of genetic models. Two web tools come
closer. SNPStats [@sole2006snpstats] fits the same genetic models, but
requires an uploaded file of individual-level genotype data.
GeneRiskCalc [@sudershan2025generiskcalc] works from genotype counts
and reports HWE tests and odds ratios with forest plots under several
genetic models, but does not test the models against each other.
`Web-Assotest` needs only the summary genotype counts, so it can also
re-analyse counts reported in published tables (e.g., for teaching or
meta-analysis) without any individual-level data leaving the user, and
it formally compares the nested models through likelihood-ratio tests
and AIC.

`Web-Assotest` differs from all of the above by combining (a) a
no-install, browser-based interface, (b) simultaneous fitting and
visual comparison of all standard genetic models rather than a single
pre-chosen contrast, together with the trend and allelic tests, and
(c) an integrated HWE check, in one small single-file application.

# Software design

**A browser application rather than an R package.** The main design
decision was to deliver the analysis as a web application rather than
as functions in an R package. Packages such as `SNPassoc`
[@gonzalez2007snpassoc] offer scriptability and reproducibility, but
exclude the clinicians and laboratory scientists who generate most
single-marker data. A browser interface removes the need for
installation and programming, at the cost that the analysis is not
recorded as code. This cost is addressed by the exports described
below, and by keeping the statistical core in plain R functions that
can be tested and reused outside the interface.

**A single file with few dependencies.** `Web-Assotest` is one R
Markdown file built with `flexdashboard` and Shiny
[@iannone2024flexdashboard; @chang2024shiny], with interface and
server logic in the same document. Deployment is therefore a single
file copy to any Shiny server, and the code is easy to audit, which
matters for a tool that must remain available for many years on modest
infrastructure. For the same reason, the exact HWE test of
@wigginton2005note and the trend and allelic tests are implemented in
base R rather than imported from genetics packages; the only
dependencies are `flexdashboard`, `rhandsontable`, `shinyscreenshot`,
and `logistf`.

**Fitting all models at once.** Instead of asking the user to choose a
genetic model in advance, every edit to the $3\times2$ table refits all
five nested logistic-regression models, and the likelihood-ratio tests
between them are drawn as a diagram. The choice of genetic model is
thereby made visible and testable rather than assumed, and the diagram
shows which simplifications the data support. In the standard mode the
models are fitted to the six grouped counts rather than to
individual-level data, so refits are near-instant and the results
update as the counts are typed.

**Sparse data.** Zero cells are common in small candidate-gene studies
and make standard odds ratios infinite or undefined. By default the
tool uses standard logistic regression, which matches most published
analyses, and falls back to Fisher's exact test for the affected
contrasts. Alternatively, Firth's penalized regression
[@firth1993bias; @ploner2023logistf] can be switched on; it gives
finite estimates and profile-likelihood confidence intervals without
the fallback, at the cost of slightly shrunken estimates and slower
fitting for large samples.

**Documentation of results.** A known drawback of point-and-click
tools is that, unlike a script, they leave no record of how a result
was obtained. `Web-Assotest` therefore makes every analysis exportable
for subsequent documentation. The CSV file records the entered
genotype counts, the settings used (regression method, HWE test,
genotype labels, application version, and date), and all estimates and
tests: odds ratios with confidence intervals and the likelihood-ratio,
trend, allelic, and HWE tests. The model-comparison diagram can be
saved as a vector PDF for manuscripts, and a screenshot captures the
complete interface. Users can thus archive the analysis with their
study data, report it in a publication, and reproduce it later by
re-entering the saved counts and settings.

**Testing.** The statistical core is checked by `tests/check.R`, which
compares the application's functions with direct `glm`, `fisher.test`,
and `prop.trend.test` results, including zero cells, separation,
monomorphic groups, and extremely small p-values. The checks run
automatically on every push via GitHub Actions.

# Research impact statement

`Web-Assotest` (and its predecessor) has been used in published
candidate-gene case-control studies spanning more than two decades
(2004–2025) and a broad range of research groups and populations,
including Danish, Polish, Iranian, Japanese, Iraqi, and Indian
cohorts, and a wide range of phenotypes, for example:

- **Type 2 diabetes and its complications**, including diabetic
  retinopathy and diabetic foot [@hansen2004large;
  @hansen2005variation; @keshavarz2006no; @mrozikiewicz2017role;
  @gohari2020single].
- **Obesity, adipokines, and ageing** [@roszkowska2012total;
  @al2019fto].
- **Cardiovascular disease**, including essential hypertension and
  acute coronary syndrome [@wrzosek2015impact; @gutowska2025advanced].
- **Psychiatric and behavioural phenotypes**, including completed
  suicide, opioid dependence, and paraphilic sexual offending
  [@chojnicka2012analysis; @chojnicka2013possible;
  @chojnicka2014inverse; @fudalej2016disc1; @jakubczyk2017paraphilic].
- **Neurodegenerative disease** (late-onset Alzheimer's disease)
  [@fatemi2023tbx21].
- **Autoimmune disease** (Graves' disease) [@kurylowicz2007association].
- **Ophthalmology** (Fuchs endothelial corneal dystrophy)
  [@oldak2015fuchs].
- **Gastrointestinal disease** (colonic diverticulosis)
  [@nehring2023genetic].
- **Reproductive health** (recurrent miscarriage)
  [@sudhir2016association].

This breadth shows a recurring need across clinical specialties for a
quick, transparent comparison of genetic inheritance models for a
single marker by researchers who are not statistical programmers.

# AI usage disclosure

AI has been used to correct this manuscript for spelling, and Claude
Code was used to assemble the initial list of papers citing
`Web-Assotest`; the list was subsequently curated manually. The
statistical methodology and the model-comparison design of
`webassotest.Rmd` predate AI tools. Claude Code was used to update the
`flexdashboard` layout, to speed up the reactive expressions, and to
refactor parts of the statistical core (formatting and Fisher's-exact
helpers, the structure of the returned results). It was also used to
implement the trend and allelic tests, the diagram legend, the PDF export, the complete CSV record,
numerical fixes (HWE for monomorphic groups, upper-tail p-values), and
the `tests/check.R` self-checks. All changes were reviewed by the
author and are checked by `tests/check.R`.


# Acknowledgements

I am grateful to Bendix Carstensen who helped form an initial version
of the `Assotest` programme. I am also grateful to the users who have provided
encouragement throughout the years to make sure that the application
was kept available as an online application and continually developed.
This work received no specific funding.


# References
