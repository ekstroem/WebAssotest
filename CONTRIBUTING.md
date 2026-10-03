# Contributing to Web-Assotest

Thank you for your interest in Web-Assotest. Bug reports, questions, and contributions are all welcome.

## Reporting issues

Please open an issue on the [GitHub issue tracker](https://github.com/ekstroem/WebAssotest/issues). To help reproduce the problem, include:

* the genotype counts you entered and the settings you used — the CSV export contains both;
* what you expected to see and what you saw instead (a screenshot helps);
* whether you used the online version or ran the app locally (and, if locally, your R version).

## Seeking support

Questions about using the tool or interpreting its results can also be asked on the [issue tracker](https://github.com/ekstroem/WebAssotest/issues). Please use the "question" label.

## Contributing code

1. Fork the repository and create a branch for your change.
2. Make your change in `webassotest.Rmd`. Please keep the single-file design and avoid adding new package dependencies unless they are clearly needed.
3. If you add or change a statistical function, add a check to `tests/check.R`.
4. Run the checks and make sure they pass:

   ```sh
   Rscript tests/check.R
   ```

5. Run the app locally (`rmarkdown::run("webassotest.Rmd")`) and check that your change works in the browser.
6. Open a pull request that describes what you changed and why.

For larger changes, please open an issue first so the change can be discussed before you start.

## Governance

Web-Assotest is maintained by Claus Thorn Ekstrøm, who reviews and merges contributions and decides on releases. Design decisions are discussed openly in the issue tracker. Changes are listed in [NEWS.md](NEWS.md).
