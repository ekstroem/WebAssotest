# Self-check for the pure functions in webassotest.Rmd.
# Run from the project root:  Rscript tests/check.R
#
# Evaluates the setup chunk up to the first reactive (the pure functions
# only), then checks results against direct glm/Fisher/stats computations.

rmd   <- readLines("webassotest.Rmd")
start <- grep("^```\\{r setup", rmd) + 1
end   <- grep("^# Reads the edited rhandsontable", rmd) - 1
eval(parse(text = rmd[start:end]))

ca <- c(30L, 50L, 20L)
co <- c(60L, 30L, 10L)

pdf(NULL)   # gtm() draws; send plots nowhere

# Standard mode: ORs and LRTs match a direct glm fit
res <- gtm(ca, co)
g   <- glm(cbind(ca, co) ~ factor(1:3), family = binomial)
stopifnot(all.equal(res$models$OR[5:6], unname(exp(coef(g)[-1]))))
n   <- glm(cbind(ca, co) ~ 1, family = binomial)
stopifnot(all.equal(res$tests$Chisq[4], deviance(n) - deviance(g)))
stopifnot(nrow(res$tests) == 7, !anyNA(res$tests$p_value))

# Zero cell: Fisher OR replaces glm for Het vs WT
z  <- gtm(c(10L, 0L, 5L), c(20L, 5L, 7L))
stopifnot(all.equal(z$models$OR[5],
                    unname(fisher.test(rbind(c(20, 5), c(10, 0)))$estimate)))

# Firth mode runs and gives finite ORs under separation
f <- gtm(c(10L, 0L, 5L), c(20L, 5L, 7L), firth = TRUE)
stopifnot(all(is.finite(f$models$OR[-1])))

# HWE: monomorphic group no longer gives NaN
h <- hwe_pvalues(c(40L, 0L, 0L), co)
stopifnot(h$p.ca == 1, !is.nan(h$p.2))
stopifnot(SNPHWE(50, 25, 25) == 1)   # table exactly at HWE

# Small p-values are not printed as 0.000
stopifnot(fmt_p(1e-10) == "1e-10", p_lab(1e-42) == "p=1e-42", p_lab(0) == "p<1e-300")

# Trend test matches prop.trend.test; allelic OR matches hand calculation
a <- allelic_tests(ca, co)
stopifnot(all.equal(a$Chisq[1], unname(prop.trend.test(ca, ca + co)$statistic)))
al_ca <- c(2 * ca[1] + ca[2], ca[2] + 2 * ca[3])
al_co <- c(2 * co[1] + co[2], co[2] + 2 * co[3])
stopifnot(all.equal(a$OR[2], (al_ca[2] * al_co[1]) / (al_ca[1] * al_co[2])))

# Monomorphic sample: allelic chi-square is NA, not an error
m <- allelic_tests(c(10L, 0L, 0L), c(20L, 0L, 0L))
stopifnot(is.na(m$Chisq[2]))

cat("All checks passed\n")
