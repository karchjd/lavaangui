# lavaangui

![R CMD CHECK](https://github.com/karchjd/lavaangui/actions/workflows/R-CMD-check.yaml/badge.svg
)
![Playwright Tests](https://github.com/karchjd/lavaangui/actions/workflows/playwright-test.yaml/badge.svg
)
[![](https://tokei.rs/b1/github/XAMPPRocky/tokei)](https://github.com/karchjd/lavaangui).
![contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)


The `lavaangui` package provides a free, open-source graphical user interface for the [lavaan](https://lavaan.org/) package. The core feature is that models can be specified by drawing path diagrams and fitted models visualized via interactive path diagrams.

There are three main ways to use the `lavaangui` package.

1.  **Web application:** The easiest is to visit <http://lavaangui.org/> and use it as a web application. This requires no additional software besides a web browser. The main downside of this is that the webserver is likely slower than your computer. So, fitting complicated models might take a long time.

2. **Local web application:** After installing the  `lavaangui` package (see below), you can start a local version of the web application via the `start_gui()` command.

3. **Interactive plots:** `lavaangui` can also be used for plotting `lavaan` models that were created in R. For this, use `plot_interactive(fit)`. This will create a path diagram of your model. The core difference compared to other packages for plotting `lavaan` models is that the resulting plot is interactive. That is, you can change its appearance easily, for example, by dragging around nodes with your mouse.

# Getting Started

## Web application

For the web application, no installation is necessary. Simply go to <http://lavaangui.org/>. The web application requires a modern browser. It is continuously being tested on Chrome. However, it should also work on Firefox, Safari, and Edge. Please let me know if you find any bugs.

## R Package

### Installation

Only Windows users first need to install [Rtools](https://cran.r-project.org/bin/windows/Rtools/). Then, you can install the latest version of the R package via the following commands.

```
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github("karchjd/lavaangui")
```

### `start_gui`

You can start the `lavaangui` web application by typing 

```
library(lavaangui)
start_gui()
```

into your R console.

Alternatively, you can also use the command `start_gui(fit)`, where `fit` is any supported fitted lavaan object. This will initialize the web application with the model (and data) contained in fit. For example, the following code initializes the web application with a three factor model.

```{r, eval = FALSE}
library(lavaan)
library(lavaangui)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
start_gui(fit)
```

### `plot_interactive`

To obtain an interactive plot of your fitted model without leaving R Studio, use the `plot_interactive(fit)` function:

```{r, eval = FALSE}
library(lavaan)
library(lavaangui)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
plot_interactive(fit)
```



