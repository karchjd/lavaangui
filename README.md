# lavaangui

![R CMD CHECK](https://github.com/karchjd/lavaangui/actions/workflows/R-CMD-check.yaml/badge.svg
)
![Tests](https://github.com/karchjd/lavaangui/actions/workflows/playwright-test.yaml/badge.svg)

![contributions](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)
[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)



The `lavaangui` package provides a free, open-source graphical user interface for the [lavaan](https://lavaan.ugent.be) package. The core feature is that models can be specified by drawing path diagrams and fitted models visualized via interactive path diagrams.

There are three main ways to use the `lavaangui` package.

1.  **Web application:** The easiest is to visit [https://lavaangui.org/](https://solo-fsw.shinyapps.io/lavaangui/) and use it as a web application. This requires no additional software besides a web browser. The main downside of this is that the webserver is likely slower than your computer. So, fitting complicated models might take a long time. The app is likely also more responsive on your computer.

2. **Local web application:** After installing the  `lavaangui` package (see below), you can start a local version of the web application via the `lavaangui()` command.

3. **Interactive plots:** `lavaangui` can also be used for plotting `lavaan` models that were created in R. For this, use `plot_lavaan(fit)`. This will create a path diagram of your model. The core difference compared to other packages for plotting `lavaan` models is that the resulting plot is interactive. That is, you can change its appearance easily, for example, by dragging around nodes with your mouse.

An extensive tutorial on using `lavaangui` is available at https://osf.io/preprints/psyarxiv/f4ary.

# Getting Started

## Web application

For the web application, no installation is necessary. Simply go to [https://lavaangui.org/](https://solo-fsw.shinyapps.io/lavaangui/). The web application should work with any modern browser. It is continuously being tested with: Chrome, Edge, Safari, Firefox, and Opera. 

## R Package

### Installation

You can install the latest version of the R package as usual using the following command:

```
install.packages("lavaangui")
```

### `lavaangui()`

You can start the `lavaangui` web application by typing 

```
library(lavaangui)
lavaangui()
```

into your R console.

Alternatively, you can also use the command `lavaangui(fit)`, where `fit` is any supported fitted lavaan object. This will initialize the web application with the model (and data) contained in fit. For example, the following code initializes the web application with a three factor model.

```{r, eval = FALSE}
library(lavaan)
library(lavaangui)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
lavangui(fit)
```

### `plot_lavaan()`

To obtain an interactive plot of your fitted model without leaving R Studio, use the `plot_lavaan(fit)` function:

```{r, eval = FALSE}
library(lavaan)
library(lavaangui)
HS.model <- ' visual  =~ x1 + x2 + x3
              textual =~ x4 + x5 + x6
              speed   =~ x7 + x8 + x9 '

fit <- cfa(HS.model, data = HolzingerSwineford1939)
plot_lavaan(fit)
```

# Cite

If you use `lavaangui` in your research, please cite the following paper:

Karch, J. D. (2025). lavaangui: A Web-Based Graphical Interface for Specifying Lavaan Models by Drawing Path Diagrams. *Structural Equation Modeling: A Multidisciplinary Journal*, 1-12. https://doi.org/10.1080/10705511.2024.2420678




